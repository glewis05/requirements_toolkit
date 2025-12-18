# compliance/part11_validator.py
# ============================================================================
# PURPOSE: Validate requirements against FDA 21 CFR Part 11
#
# 21 CFR Part 11 establishes requirements for electronic records and
# electronic signatures in FDA-regulated industries. Key areas:
# - Audit trails (who changed what, when)
# - Electronic signatures (authentication, meaning, timestamp)
# - Access controls (authorization, lockout, timeout)
# - Data integrity (prevent unauthorized changes)
# - Record retention
#
# AVIATION ANALOGY:
#     Like the FAA requiring specific maintenance records and signatures.
#     Every repair must be documented, signed by authorized personnel,
#     and records kept for the aircraft's lifetime. Part 11 does the
#     same for electronic pharmaceutical/medical device records.
#
# R EQUIVALENT:
#     Like using dplyr to filter requirements and check conditions:
#     requirements %>%
#       filter(involves_electronic_records) %>%
#       mutate(missing_controls = check_part11(.))
#
# ============================================================================

from pathlib import Path
from typing import Optional

from .base_validator import BaseValidator


class Part11Validator(BaseValidator):
    """
    PURPOSE:
        Validate requirements for FDA 21 CFR Part 11 compliance.
        Identifies gaps in audit trail, e-signature, and access control requirements.

    R EQUIVALENT:
        Like an R6 class that inherits from BaseValidator and implements
        Part 11-specific checking logic.

    USAGE:
        validator = Part11Validator(prefix="GRX")
        gaps = validator.scan_requirements(requirements)
        report = validator.generate_report(requirements)

    21 CFR PART 11 OVERVIEW:
        Subpart A - General Provisions
        Subpart B - Electronic Records
            § 11.10 Controls for closed systems
            § 11.30 Controls for open systems
        Subpart C - Electronic Signatures
            § 11.50 Signature manifestations
            § 11.70 Signature/record linking
            § 11.100 General requirements
            § 11.200 Electronic signature components
    """

    # ========================================================================
    # CATEGORY KEYWORDS
    # ========================================================================
    # These keywords help identify which Part 11 categories apply to a requirement

    CATEGORY_KEYWORDS = {
        'audit_trail': [
            'audit', 'log', 'track', 'history', 'record', 'change',
            'modify', 'update', 'edit', 'delete', 'create', 'insert',
            'who', 'when', 'timestamp', 'trail', 'capture', 'document'
        ],
        'electronic_signature': [
            'sign', 'signature', 'approve', 'approval', 'authorize',
            'authorization', 'certify', 'verify', 'attest', 'confirm',
            'e-sign', 'esign', 'esignature', 'digital signature',
            'witness', 'countersign', 'reviewer', 'approver'
        ],
        'access_control': [
            'login', 'logon', 'password', 'authentication', 'access',
            'permission', 'role', 'privilege', 'authorize', 'user',
            'credential', 'identity', 'lockout', 'timeout', 'session',
            'mfa', 'multi-factor', '2fa', 'two-factor'
        ],
        'data_integrity': [
            'integrity', 'validation', 'verify', 'check', 'prevent',
            'protect', 'secure', 'tamper', 'alter', 'corrupt',
            'accurate', 'complete', 'unchanged', 'original',
            'before', 'after', 'previous', 'modified'
        ],
        'record_retention': [
            'retain', 'retention', 'archive', 'store', 'preserve',
            'backup', 'recover', 'restore', 'lifecycle', 'dispose',
            'destroy', 'expiration', 'years', 'permanent'
        ],
        'system_validation': [
            'validate', 'validation', 'qualify', 'qualification',
            'iq', 'oq', 'pq', 'csv', 'gamp', 'test', 'verify'
        ]
    }

    # Keywords that indicate a requirement involves electronic records
    ELECTRONIC_RECORD_KEYWORDS = [
        'data', 'record', 'form', 'report', 'document', 'file',
        'entry', 'field', 'database', 'system', 'application',
        'submit', 'submission', 'electronic', 'digital', 'batch',
        'lot', 'patient', 'sample', 'result', 'certificate',
        'label', 'specification', 'procedure', 'protocol'
    ]

    def __init__(
        self,
        config_path: Optional[str] = None,
        prefix: str = "P11"
    ) -> None:
        """
        PURPOSE:
            Initialize Part 11 validator.

        PARAMETERS:
            config_path (str, optional): Path to custom controls YAML
            prefix (str): Prefix for generated IDs (default: "P11")
        """
        super().__init__(config_path=config_path, prefix=prefix)

    def _get_default_config_path(self) -> str:
        """Return path to default Part 11 controls config."""
        return str(Path(__file__).parent / 'config' / 'part11_controls.yaml')

    def _load_controls(self) -> None:
        """
        PURPOSE:
            Load Part 11 control definitions from config.

        WHY THIS APPROACH:
            Controls are defined in YAML for easy customization.
            If no config exists, we use built-in defaults.
        """
        config_path = self.config_path or self._get_default_config_path()

        try:
            config = self._load_yaml_config(config_path)
            self.controls = config.get('controls', [])
        except Exception:
            # Fall back to default controls
            self.controls = self._get_default_controls()

        if not self.controls:
            self.controls = self._get_default_controls()

    def _get_default_controls(self) -> list[dict]:
        """
        PURPOSE:
            Return built-in Part 11 controls if no config file exists.

        RETURNS:
            list[dict]: Default control definitions

        WHY THIS APPROACH:
            Ensures the validator works out-of-the-box even without config.
        """
        return [
            # Audit Trail Controls (§ 11.10(e))
            {
                'control_id': 'P11-AT-001',
                'description': 'Audit trail must capture who made changes',
                'category': 'audit_trail',
                'keywords_to_detect': ['user', 'who', 'operator', 'person', 'identity'],
                'recommendation': 'Add requirement to capture user identity for all changes'
            },
            {
                'control_id': 'P11-AT-002',
                'description': 'Audit trail must capture when changes were made',
                'category': 'audit_trail',
                'keywords_to_detect': ['timestamp', 'when', 'date', 'time', 'datetime'],
                'recommendation': 'Add requirement to capture timestamp for all changes'
            },
            {
                'control_id': 'P11-AT-003',
                'description': 'Audit trail must capture what was changed (before/after)',
                'category': 'audit_trail',
                'keywords_to_detect': ['before', 'after', 'previous', 'original', 'new value'],
                'recommendation': 'Add requirement to capture before/after values for changes'
            },
            {
                'control_id': 'P11-AT-004',
                'description': 'Audit trail must capture reason for change',
                'category': 'audit_trail',
                'keywords_to_detect': ['reason', 'why', 'justification', 'comment', 'note'],
                'recommendation': 'Add requirement for change reason/justification'
            },
            {
                'control_id': 'P11-AT-005',
                'description': 'Audit trail records must be immutable',
                'category': 'audit_trail',
                'keywords_to_detect': ['immutable', 'append-only', 'cannot delete', 'permanent'],
                'recommendation': 'Add requirement that audit records cannot be modified or deleted'
            },

            # Electronic Signature Controls (§ 11.50, § 11.70, § 11.100)
            {
                'control_id': 'P11-ES-001',
                'description': 'E-signature must include printed name',
                'category': 'electronic_signature',
                'keywords_to_detect': ['name', 'printed name', 'signer name', 'full name'],
                'recommendation': 'Add requirement to display signer printed name with signature'
            },
            {
                'control_id': 'P11-ES-002',
                'description': 'E-signature must include date and time',
                'category': 'electronic_signature',
                'keywords_to_detect': ['date', 'time', 'timestamp', 'when signed'],
                'recommendation': 'Add requirement to capture signature date and time'
            },
            {
                'control_id': 'P11-ES-003',
                'description': 'E-signature must include meaning (review, approval, etc.)',
                'category': 'electronic_signature',
                'keywords_to_detect': ['meaning', 'purpose', 'reviewed', 'approved', 'verified'],
                'recommendation': 'Add requirement to capture signature meaning/purpose'
            },
            {
                'control_id': 'P11-ES-004',
                'description': 'E-signature must be linked to signed record',
                'category': 'electronic_signature',
                'keywords_to_detect': ['linked', 'bound', 'associated', 'cannot separate'],
                'recommendation': 'Add requirement that signature is permanently linked to record'
            },
            {
                'control_id': 'P11-ES-005',
                'description': 'Signature must require authentication',
                'category': 'electronic_signature',
                'keywords_to_detect': ['authenticate', 'verify identity', 'password', 'credential'],
                'recommendation': 'Add requirement for identity verification before signing'
            },

            # Access Control (§ 11.10(d), § 11.10(g))
            {
                'control_id': 'P11-AC-001',
                'description': 'System must limit access to authorized individuals',
                'category': 'access_control',
                'keywords_to_detect': ['authorized', 'permission', 'role-based', 'access control'],
                'recommendation': 'Add requirement for role-based access control'
            },
            {
                'control_id': 'P11-AC-002',
                'description': 'System must use unique user IDs',
                'category': 'access_control',
                'keywords_to_detect': ['unique', 'user id', 'username', 'individual'],
                'recommendation': 'Add requirement for unique user identification'
            },
            {
                'control_id': 'P11-AC-003',
                'description': 'System must enforce password policies',
                'category': 'access_control',
                'keywords_to_detect': ['password', 'complexity', 'expiration', 'history'],
                'recommendation': 'Add requirement for password complexity and expiration'
            },
            {
                'control_id': 'P11-AC-004',
                'description': 'System must lock accounts after failed attempts',
                'category': 'access_control',
                'keywords_to_detect': ['lockout', 'failed attempt', 'lock', 'disable'],
                'recommendation': 'Add requirement for account lockout after failed logins'
            },
            {
                'control_id': 'P11-AC-005',
                'description': 'System must implement session timeout',
                'category': 'access_control',
                'keywords_to_detect': ['timeout', 'session', 'inactivity', 'auto-logout'],
                'recommendation': 'Add requirement for automatic session timeout'
            },

            # Data Integrity (§ 11.10(a), § 11.10(c))
            {
                'control_id': 'P11-DI-001',
                'description': 'System must prevent unauthorized record changes',
                'category': 'data_integrity',
                'keywords_to_detect': ['prevent', 'unauthorized', 'protect', 'restrict'],
                'recommendation': 'Add requirement to prevent unauthorized modifications'
            },
            {
                'control_id': 'P11-DI-002',
                'description': 'System must validate data input',
                'category': 'data_integrity',
                'keywords_to_detect': ['validate', 'validation', 'verify', 'check'],
                'recommendation': 'Add requirement for data input validation'
            },
            {
                'control_id': 'P11-DI-003',
                'description': 'System must detect record alterations',
                'category': 'data_integrity',
                'keywords_to_detect': ['detect', 'tamper', 'alteration', 'checksum', 'hash'],
                'recommendation': 'Add requirement for detecting unauthorized alterations'
            },

            # Record Retention (§ 11.10(c))
            {
                'control_id': 'P11-RR-001',
                'description': 'Records must be retained for required period',
                'category': 'record_retention',
                'keywords_to_detect': ['retain', 'retention', 'years', 'period', 'archive'],
                'recommendation': 'Add requirement specifying retention period'
            },
            {
                'control_id': 'P11-RR-002',
                'description': 'Records must be retrievable throughout retention',
                'category': 'record_retention',
                'keywords_to_detect': ['retrieve', 'access', 'readable', 'available'],
                'recommendation': 'Add requirement for record retrieval capability'
            },
            {
                'control_id': 'P11-RR-003',
                'description': 'Backup and recovery procedures required',
                'category': 'record_retention',
                'keywords_to_detect': ['backup', 'recovery', 'restore', 'disaster'],
                'recommendation': 'Add requirement for backup and recovery procedures'
            }
        ]

    def _categorize_requirement(self, requirement: dict) -> list[str]:
        """
        PURPOSE:
            Determine which Part 11 categories apply to a requirement.

        PARAMETERS:
            requirement (dict): Requirement dictionary

        RETURNS:
            list[str]: Applicable categories

        WHY THIS APPROACH:
            We first check if the requirement involves electronic records,
            then determine which specific control categories apply.
        """
        text = self._get_requirement_text(requirement)

        # First, check if this involves electronic records at all
        if not self._involves_electronic_records(text):
            return []

        # Determine applicable categories
        categories = []
        for category, keywords in self.CATEGORY_KEYWORDS.items():
            if self._text_contains_keywords(text, keywords):
                categories.append(category)

        # If no specific category but involves records, default to audit_trail
        if not categories and self._involves_electronic_records(text):
            categories = ['audit_trail']

        return categories

    def _involves_electronic_records(self, text: str) -> bool:
        """
        PURPOSE:
            Check if text indicates electronic records involvement.

        PARAMETERS:
            text (str): Requirement text

        RETURNS:
            bool: True if involves electronic records

        WHY THIS APPROACH:
            Part 11 only applies to electronic records. We don't want
            to flag purely physical/paper processes.
        """
        return self._text_contains_keywords(text, self.ELECTRONIC_RECORD_KEYWORDS)

    def _check_controls(
        self,
        requirement: dict,
        categories: list[str]
    ) -> list[dict]:
        """
        PURPOSE:
            Check which Part 11 controls are missing for a requirement.

        PARAMETERS:
            requirement (dict): Requirement dictionary
            categories (list[str]): Applicable categories

        RETURNS:
            list[dict]: Missing controls

        WHY THIS APPROACH:
            For each applicable category, we check all related controls.
            If a control's keywords aren't found, it's flagged as missing.
        """
        text = self._get_requirement_text(requirement).lower()
        missing = []

        for control in self.controls:
            # Skip controls not in applicable categories
            if control.get('category') not in categories:
                continue

            # Check if control keywords are present
            keywords = control.get('keywords_to_detect', [])
            if not any(kw.lower() in text for kw in keywords):
                missing.append({
                    'control_id': control.get('control_id', ''),
                    'description': control.get('description', ''),
                    'category': control.get('category', ''),
                    'recommendation': control.get('recommendation', '')
                })

        return missing


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def validate_part11(
    requirements: list[dict],
    prefix: str = "P11"
) -> dict:
    """
    PURPOSE:
        Convenience function to validate requirements against Part 11.

    PARAMETERS:
        requirements (list[dict]): Requirements to validate
        prefix (str): Prefix for IDs

    RETURNS:
        dict: Compliance report

    USAGE:
        report = validate_part11(requirements)
        print(f"Compliance score: {report['summary']['compliance_score']}%")
    """
    validator = Part11Validator(prefix=prefix)
    return validator.generate_report(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("PART 11 VALIDATOR TEST")
    print("=" * 70)

    # Sample requirements to test
    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall allow users to enter patient data into forms',
            'raw_text': 'Data entry for patient records',
            'source_cell': 'A1'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'System shall log all changes to records with timestamp and user ID',
            'raw_text': 'Audit logging requirement',
            'source_cell': 'A2'
        },
        {
            'requirement_id': 'REQ-003',
            'description': 'Supervisor must approve batch release with electronic signature',
            'raw_text': 'E-signature for approval',
            'source_cell': 'A3'
        },
        {
            'requirement_id': 'REQ-004',
            'description': 'Users shall login with username and password',
            'raw_text': 'Authentication requirement',
            'source_cell': 'A4'
        }
    ]

    print(f"\nScanning {len(sample_requirements)} requirements...")

    validator = Part11Validator(prefix="TEST")
    report = validator.generate_report(sample_requirements)

    print(f"\n--- Summary ---")
    print(f"Requirements scanned: {report['summary']['total_requirements_scanned']}")
    print(f"With Part 11 relevance: {report['summary']['requirements_with_compliance_relevance']}")
    print(f"Requirements with gaps: {report['summary']['requirements_with_gaps']}")
    print(f"Compliance score: {report['summary']['compliance_score']}%")

    print(f"\n--- Gaps by Category ---")
    for cat, count in report['gaps_by_category'].items():
        print(f"  {cat}: {count}")

    print(f"\n--- Detailed Findings ---")
    for finding in report['detailed_findings'][:3]:
        print(f"\n  {finding['requirement_id']}:")
        print(f"    Text: {finding['requirement_text'][:60]}...")
        print(f"    Categories: {finding['categories']}")
        print(f"    Missing controls: {len(finding['missing_controls'])}")
        for ctrl in finding['missing_controls'][:2]:
            print(f"      - {ctrl['control_id']}: {ctrl['description']}")
