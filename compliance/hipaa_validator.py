# compliance/hipaa_validator.py
# ============================================================================
# PURPOSE: Validate requirements against HIPAA Privacy and Security Rules
#
# HIPAA (Health Insurance Portability and Accountability Act) establishes
# requirements for protecting patient health information (PHI):
# - Administrative Safeguards (policies, training, risk assessment)
# - Physical Safeguards (facility access, workstation security)
# - Technical Safeguards (access controls, encryption, audit logs)
# - Breach Notification (procedures for handling breaches)
#
# AVIATION ANALOGY:
#     Like TSA security requirements at airports. There are administrative
#     controls (training, procedures), physical controls (checkpoints, barriers),
#     and technical controls (scanners, databases). HIPAA does the same for
#     health data - protecting it at every level.
#
# R EQUIVALENT:
#     requirements %>%
#       filter(involves_phi) %>%
#       mutate(missing_safeguards = check_hipaa(.))
#
# ============================================================================

from pathlib import Path
from typing import Optional

from .base_validator import BaseValidator


class HIPAAValidator(BaseValidator):
    """
    PURPOSE:
        Validate requirements for HIPAA compliance.
        Identifies gaps in PHI protection, access controls, and safeguards.

    R EQUIVALENT:
        Like an R6 class that inherits from BaseValidator and implements
        HIPAA-specific checking logic.

    USAGE:
        validator = HIPAAValidator(prefix="GRX")
        gaps = validator.scan_requirements(requirements)
        report = validator.generate_report(requirements)

    HIPAA OVERVIEW:
        Security Rule (45 CFR Part 164):
            - § 164.308 Administrative safeguards
            - § 164.310 Physical safeguards
            - § 164.312 Technical safeguards
            - § 164.314 Organizational requirements
            - § 164.316 Policies and procedures

        Privacy Rule (45 CFR Parts 160, 164):
            - Minimum necessary standard
            - Patient rights (access, amendments, accounting)
            - Authorization requirements
    """

    # ========================================================================
    # CATEGORY KEYWORDS
    # ========================================================================
    # Keywords that indicate HIPAA relevance by category

    CATEGORY_KEYWORDS = {
        'phi_handling': [
            'patient', 'health', 'medical', 'clinical', 'diagnosis',
            'treatment', 'phi', 'pii', 'hipaa', 'healthcare', 'ehr',
            'emr', 'prescription', 'medication', 'lab', 'result',
            'insurance', 'claim', 'provider', 'ssn', 'social security',
            'date of birth', 'dob', 'mrn', 'medical record'
        ],
        'access_control': [
            'access', 'login', 'password', 'authentication', 'authorize',
            'permission', 'role', 'privilege', 'credential', 'identity',
            'user', 'account', 'mfa', 'multi-factor', 'two-factor'
        ],
        'encryption': [
            'encrypt', 'encryption', 'decrypt', 'secure', 'ssl', 'tls',
            'https', 'cipher', 'hash', 'aes', 'transmit', 'transfer',
            'send', 'receive', 'store', 'storage', 'rest', 'transit'
        ],
        'audit_logging': [
            'audit', 'log', 'track', 'monitor', 'record', 'history',
            'access log', 'activity', 'who', 'when', 'trail'
        ],
        'breach_notification': [
            'breach', 'incident', 'violation', 'unauthorized',
            'notify', 'notification', 'report', 'disclosure',
            'compromise', 'exposure', 'leak'
        ],
        'minimum_necessary': [
            'minimum necessary', 'need to know', 'role-based',
            'restrict', 'limit', 'appropriate', 'required access'
        ],
        'training': [
            'training', 'awareness', 'education', 'policy',
            'procedure', 'compliance', 'workforce'
        ],
        'business_associate': [
            'vendor', 'third party', 'contractor', 'partner',
            'business associate', 'baa', 'subcontractor', 'external'
        ]
    }

    # Keywords that indicate PHI/health data involvement
    PHI_KEYWORDS = [
        'patient', 'health', 'medical', 'clinical', 'phi', 'ephi',
        'healthcare', 'hipaa', 'ehr', 'emr', 'diagnosis', 'treatment',
        'prescription', 'medication', 'insurance', 'claim', 'provider',
        'ssn', 'social security', 'date of birth', 'dob', 'mrn',
        'lab result', 'test result', 'vital', 'allergy', 'condition'
    ]

    def __init__(
        self,
        config_path: Optional[str] = None,
        prefix: str = "HIPAA"
    ) -> None:
        """
        PURPOSE:
            Initialize HIPAA validator.

        PARAMETERS:
            config_path (str, optional): Path to custom controls YAML
            prefix (str): Prefix for generated IDs (default: "HIPAA")
        """
        super().__init__(config_path=config_path, prefix=prefix)

    def _get_default_config_path(self) -> str:
        """Return path to default HIPAA controls config."""
        return str(Path(__file__).parent / 'config' / 'hipaa_controls.yaml')

    def _load_controls(self) -> None:
        """Load HIPAA safeguard definitions from config."""
        config_path = self.config_path or self._get_default_config_path()

        try:
            config = self._load_yaml_config(config_path)
            self.controls = config.get('controls', [])
        except Exception:
            self.controls = self._get_default_controls()

        if not self.controls:
            self.controls = self._get_default_controls()

    def _get_default_controls(self) -> list[dict]:
        """Return built-in HIPAA controls if no config exists."""
        return [
            # Technical Safeguards - Access Control (§ 164.312(a))
            {
                'control_id': 'HIPAA-TS-AC-001',
                'description': 'Unique user identification required',
                'category': 'access_control',
                'keywords_to_detect': ['unique', 'user id', 'username', 'individual'],
                'recommendation': 'Add requirement for unique user identification'
            },
            {
                'control_id': 'HIPAA-TS-AC-002',
                'description': 'Emergency access procedure required',
                'category': 'access_control',
                'keywords_to_detect': ['emergency', 'break glass', 'emergency access'],
                'recommendation': 'Add requirement for emergency access procedures'
            },
            {
                'control_id': 'HIPAA-TS-AC-003',
                'description': 'Automatic logoff required',
                'category': 'access_control',
                'keywords_to_detect': ['timeout', 'logoff', 'auto-logout', 'inactivity'],
                'recommendation': 'Add requirement for automatic session termination'
            },
            {
                'control_id': 'HIPAA-TS-AC-004',
                'description': 'Encryption and decryption mechanisms',
                'category': 'access_control',
                'keywords_to_detect': ['encrypt', 'decrypt', 'cipher'],
                'recommendation': 'Add requirement for data encryption'
            },

            # Technical Safeguards - Audit Controls (§ 164.312(b))
            {
                'control_id': 'HIPAA-TS-AU-001',
                'description': 'Audit controls must record PHI access',
                'category': 'audit_logging',
                'keywords_to_detect': ['audit', 'log', 'access', 'record', 'track'],
                'recommendation': 'Add requirement to log all PHI access'
            },
            {
                'control_id': 'HIPAA-TS-AU-002',
                'description': 'Audit logs must be reviewed regularly',
                'category': 'audit_logging',
                'keywords_to_detect': ['review', 'monitor', 'examine', 'analyze'],
                'recommendation': 'Add requirement for regular audit log review'
            },

            # Technical Safeguards - Integrity (§ 164.312(c))
            {
                'control_id': 'HIPAA-TS-IN-001',
                'description': 'Mechanism to authenticate ePHI',
                'category': 'phi_handling',
                'keywords_to_detect': ['authenticate', 'verify', 'integrity', 'valid'],
                'recommendation': 'Add requirement for ePHI authentication mechanism'
            },

            # Technical Safeguards - Transmission Security (§ 164.312(e))
            {
                'control_id': 'HIPAA-TS-TR-001',
                'description': 'Encryption for PHI in transit',
                'category': 'encryption',
                'keywords_to_detect': ['encrypt', 'tls', 'ssl', 'https', 'secure transmission'],
                'recommendation': 'Add requirement for encryption of PHI in transit'
            },
            {
                'control_id': 'HIPAA-TS-TR-002',
                'description': 'Integrity controls for PHI transmission',
                'category': 'encryption',
                'keywords_to_detect': ['integrity', 'checksum', 'hash', 'verify'],
                'recommendation': 'Add requirement to verify transmission integrity'
            },

            # Technical Safeguards - Encryption at Rest
            {
                'control_id': 'HIPAA-TS-EN-001',
                'description': 'Encryption for PHI at rest',
                'category': 'encryption',
                'keywords_to_detect': ['encrypt', 'at rest', 'storage', 'stored', 'database'],
                'recommendation': 'Add requirement for encryption of stored PHI'
            },

            # Administrative Safeguards - Risk Assessment (§ 164.308(a)(1))
            {
                'control_id': 'HIPAA-AS-RA-001',
                'description': 'Risk analysis required',
                'category': 'training',
                'keywords_to_detect': ['risk', 'assessment', 'analysis', 'vulnerability'],
                'recommendation': 'Add requirement for risk analysis'
            },

            # Administrative Safeguards - Workforce Security (§ 164.308(a)(3))
            {
                'control_id': 'HIPAA-AS-WF-001',
                'description': 'Workforce authorization procedures',
                'category': 'access_control',
                'keywords_to_detect': ['authorize', 'clearance', 'background', 'verify'],
                'recommendation': 'Add requirement for workforce authorization'
            },
            {
                'control_id': 'HIPAA-AS-WF-002',
                'description': 'Workforce termination procedures',
                'category': 'access_control',
                'keywords_to_detect': ['termination', 'revoke', 'disable', 'remove access'],
                'recommendation': 'Add requirement for access termination procedures'
            },

            # Administrative Safeguards - Training (§ 164.308(a)(5))
            {
                'control_id': 'HIPAA-AS-TR-001',
                'description': 'Security awareness training required',
                'category': 'training',
                'keywords_to_detect': ['training', 'awareness', 'educate', 'train'],
                'recommendation': 'Add requirement for security awareness training'
            },

            # Minimum Necessary (§ 164.502(b))
            {
                'control_id': 'HIPAA-MN-001',
                'description': 'Minimum necessary access principle',
                'category': 'minimum_necessary',
                'keywords_to_detect': ['minimum necessary', 'need to know', 'role-based', 'limit'],
                'recommendation': 'Add requirement to limit PHI access to minimum necessary'
            },

            # Breach Notification (§ 164.400-414)
            {
                'control_id': 'HIPAA-BN-001',
                'description': 'Breach detection mechanism required',
                'category': 'breach_notification',
                'keywords_to_detect': ['detect', 'identify', 'discover', 'breach'],
                'recommendation': 'Add requirement for breach detection'
            },
            {
                'control_id': 'HIPAA-BN-002',
                'description': 'Breach notification procedures required',
                'category': 'breach_notification',
                'keywords_to_detect': ['notify', 'notification', 'report', 'inform'],
                'recommendation': 'Add requirement for breach notification procedures'
            },
            {
                'control_id': 'HIPAA-BN-003',
                'description': 'Breach documentation required',
                'category': 'breach_notification',
                'keywords_to_detect': ['document', 'record', 'log', 'maintain'],
                'recommendation': 'Add requirement for breach documentation'
            },

            # Business Associate (§ 164.308(b))
            {
                'control_id': 'HIPAA-BA-001',
                'description': 'Business associate agreement required',
                'category': 'business_associate',
                'keywords_to_detect': ['baa', 'agreement', 'contract', 'business associate'],
                'recommendation': 'Add requirement for BAA with third parties handling PHI'
            }
        ]

    def _categorize_requirement(self, requirement: dict) -> list[str]:
        """Determine which HIPAA categories apply to a requirement."""
        text = self._get_requirement_text(requirement)

        # First, check if this involves PHI at all
        if not self._involves_phi(text):
            return []

        # Determine applicable categories
        categories = []
        for category, keywords in self.CATEGORY_KEYWORDS.items():
            if self._text_contains_keywords(text, keywords):
                categories.append(category)

        # If involves PHI but no specific category, default to phi_handling
        if not categories:
            categories = ['phi_handling']

        return categories

    def _involves_phi(self, text: str) -> bool:
        """Check if text indicates PHI involvement."""
        return self._text_contains_keywords(text, self.PHI_KEYWORDS)

    def _check_controls(
        self,
        requirement: dict,
        categories: list[str]
    ) -> list[dict]:
        """Check which HIPAA safeguards are missing for a requirement."""
        text = self._get_requirement_text(requirement).lower()
        missing = []

        for control in self.controls:
            if control.get('category') not in categories:
                continue

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

def validate_hipaa(requirements: list[dict], prefix: str = "HIPAA") -> dict:
    """Convenience function to validate requirements against HIPAA."""
    validator = HIPAAValidator(prefix=prefix)
    return validator.generate_report(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("HIPAA VALIDATOR TEST")
    print("=" * 70)

    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall store patient health records securely',
            'source_cell': 'A1'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'Users can view patient medical history with encrypted connection',
            'source_cell': 'A2'
        },
        {
            'requirement_id': 'REQ-003',
            'description': 'Third-party lab integration sends test results',
            'source_cell': 'A3'
        }
    ]

    validator = HIPAAValidator(prefix="TEST")
    report = validator.generate_report(sample_requirements)

    print(f"\n--- Summary ---")
    print(f"Requirements scanned: {report['summary']['total_requirements_scanned']}")
    print(f"With HIPAA relevance: {report['summary']['requirements_with_compliance_relevance']}")
    print(f"Compliance score: {report['summary']['compliance_score']}%")

    print(f"\n--- Gaps by Category ---")
    for cat, count in report['gaps_by_category'].items():
        print(f"  {cat}: {count}")
