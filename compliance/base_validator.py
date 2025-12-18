# compliance/base_validator.py
# ============================================================================
# PURPOSE: Base class for all compliance validators
#
# This provides the common structure and methods that all compliance validators
# (Part 11, HIPAA, SOC 2) inherit from. Think of it like a template or interface
# that ensures all validators work the same way.
#
# AVIATION ANALOGY:
#     This is like a standard checklist format that all airlines use. Whether
#     you're doing a pre-flight check, engine start, or approach checklist,
#     they all follow the same structure: challenge-response items that can
#     be marked complete, with notes for deviations.
#
# R EQUIVALENT:
#     Like creating an R6 class that other classes inherit from:
#     BaseValidator <- R6Class("BaseValidator", public = list(...))
#     Part11Validator <- R6Class("Part11Validator", inherit = BaseValidator)
#
# ============================================================================

import re
from abc import ABC, abstractmethod
from typing import Optional
from datetime import datetime
from pathlib import Path
import yaml


class BaseValidator(ABC):
    """
    PURPOSE:
        Abstract base class for compliance validators.
        Defines the interface that all validators must implement.

    R EQUIVALENT:
        Like an R6 class with abstract methods that subclasses must override.
        In R you'd use stop("Not implemented") in the base class.

    WHY ABSTRACT:
        We never instantiate BaseValidator directly. It's a template that
        ensures all validators have the same methods and return formats.

    SUBCLASSES:
        - Part11Validator: FDA 21 CFR Part 11 electronic records
        - HIPAAValidator: HIPAA privacy and security rules
        - SOC2Validator: SOC 2 Trust Services Criteria
    """

    def __init__(
        self,
        config_path: Optional[str] = None,
        prefix: str = "COMP"
    ) -> None:
        """
        PURPOSE:
            Initialize the validator with configuration.

        PARAMETERS:
            config_path (str, optional): Path to YAML config file with controls.
                                        If None, uses default config.
            prefix (str): Prefix for generated IDs (default: "COMP")

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            Configuration allows customization of control checklists without
            code changes. The prefix ensures generated IDs are identifiable.
        """
        self.prefix = prefix
        self.config_path = config_path

        # Will hold loaded control definitions
        self.controls: list[dict] = []

        # Statistics tracking
        self.stats = {
            'requirements_scanned': 0,
            'gaps_found': 0,
            'controls_checked': 0,
            'compliant_items': 0
        }

        # Store scan results
        self.gap_analysis: list[dict] = []

        # Load controls from config
        self._load_controls()

    # ========================================================================
    # ABSTRACT METHODS - Subclasses MUST implement these
    # ========================================================================

    @abstractmethod
    def _load_controls(self) -> None:
        """
        PURPOSE:
            Load control definitions from config file.
            Each subclass loads its specific controls (Part 11, HIPAA, etc.)

        WHY ABSTRACT:
            Each compliance framework has different controls.
            Part 11 has audit trails, HIPAA has safeguards, SOC 2 has TSCs.
        """
        pass

    @abstractmethod
    def _get_default_config_path(self) -> str:
        """
        PURPOSE:
            Return path to default config file for this validator.

        RETURNS:
            str: Path to YAML config file

        WHY ABSTRACT:
            Each validator has its own config file.
        """
        pass

    @abstractmethod
    def _categorize_requirement(self, requirement: dict) -> list[str]:
        """
        PURPOSE:
            Determine which compliance categories apply to a requirement.

        PARAMETERS:
            requirement (dict): Requirement dictionary from parser

        RETURNS:
            list[str]: Categories that apply (e.g., ['audit_trail', 'access_control'])

        WHY ABSTRACT:
            Each compliance framework has different categories.
        """
        pass

    @abstractmethod
    def _check_controls(self, requirement: dict, categories: list[str]) -> list[dict]:
        """
        PURPOSE:
            Check which controls are missing for a requirement.

        PARAMETERS:
            requirement (dict): Requirement dictionary
            categories (list[str]): Applicable categories

        RETURNS:
            list[dict]: Missing controls with details

        WHY ABSTRACT:
            Each framework has different control checking logic.
        """
        pass

    # ========================================================================
    # COMMON METHODS - Shared by all validators
    # ========================================================================

    def scan_requirements(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Scan a list of requirements for compliance gaps.
            Main entry point for validation.

        PARAMETERS:
            requirements (list[dict]): Requirements from parser output

        RETURNS:
            list[dict]: Gap analysis results for each requirement

        R EQUIVALENT:
            Like purrr::map(requirements, ~ check_compliance(.x))
            Returns a list of results for each input requirement.

        WHY THIS APPROACH:
            We scan ALL requirements, not just ones explicitly marked as
            compliance-related. A "patient data" requirement needs HIPAA
            controls even if the author didn't explicitly mention HIPAA.
        """
        self.gap_analysis = []
        self.stats = {
            'requirements_scanned': 0,
            'gaps_found': 0,
            'controls_checked': 0,
            'compliant_items': 0
        }

        for requirement in requirements:
            self.stats['requirements_scanned'] += 1

            # Determine applicable categories
            categories = self._categorize_requirement(requirement)

            if not categories:
                # Requirement doesn't trigger compliance checks
                continue

            # Check for missing controls
            missing_controls = self._check_controls(requirement, categories)
            self.stats['controls_checked'] += len(self.controls)

            # Build gap analysis entry
            gap_entry = {
                'requirement_id': requirement.get('requirement_id', 'UNKNOWN'),
                'requirement_text': requirement.get('description', requirement.get('raw_text', '')),
                'source': requirement.get('source_cell', ''),
                'categories': categories,
                'missing_controls': missing_controls,
                'existing_controls': self._find_existing_controls(requirement, categories),
                'gap_count': len(missing_controls),
                'compliant': len(missing_controls) == 0,
                'recommendations': self._generate_recommendations(missing_controls)
            }

            if missing_controls:
                self.stats['gaps_found'] += len(missing_controls)
            else:
                self.stats['compliant_items'] += 1

            self.gap_analysis.append(gap_entry)

        return self.gap_analysis

    def flag_gaps(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Return only the requirements that have compliance gaps.
            Convenience method for filtering.

        PARAMETERS:
            requirements (list[dict]): Requirements to scan

        RETURNS:
            list[dict]: Only requirements with gaps (non-compliant)

        R EQUIVALENT:
            Like dplyr::filter(gap_analysis, gap_count > 0)
        """
        if not self.gap_analysis:
            self.scan_requirements(requirements)

        return [g for g in self.gap_analysis if not g['compliant']]

    def generate_report(
        self,
        requirements: list[dict],
        output_format: str = 'dict'
    ) -> dict:
        """
        PURPOSE:
            Generate a comprehensive compliance report.

        PARAMETERS:
            requirements (list[dict]): Requirements to analyze
            output_format (str): 'dict', 'markdown', or 'summary'

        RETURNS:
            dict: Complete compliance report

        WHY THIS APPROACH:
            The report aggregates all findings into a structured format
            that can be used for documentation, presentations, or audits.
        """
        if not self.gap_analysis:
            self.scan_requirements(requirements)

        # Calculate summary statistics
        total_scanned = self.stats['requirements_scanned']
        with_gaps = len([g for g in self.gap_analysis if not g['compliant']])
        fully_compliant = len([g for g in self.gap_analysis if g['compliant']])
        total_gaps = self.stats['gaps_found']

        # Group gaps by category
        gaps_by_category = self._group_gaps_by_category()

        # Group gaps by control
        gaps_by_control = self._group_gaps_by_control()

        report = {
            'framework': self._get_framework_name(),
            'generated_at': datetime.now().isoformat(),
            'summary': {
                'total_requirements_scanned': total_scanned,
                'requirements_with_compliance_relevance': len(self.gap_analysis),
                'requirements_with_gaps': with_gaps,
                'fully_compliant_requirements': fully_compliant,
                'total_gaps_found': total_gaps,
                'compliance_score': round(
                    (fully_compliant / len(self.gap_analysis) * 100)
                    if self.gap_analysis else 100, 1
                )
            },
            'gaps_by_category': gaps_by_category,
            'gaps_by_control': gaps_by_control,
            'detailed_findings': self.gap_analysis,
            'recommendations': self._aggregate_recommendations()
        }

        if output_format == 'markdown':
            return self._report_to_markdown(report)
        elif output_format == 'summary':
            return report['summary']

        return report

    # ========================================================================
    # HELPER METHODS
    # ========================================================================

    def _find_existing_controls(
        self,
        requirement: dict,
        categories: list[str]
    ) -> list[dict]:
        """
        PURPOSE:
            Find controls that ARE mentioned in the requirement.

        PARAMETERS:
            requirement (dict): Requirement dictionary
            categories (list[str]): Applicable categories

        RETURNS:
            list[dict]: Controls found in the requirement

        WHY THIS APPROACH:
            Gives credit for controls already present. This helps
            differentiate between requirements that need work vs
            ones that are already well-specified.
        """
        text = self._get_requirement_text(requirement).lower()
        existing = []

        for control in self.controls:
            if control.get('category') not in categories:
                continue

            keywords = control.get('keywords_to_detect', [])
            if any(kw.lower() in text for kw in keywords):
                existing.append({
                    'control_id': control.get('control_id', ''),
                    'description': control.get('description', ''),
                    'category': control.get('category', '')
                })

        return existing

    def _generate_recommendations(self, missing_controls: list[dict]) -> list[str]:
        """
        PURPOSE:
            Generate actionable recommendations for missing controls.

        PARAMETERS:
            missing_controls (list[dict]): Controls that are missing

        RETURNS:
            list[str]: Recommendations to address gaps

        WHY THIS APPROACH:
            Don't just flag gaps - help the user fix them.
        """
        recommendations = []

        for control in missing_controls:
            rec = control.get('recommendation', '')
            if rec and rec not in recommendations:
                recommendations.append(rec)

        return recommendations

    def _group_gaps_by_category(self) -> dict[str, int]:
        """Group gap counts by category."""
        by_category = {}

        for entry in self.gap_analysis:
            for control in entry.get('missing_controls', []):
                cat = control.get('category', 'Unknown')
                by_category[cat] = by_category.get(cat, 0) + 1

        return by_category

    def _group_gaps_by_control(self) -> dict[str, int]:
        """Group gap counts by control ID."""
        by_control = {}

        for entry in self.gap_analysis:
            for control in entry.get('missing_controls', []):
                ctrl_id = control.get('control_id', 'Unknown')
                by_control[ctrl_id] = by_control.get(ctrl_id, 0) + 1

        return by_control

    def _aggregate_recommendations(self) -> list[str]:
        """Collect unique recommendations across all gaps."""
        all_recs = set()

        for entry in self.gap_analysis:
            for rec in entry.get('recommendations', []):
                all_recs.add(rec)

        return list(all_recs)

    def _get_requirement_text(self, requirement: dict) -> str:
        """Extract searchable text from requirement."""
        parts = [
            requirement.get('description', ''),
            requirement.get('raw_text', ''),
            requirement.get('title', ''),
            requirement.get('notes', '')
        ]
        return ' '.join(p for p in parts if p)

    def _get_framework_name(self) -> str:
        """Return the name of this compliance framework."""
        return self.__class__.__name__.replace('Validator', '')

    def _load_yaml_config(self, path: str) -> dict:
        """
        PURPOSE:
            Load a YAML configuration file.

        PARAMETERS:
            path (str): Path to YAML file

        RETURNS:
            dict: Parsed YAML content

        WHY THIS APPROACH:
            YAML is human-readable and easy to edit for customizing controls.
        """
        path = Path(path)
        if not path.exists():
            return {}

        with open(path, 'r') as f:
            return yaml.safe_load(f) or {}

    def _report_to_markdown(self, report: dict) -> str:
        """Convert report to markdown format."""
        lines = []
        framework = report.get('framework', 'Compliance')

        lines.append(f"# {framework} Compliance Report")
        lines.append(f"Generated: {report.get('generated_at', '')[:10]}")
        lines.append("")

        # Summary
        summary = report.get('summary', {})
        lines.append("## Summary")
        lines.append(f"- Requirements scanned: {summary.get('total_requirements_scanned', 0)}")
        lines.append(f"- With compliance relevance: {summary.get('requirements_with_compliance_relevance', 0)}")
        lines.append(f"- Requirements with gaps: {summary.get('requirements_with_gaps', 0)}")
        lines.append(f"- Fully compliant: {summary.get('fully_compliant_requirements', 0)}")
        lines.append(f"- **Compliance score: {summary.get('compliance_score', 0)}%**")
        lines.append("")

        # Gaps by category
        gaps_by_cat = report.get('gaps_by_category', {})
        if gaps_by_cat:
            lines.append("## Gaps by Category")
            for cat, count in sorted(gaps_by_cat.items(), key=lambda x: -x[1]):
                lines.append(f"- {cat}: {count}")
            lines.append("")

        # Top recommendations
        recs = report.get('recommendations', [])
        if recs:
            lines.append("## Key Recommendations")
            for rec in recs[:10]:
                lines.append(f"- {rec}")
            lines.append("")

        return '\n'.join(lines)

    def get_stats(self) -> dict:
        """Return scanning statistics."""
        return self.stats.copy()

    # ========================================================================
    # TEXT MATCHING UTILITIES
    # ========================================================================

    def _text_contains_keywords(self, text: str, keywords: list[str]) -> bool:
        """
        PURPOSE:
            Check if text contains any of the keywords.

        PARAMETERS:
            text (str): Text to search
            keywords (list[str]): Keywords to look for

        RETURNS:
            bool: True if any keyword found

        WHY THIS APPROACH:
            Simple keyword matching is fast and effective for finding
            compliance-relevant terms. More sophisticated NLP could be
            added later if needed.
        """
        text_lower = text.lower()
        return any(kw.lower() in text_lower for kw in keywords)

    def _text_contains_pattern(self, text: str, pattern: str) -> bool:
        """
        PURPOSE:
            Check if text matches a regex pattern.

        PARAMETERS:
            text (str): Text to search
            pattern (str): Regex pattern

        RETURNS:
            bool: True if pattern matches
        """
        return bool(re.search(pattern, text, re.IGNORECASE))
