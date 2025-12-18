# generators/user_story_generator.py
# ============================================================================
# PURPOSE: Transform requirements into well-formed user stories
#
# This module transforms raw requirements (from Excel/Word/Lucidchart parsers)
# into standardized user stories with acceptance criteria.
#
# KEY FEATURES:
#   - Loads acceptance patterns and requirement templates from YAML configs
#   - Auto-detects requirement type from Type column or keyword matching
#   - Generates acceptance criteria from patterns (WHAT success looks like)
#   - Uses template's category_abbrev for Story ID: PREFIX-CATEGORY-SEQ
#   - Fills placeholders from requirement context
#
# SEPARATION OF CONCERNS:
#   - Acceptance Criteria (this file): WHAT success looks like
#   - UAT Test Cases (uat_generator.py): HOW to verify it works
#
# AVIATION ANALOGY:
#   Like creating a flight plan from raw data - we use ALL available information
#   (weather, NOTAMs, aircraft performance, crew status) not just the basics.
#   The acceptance criteria define "mission success" while UAT test cases
#   define the verification procedures.
#
# ============================================================================

import re
import os
from pathlib import Path
from typing import Optional
from difflib import SequenceMatcher

# YAML for loading config files
try:
    import yaml
except ImportError:
    raise ImportError("PyYAML required. Install with: pip3 install pyyaml")


class UserStoryGenerator:
    """
    PURPOSE:
        Transform raw requirements into well-formed user stories using
        config-driven acceptance criteria patterns.

    KEY FEATURES:
        - Loads patterns from config/acceptance_patterns.yaml
        - Loads templates from config/requirement_templates.yaml
        - Auto-detects requirement type via keywords
        - Generates acceptance criteria (not test cases)
        - Story IDs: PREFIX-CATEGORY-SEQ (e.g., PROP-RECRUIT-001)

    OUTPUT STRUCTURE:
        {
            "generated_id": "PROP-RECRUIT-001",
            "title": "...",
            "user_story": "As a [role], I want [capability], so that [benefit]",
            "priority": "High",
            "role": "research coordinator",
            "capability": "...",
            "benefit": "...",
            "requirement_type": "recruitment_analytics",
            "category_abbrev": "RECRUIT",
            "is_technical": True,
            "acceptance_criteria": [
                "ACCEPTANCE CRITERIA:",
                "• Count of invited patients displays accurately",
                "• Metrics are segmented by program/channel",
                "",
                "SUCCESS METRICS:",
                "• Zero discrepancy between source and display"
            ],
            "description": "...",
            "flags": [...],
            "source_requirement": {...}
        }

    USAGE:
        generator = UserStoryGenerator(prefix="PROP")
        stories = generator.generate(requirements)
    """

    def __init__(
        self,
        prefix: str = "REQ",
        default_role: str = "user",
        default_priority: str = "Medium",
        similarity_threshold: float = 0.75,
        config_dir: Optional[str] = None
    ) -> None:
        """
        PURPOSE:
            Initialize the generator and load config files.

        PARAMETERS:
            prefix (str): Prefix for Story IDs (e.g., "PROP", "GRX", "NCCN")
            default_role (str): Default user role when none detected
            default_priority (str): Default priority when none specified
            similarity_threshold (float): Threshold for duplicate detection (0.0-1.0)
            config_dir (str): Path to config directory (default: ./config)
        """
        self.prefix = prefix
        self.default_role = default_role
        self.default_priority = default_priority
        self.similarity_threshold = similarity_threshold

        # Determine config directory
        if config_dir:
            self.config_dir = Path(config_dir)
        else:
            # Default: config/ relative to this file's parent directory
            self.config_dir = Path(__file__).parent.parent / "config"

        # Load configuration files
        self.acceptance_patterns = self._load_yaml("acceptance_patterns.yaml")
        self.requirement_templates = self._load_yaml("requirement_templates.yaml")

        # Track stories for duplicate detection
        self._all_stories: list[dict] = []

        # Track sequence numbers per category
        self._category_sequences: dict[str, int] = {}

        # Statistics
        self.stats = {
            'total_input': 0,
            'total_output': 0,
            'by_type': {},
            'technical': 0,
            'non_technical': 0,
            'duplicates_found': 0,
        }

    # ========================================================================
    # CONFIG LOADING
    # ========================================================================

    def _load_yaml(self, filename: str) -> dict:
        """
        PURPOSE:
            Load a YAML config file.

        PARAMETERS:
            filename (str): Name of the YAML file in config_dir

        RETURNS:
            dict: Parsed YAML content

        RAISES:
            FileNotFoundError: If config file doesn't exist
            yaml.YAMLError: If YAML is malformed
        """
        filepath = self.config_dir / filename

        if not filepath.exists():
            raise FileNotFoundError(
                f"Config file not found: {filepath}\n"
                f"Expected in: {self.config_dir}"
            )

        with open(filepath, 'r', encoding='utf-8') as f:
            content = yaml.safe_load(f)

        return content or {}

    # ========================================================================
    # MAIN GENERATION METHOD
    # ========================================================================

    def generate(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Transform requirements into user stories.

        PARAMETERS:
            requirements (list[dict]): Requirements from parsers with context_columns

        RETURNS:
            list[dict]: List of user story dictionaries
        """
        self.stats['total_input'] = len(requirements)
        stories = []

        for req in requirements:
            story = self._transform_requirement(req)
            if story:
                # Check for duplicates
                if self._is_duplicate(story):
                    self.stats['duplicates_found'] += 1
                    story['flags'].append('potential_duplicate')

                stories.append(story)
                self._all_stories.append(story)

        self.stats['total_output'] = len(stories)
        return stories

    def _transform_requirement(self, req: dict) -> Optional[dict]:
        """
        PURPOSE:
            Transform a single requirement into a user story.

        APPROACH:
            1. Build full context from all available text
            2. Detect requirement type (from Type column or keywords)
            3. Get template for that type
            4. Generate Story ID using template's category_abbrev
            5. Extract role, capability, benefit
            6. Generate acceptance criteria from patterns
            7. Build complete story dict
        """
        # Get all available text for analysis
        full_context = self._build_full_context(req)

        # Detect requirement type and get template
        req_type, template = self._detect_requirement_type(req, full_context)

        # Check if technical or non-technical
        is_technical = template.get('is_technical', True)

        # Update stats
        self.stats['by_type'][req_type] = self.stats['by_type'].get(req_type, 0) + 1
        if is_technical:
            self.stats['technical'] += 1
        else:
            self.stats['non_technical'] += 1

        # Get category abbreviation for Story ID
        category_abbrev = template.get('category_abbrev', 'GEN')

        # Generate Story ID: PREFIX-CATEGORY-SEQ
        story_id = self._generate_story_id(category_abbrev)

        # Extract story components
        role = self._extract_role(req, full_context, template)
        capability = self._extract_capability(req, full_context)
        benefit = self._extract_benefit(req, full_context, template)

        # Build user story text
        if is_technical:
            user_story = f"As a {role}, I want to {capability}, so that {benefit}"
        else:
            # Non-technical items use different format
            user_story = self._build_non_technical_summary(req, req_type, full_context)

        # Generate acceptance criteria from patterns
        if is_technical:
            acceptance_criteria = self._generate_acceptance_criteria(req, full_context, template)
        else:
            acceptance_criteria = self._generate_non_technical_criteria(req, req_type, template)

        # Build description with context
        description = self._build_rich_description(req, full_context)

        # Identify flags/issues
        flags = self._identify_flags(req, full_context, is_technical, req_type)

        # Get priority
        priority = req.get('priority', self.default_priority)

        # Build title
        title = self._build_title(req, capability)

        return {
            'generated_id': story_id,
            'title': title,
            'user_story': user_story,
            'priority': priority,
            'role': role,
            'capability': capability,
            'benefit': benefit,
            'requirement_type': req_type,
            'category_abbrev': category_abbrev,
            'is_technical': is_technical,
            'acceptance_criteria': acceptance_criteria,
            'description': description,
            'flags': flags,
            'source_requirement': {
                'requirement_id': req.get('requirement_id'),
                'row_number': req.get('row_number'),
                'source_file': req.get('source_file'),
            }
        }

    # ========================================================================
    # REQUIREMENT TYPE DETECTION
    # ========================================================================

    def _detect_requirement_type(self, req: dict, full_context: str) -> tuple[str, dict]:
        """
        PURPOSE:
            Detect requirement type and return the matching template.

        DETECTION PRIORITY:
            1. Check 'Type' column if present - normalize and match to template
            2. Scan full_context for keywords_to_detect
            3. First template with matching keyword wins
            4. Default to 'general' if no match

        RETURNS:
            tuple: (type_name, template_dict)
        """
        context_lower = full_context.lower()

        # STEP 1: Check explicit Type column
        # ================================================================
        explicit_type = (req.get('type') or '').lower().strip()

        if explicit_type:
            # Try to match explicit type to a template name
            for template_name, template in self.requirement_templates.items():
                # Check if explicit type matches template name or description
                if template_name in explicit_type or explicit_type in template_name:
                    return (template_name, template)

                # Check if explicit type matches any keyword
                for keyword in template.get('keywords_to_detect', []):
                    if keyword in explicit_type:
                        return (template_name, template)

        # STEP 2: Keyword matching on full context
        # ================================================================
        # Check each template's keywords (in order of specificity)
        # More specific templates should be checked first
        priority_order = [
            'recruitment_analytics',  # Very specific
            'consent_management',
            'messaging_notifications',
            'integration',
            'authentication_access',
            'workflow_change',
            'reporting',
            'search_filter',
            'admin_settings',
            'dashboard_reporting',
            'data_management',
            'general',  # Fallback last
        ]

        for template_name in priority_order:
            if template_name not in self.requirement_templates:
                continue

            template = self.requirement_templates[template_name]
            keywords = template.get('keywords_to_detect', [])

            for keyword in keywords:
                if keyword.lower() in context_lower:
                    return (template_name, template)

        # STEP 3: Default to general
        # ================================================================
        return ('general', self.requirement_templates.get('general', {}))

    # ========================================================================
    # STORY ID GENERATION
    # ========================================================================

    def _generate_story_id(self, category_abbrev: str) -> str:
        """
        PURPOSE:
            Generate Story ID in format: PREFIX-CATEGORY-SEQ

        EXAMPLES:
            PROP-RECRUIT-001, PROP-RECRUIT-002, PROP-DASH-001

        PARAMETERS:
            category_abbrev (str): Category abbreviation from template

        RETURNS:
            str: Generated story ID
        """
        # Increment sequence for this category
        if category_abbrev not in self._category_sequences:
            self._category_sequences[category_abbrev] = 0
        self._category_sequences[category_abbrev] += 1

        seq = self._category_sequences[category_abbrev]
        return f"{self.prefix}-{category_abbrev}-{seq:03d}"

    # ========================================================================
    # ACCEPTANCE CRITERIA GENERATION
    # ========================================================================

    def _generate_acceptance_criteria(
        self,
        req: dict,
        full_context: str,
        template: dict
    ) -> list[str]:
        """
        PURPOSE:
            Generate acceptance criteria from patterns.

        OUTPUT FORMAT:
            ACCEPTANCE CRITERIA:
            • [Testable statement 1]
            • [Testable statement 2]

            SUCCESS METRICS:
            • [Metric 1]
            • [Metric 2]

        APPROACH:
            1. Get acceptance_patterns list from template
            2. For each pattern, pull testable_statements
            3. Fill placeholders from requirement context
            4. Add success_metrics section
        """
        criteria = []
        success_metrics = []

        # Get pattern names from template
        pattern_names = template.get('acceptance_patterns', ['dashboard_display'])

        # Collect testable statements and metrics from all patterns
        for pattern_name in pattern_names:
            pattern = self.acceptance_patterns.get(pattern_name, {})

            # Get testable statements
            statements = pattern.get('testable_statements', [])
            for stmt in statements:
                # Fill placeholders
                filled = self._fill_placeholders(stmt, req, full_context)
                criteria.append(f"• {filled}")

            # Get success metrics
            metrics = pattern.get('success_metrics', [])
            for metric in metrics:
                filled = self._fill_placeholders(metric, req, full_context)
                if filled not in success_metrics:  # Dedupe
                    success_metrics.append(filled)

        # Build output
        output = []

        if criteria:
            output.append("ACCEPTANCE CRITERIA:")
            # Deduplicate while preserving order
            seen = set()
            for c in criteria:
                if c not in seen:
                    seen.add(c)
                    output.append(c)

        if success_metrics:
            output.append("")
            output.append("SUCCESS METRICS:")
            for m in success_metrics:
                output.append(f"• {m}")

        return output

    def _fill_placeholders(self, text: str, req: dict, full_context: str) -> str:
        """
        PURPOSE:
            Fill placeholders in pattern text with context from requirement.

        PLACEHOLDERS:
            {X} - numeric value (default: "N")
            {N} - record count (default: "1000")
            {metric} - extracted from title/description
            {dimension} - common dimension (program, channel, date)
            {time_period} - daily/weekly/monthly
            {format} - CSV, Excel
            {patient_status} - from context
            {notification_type} - email, SMS

        APPROACH:
            Try to extract actual values from context, fall back to sensible defaults.
        """
        context_lower = full_context.lower()
        title = req.get('title', '')
        description = req.get('description', '')

        # Extract metric name from title
        metric = title if len(title) < 50 else title[:50]

        # Detect dimension from context
        dimension = "program"
        if "channel" in context_lower:
            dimension = "channel"
        elif "date" in context_lower or "time" in context_lower:
            dimension = "date range"
        elif "site" in context_lower:
            dimension = "site"

        # Detect patient status
        patient_status = "patients"
        for status in ['invited', 'consented', 'enrolled', 'declined', 'eligible']:
            if status in context_lower:
                patient_status = status
                break

        # Detect notification type
        notification_type = "notification"
        for ntype in ['email', 'sms', 'reminder', 'alert']:
            if ntype in context_lower:
                notification_type = ntype
                break

        # Detect format
        export_format = "CSV/Excel"
        if "pdf" in context_lower:
            export_format = "PDF"
        elif "csv" in context_lower:
            export_format = "CSV"
        elif "excel" in context_lower:
            export_format = "Excel"

        # Extract any numbers from context for {X} and {N}
        # Avoid years (2020-2030) and very large numbers
        numbers = re.findall(r'\b(\d+)\b', full_context)
        valid_numbers = [n for n in numbers if not (2020 <= int(n) <= 2030) and int(n) < 10000]
        x_value = valid_numbers[0] if valid_numbers else "3"  # Default 3 seconds
        n_value = valid_numbers[1] if len(valid_numbers) > 1 else "1000"

        # Fill placeholders
        result = text
        result = result.replace("{metric}", metric)
        result = result.replace("{dimension}", dimension)
        result = result.replace("{patient_status}", patient_status)
        result = result.replace("{notification_type}", notification_type)
        result = result.replace("{format}", export_format)
        result = result.replace("{time_period}", "daily/weekly")
        result = result.replace("{start_stage}", "invitation")
        result = result.replace("{end_stage}", "enrollment")
        result = result.replace("{X}", x_value)
        result = result.replace("{N}", n_value)

        return result

    def _generate_non_technical_criteria(
        self,
        req: dict,
        req_type: str,
        template: dict
    ) -> list[str]:
        """
        PURPOSE:
            Generate criteria for non-technical (workflow change) items.
        """
        output = []
        context_columns = req.get('context_columns', {})

        # Get patterns for this type
        pattern_names = template.get('acceptance_patterns', ['workflow_process'])

        for pattern_name in pattern_names:
            pattern = self.acceptance_patterns.get(pattern_name, {})
            statements = pattern.get('testable_statements', [])

            output.append("PROCESS CHANGE REQUIREMENTS:")
            for stmt in statements:
                output.append(f"• {stmt}")

            metrics = pattern.get('success_metrics', [])
            if metrics:
                output.append("")
                output.append("SUCCESS METRICS:")
                for m in metrics:
                    # Replace {X} with reasonable default
                    m = m.replace("{X}", "2")
                    output.append(f"• {m}")

        # Add notes if available
        notes = context_columns.get('Notes', '') or context_columns.get('Supplemental notes', '')
        if notes:
            output.append("")
            output.append(f"NOTES: {notes[:300]}")

        return output

    # ========================================================================
    # CONTEXT BUILDING
    # ========================================================================

    def _build_full_context(self, req: dict) -> str:
        """
        PURPOSE:
            Combine ALL available text for comprehensive analysis.

        WHY THIS MATTERS:
            Context columns often contain the REAL requirement after stakeholder
            discussion. Notes, Supplemental Notes, Decisions, etc. contain
            refined requirements that supersede the original description.
        """
        parts = []

        # Primary content
        if req.get('title'):
            parts.append(f"Title: {req['title']}")
        if req.get('description'):
            parts.append(f"Description: {req['description']}")

        # ALL context columns
        context_columns = req.get('context_columns', {})
        for col_name, value in context_columns.items():
            if value:
                parts.append(f"{col_name}: {value}")

        # Type info
        if req.get('type'):
            parts.append(f"Type: {req['type']}")

        # Status
        if req.get('status'):
            parts.append(f"Status: {req['status']}")

        return "\n".join(parts)

    # ========================================================================
    # ROLE EXTRACTION
    # ========================================================================

    def _extract_role(self, req: dict, full_context: str, template: dict) -> str:
        """
        PURPOSE:
            Extract user role from context or use template's typical_roles.

        PRIORITY:
            1. Explicit role in text ("As a manager...")
            2. Template's typical_roles[0]
            3. Default role
        """
        context_lower = full_context.lower()

        # Valid roles to look for
        valid_roles = {
            'user', 'admin', 'administrator', 'manager', 'customer',
            'patient', 'clinician', 'doctor', 'nurse', 'staff',
            'analyst', 'researcher', 'coordinator', 'operator',
            'research coordinator', 'program manager', 'data analyst'
        }

        # Look for explicit role mentions
        patterns = [
            r'as\s+an?\s+(\w+(?:\s+\w+)?)',  # "as a research coordinator"
            r'(\w+)\s+(?:shall|must|should|can|will)',
            r'(?:allow|enable)\s+(\w+)s?\s+to',
        ]

        for pattern in patterns:
            match = re.search(pattern, context_lower)
            if match:
                role = match.group(1).lower().strip()
                if role in valid_roles:
                    return role

        # Use template's typical_roles
        typical_roles = template.get('typical_roles', [])
        if typical_roles:
            return typical_roles[0]

        return self.default_role

    # ========================================================================
    # CAPABILITY EXTRACTION
    # ========================================================================

    def _extract_capability(self, req: dict, full_context: str) -> str:
        """
        PURPOSE:
            Extract the core capability from the requirement.
        """
        # Primary source: description, then title
        description = req.get('description') or req.get('title') or ''

        # Clean and extract
        capability = self._clean_capability_text(description)

        return capability

    def _clean_capability_text(self, text: str) -> str:
        """Clean and normalize capability text."""
        # Remove common prefixes
        text = re.sub(r'^(?:the\s+)?system\s+(?:shall|must|should|will)\s+', '', text, flags=re.IGNORECASE)
        text = re.sub(r'^(?:users?\s+)?(?:shall|must|should|will|can)\s+(?:be\s+able\s+to\s+)?', '', text, flags=re.IGNORECASE)
        text = re.sub(r'^(?:allow|enable)\s+(?:users?\s+)?to\s+', '', text, flags=re.IGNORECASE)

        # Remove "so that" clause
        text = re.sub(r'\s+so\s+that\s+.+$', '', text, flags=re.IGNORECASE)
        text = re.sub(r'\s+in\s+order\s+to\s+.+$', '', text, flags=re.IGNORECASE)

        # Clean up
        text = text.strip()
        if text and text[0].isupper():
            text = text[0].lower() + text[1:]

        return text or "access the requested feature"

    # ========================================================================
    # BENEFIT EXTRACTION
    # ========================================================================

    def _extract_benefit(self, req: dict, full_context: str, template: dict) -> str:
        """
        PURPOSE:
            Extract the business benefit from the requirement.
        """
        context_columns = req.get('context_columns', {})

        # Check Impact column first
        for key in ['Impact', 'Business Value', 'Benefit', 'Justification']:
            if key in context_columns and context_columns[key]:
                benefit = context_columns[key]
                benefit = re.sub(r'^(?:to\s+)?', '', benefit, flags=re.IGNORECASE)
                if len(benefit) > 10:
                    benefit = re.sub(r'\bi\b', 'I', benefit)
                    return benefit

        # Look in main text for "so that" clause
        description = req.get('description') or ''
        match = re.search(r'so\s+that\s+(.+?)(?:\.|$)', description, re.IGNORECASE)
        if match:
            benefit = match.group(1).strip()
            benefit = re.sub(r'\bi\b', 'I', benefit)
            return benefit

        # Default based on template type
        template_desc = template.get('description', '')
        if 'analytics' in template_desc.lower():
            return "I can make data-driven decisions"
        elif 'consent' in template_desc.lower():
            return "the process is compliant and documented"
        elif 'recruitment' in template_desc.lower():
            return "I can track and improve outreach effectiveness"
        elif 'notification' in template_desc.lower():
            return "communications are tracked and optimized"

        return "the system meets business requirements"

    # ========================================================================
    # NON-TECHNICAL SUMMARY
    # ========================================================================

    def _build_non_technical_summary(
        self,
        req: dict,
        req_type: str,
        full_context: str
    ) -> str:
        """Build summary for non-technical items (no 'As a...' format)."""
        description = req.get('description') or req.get('title') or ''

        if req_type == 'workflow_change':
            return f"[WORKFLOW CHANGE] {description}"

        return f"[{req_type.upper().replace('_', ' ')}] {description}"

    # ========================================================================
    # DESCRIPTION BUILDING
    # ========================================================================

    def _build_rich_description(self, req: dict, full_context: str) -> str:
        """Build description incorporating context columns."""
        parts = []

        # Main description
        if req.get('description'):
            parts.append(req['description'])

        # Add context from relevant columns
        context_columns = req.get('context_columns', {})

        # Impact is valuable
        if context_columns.get('Impact'):
            parts.append(f"\n**Impact:** {context_columns['Impact']}")

        # Dependencies
        if context_columns.get('Dependencies'):
            parts.append(f"\n**Dependencies:** {context_columns['Dependencies']}")

        # Timeline
        for key in ['Timelines', 'Timeline', 'Target Date']:
            if key in context_columns:
                parts.append(f"\n**Timeline:** {context_columns[key]}")
                break

        return " ".join(parts)

    # ========================================================================
    # TITLE BUILDING
    # ========================================================================

    def _build_title(self, req: dict, capability: str) -> str:
        """Build story title."""
        # Prefer original title if available and reasonable
        if req.get('title') and len(req['title']) < 80:
            return req['title']

        # Otherwise derive from capability
        title = capability[:60]
        if len(capability) > 60:
            title += '...'

        return title.title()

    # ========================================================================
    # FLAG IDENTIFICATION
    # ========================================================================

    def _identify_flags(
        self,
        req: dict,
        full_context: str,
        is_technical: bool,
        req_type: str
    ) -> list[str]:
        """Identify issues that need attention."""
        flags = []

        # Non-technical items always flagged
        if not is_technical:
            flags.append('workflow_change')

        # Check status for completed/out-of-scope
        status = (req.get('status') or '').lower()
        if any(kw in status for kw in ['complete', 'done', 'finished', 'live']):
            flags.append('completed')
        if any(kw in status for kw in ['out of scope', 'deferred', 'cancelled']):
            flags.append('out_of_scope')

        # Check for vague language
        vague_terms = self._check_vague_language(full_context)
        if vague_terms:
            flags.append('vague_language')

        # Check for questions/uncertainties
        if self._has_uncertainties(full_context):
            flags.append('needs_clarification')

        return flags

    def _check_vague_language(self, text: str) -> list[str]:
        """Check for vague/non-testable language."""
        vague_patterns = [
            r'\bfast(?:er)?\b', r'\beasy\b', r'\bsimple\b',
            r'\bintuitive\b', r'\befficient\b', r'\brobust\b',
            r'\bseamless\b', r'\bscalable\b', r'\betc\.?\b',
        ]

        found = []
        text_lower = text.lower()
        for pattern in vague_patterns:
            match = re.search(pattern, text_lower)
            if match:
                found.append(match.group(0))

        return found

    def _has_uncertainties(self, text: str) -> bool:
        """Check if text contains uncertainties/questions."""
        uncertainty_patterns = [
            r'\?', r'\btbd\b', r'\bto be determined\b',
            r'\bneed to clarify\b', r'\bneed to discuss\b',
            r'\bprobably\b', r'\bmaybe\b'
        ]

        text_lower = text.lower()
        return any(re.search(p, text_lower) for p in uncertainty_patterns)

    # ========================================================================
    # DUPLICATE DETECTION
    # ========================================================================

    def _is_duplicate(self, story: dict) -> bool:
        """Check if story is similar to existing ones."""
        if not self._all_stories:
            return False

        story_text = story.get('capability', '') + story.get('title', '')

        for existing in self._all_stories:
            existing_text = existing.get('capability', '') + existing.get('title', '')
            similarity = SequenceMatcher(None, story_text, existing_text).ratio()
            if similarity >= self.similarity_threshold:
                return True

        return False

    # ========================================================================
    # STATISTICS
    # ========================================================================

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_user_stories(
    requirements: list[dict],
    prefix: str = "REQ",
    default_role: str = "user"
) -> list[dict]:
    """
    PURPOSE:
        Convenience function to generate user stories.

    PARAMETERS:
        requirements (list[dict]): Requirements from parsers
        prefix (str): Prefix for Story IDs (e.g., "PROP", "GRX")
        default_role (str): Default user role

    RETURNS:
        list[dict]: List of user story dictionaries
    """
    generator = UserStoryGenerator(prefix=prefix, default_role=default_role)
    return generator.generate(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("USER STORY GENERATOR TEST (Config-Driven)")
    print("=" * 70)

    # Sample requirements with context_columns
    sample_requirements = [
        {
            'title': 'Number (N) Invited',
            'description': 'Track number of patients who received invitations',
            'priority': 'High',
            'status': 'Planned',
            'type': 'Recruitment Analytics',
            'row_number': 2,
            'context_columns': {
                'Impact': 'Core metric for outreach effectiveness',
                'Dependencies': 'Should be part of analytics dashboard',
                'Notes': 'Updated requirement after stakeholder meeting',
                'Timelines': '2025 Q4'
            }
        },
        {
            'title': 'Email Opt-Out Tracking',
            'description': 'Track when patients opt out of email reminders',
            'priority': 'Medium',
            'status': 'Planned',
            'type': 'Messaging',
            'row_number': 3,
            'context_columns': {
                'Impact': 'Compliance requirement for CAN-SPAM',
                'Dependencies': 'Email service integration',
            }
        },
        {
            'title': 'Manual Review Process',
            'description': 'Update the manual review workflow for data validation',
            'priority': 'Low',
            'status': 'Planned',
            'type': 'Process',
            'row_number': 4,
            'context_columns': {
                'Notes': 'This is a workflow change, not a technical feature',
            }
        },
    ]

    try:
        generator = UserStoryGenerator(prefix="TEST")
        stories = generator.generate(sample_requirements)

        print(f"\nGenerated {len(stories)} stories:")
        for story in stories:
            print(f"\n{'─'*70}")
            print(f"ID: {story['generated_id']}")
            print(f"Title: {story['title']}")
            print(f"Type: {story['requirement_type']} ({story['category_abbrev']})")
            print(f"Technical: {story['is_technical']}")
            print(f"Priority: {story['priority']}")
            print(f"\nUser Story:\n  {story['user_story']}")
            print(f"\nAcceptance Criteria:")
            for ac in story['acceptance_criteria']:
                print(f"  {ac}")
            if story['flags']:
                print(f"\nFlags: {', '.join(story['flags'])}")

        print(f"\n{'='*70}")
        print("Stats:", generator.get_stats())

    except FileNotFoundError as e:
        print(f"\nERROR: {e}")
        print("\nMake sure config files exist:")
        print("  - config/acceptance_patterns.yaml")
        print("  - config/requirement_templates.yaml")
