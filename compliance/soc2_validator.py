# compliance/soc2_validator.py
# ============================================================================
# PURPOSE: Validate requirements against SOC 2 Trust Services Criteria
#
# SOC 2 (Service Organization Control 2) establishes requirements for
# service organizations based on five Trust Services Criteria (TSC):
# - Security: Protection against unauthorized access
# - Availability: System is operational and usable as committed
# - Confidentiality: Confidential information is protected
# - Processing Integrity: System processing is complete and accurate
# - Privacy: Personal information is collected and used appropriately
#
# AVIATION ANALOGY:
#     Like the FAA's oversight of airlines. Security is airport screening,
#     Availability is flight schedule reliability, Confidentiality is
#     passenger data protection, Processing Integrity is accurate booking
#     and baggage handling, and Privacy is how passenger info is used.
#
# R EQUIVALENT:
#     requirements %>%
#       mutate(tsc_categories = identify_tsc(.)) %>%
#       mutate(missing_controls = check_soc2(.))
#
# ============================================================================

from pathlib import Path
from typing import Optional

from .base_validator import BaseValidator


class SOC2Validator(BaseValidator):
    """
    PURPOSE:
        Validate requirements for SOC 2 compliance.
        Identifies gaps across the five Trust Services Criteria.

    R EQUIVALENT:
        Like an R6 class implementing SOC 2-specific checking.

    USAGE:
        validator = SOC2Validator(prefix="GRX")
        gaps = validator.scan_requirements(requirements)
        report = validator.generate_report(requirements)

    SOC 2 OVERVIEW:
        Trust Services Criteria (AICPA):
        - CC (Common Criteria) - Security foundation
        - A (Availability)
        - C (Confidentiality)
        - PI (Processing Integrity)
        - P (Privacy)

        Each TSC has specific criteria (e.g., CC1.1, CC1.2, A1.1, etc.)
    """

    # ========================================================================
    # CATEGORY KEYWORDS BY TSC
    # ========================================================================

    CATEGORY_KEYWORDS = {
        'security': [
            'access', 'authenticate', 'authorize', 'password', 'login',
            'encrypt', 'firewall', 'intrusion', 'vulnerability', 'patch',
            'security', 'secure', 'protect', 'threat', 'attack', 'malware',
            'antivirus', 'penetration', 'audit', 'monitor', 'alert'
        ],
        'availability': [
            'uptime', 'availability', 'downtime', 'sla', 'redundant',
            'failover', 'backup', 'recovery', 'disaster', 'restore',
            'load balance', 'capacity', 'performance', 'scale', 'resilient',
            'high availability', 'fault tolerant', 'business continuity'
        ],
        'confidentiality': [
            'confidential', 'sensitive', 'classify', 'classification',
            'encrypt', 'restricted', 'secret', 'proprietary', 'nda',
            'non-disclosure', 'need to know', 'access control', 'mask'
        ],
        'processing_integrity': [
            'validate', 'validation', 'accurate', 'complete', 'error',
            'exception', 'processing', 'calculation', 'reconcile',
            'verify', 'check', 'quality', 'integrity', 'consistent',
            'transaction', 'batch', 'audit trail', 'logging'
        ],
        'privacy': [
            'privacy', 'personal', 'pii', 'consent', 'opt-in', 'opt-out',
            'data subject', 'gdpr', 'ccpa', 'retention', 'deletion',
            'anonymize', 'pseudonymize', 'right to', 'notice', 'collection'
        ]
    }

    # General keywords that indicate SOC 2 relevance
    SOC2_RELEVANT_KEYWORDS = [
        'data', 'system', 'user', 'customer', 'service', 'process',
        'information', 'record', 'access', 'security', 'protect'
    ]

    def __init__(
        self,
        config_path: Optional[str] = None,
        prefix: str = "SOC2"
    ) -> None:
        """Initialize SOC 2 validator."""
        super().__init__(config_path=config_path, prefix=prefix)

    def _get_default_config_path(self) -> str:
        """Return path to default SOC 2 controls config."""
        return str(Path(__file__).parent / 'config' / 'soc2_controls.yaml')

    def _load_controls(self) -> None:
        """Load SOC 2 control definitions from config."""
        config_path = self.config_path or self._get_default_config_path()

        try:
            config = self._load_yaml_config(config_path)
            self.controls = config.get('controls', [])
        except Exception:
            self.controls = self._get_default_controls()

        if not self.controls:
            self.controls = self._get_default_controls()

    def _get_default_controls(self) -> list[dict]:
        """Return built-in SOC 2 controls if no config exists."""
        return [
            # ================================================================
            # SECURITY (Common Criteria)
            # ================================================================
            # CC6.1 - Logical and Physical Access Controls
            {
                'control_id': 'SOC2-SEC-001',
                'description': 'Logical access security software, infrastructure, and architectures',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.1',
                'keywords_to_detect': ['access control', 'authorization', 'permission', 'role'],
                'recommendation': 'Add requirement for logical access controls'
            },
            {
                'control_id': 'SOC2-SEC-002',
                'description': 'User authentication mechanisms',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.1',
                'keywords_to_detect': ['authenticate', 'password', 'credential', 'mfa', 'identity'],
                'recommendation': 'Add requirement for authentication mechanisms'
            },
            {
                'control_id': 'SOC2-SEC-003',
                'description': 'Encryption of data in transit and at rest',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.1',
                'keywords_to_detect': ['encrypt', 'tls', 'ssl', 'https', 'cipher'],
                'recommendation': 'Add requirement for data encryption'
            },
            # CC6.2 - Access Registration and Authorization
            {
                'control_id': 'SOC2-SEC-004',
                'description': 'Access provisioning and deprovisioning',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.2',
                'keywords_to_detect': ['provision', 'deprovision', 'onboard', 'offboard', 'terminate'],
                'recommendation': 'Add requirement for access provisioning procedures'
            },
            # CC6.3 - Access Removal
            {
                'control_id': 'SOC2-SEC-005',
                'description': 'Timely access removal upon termination',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.3',
                'keywords_to_detect': ['revoke', 'remove access', 'disable', 'termination'],
                'recommendation': 'Add requirement for timely access removal'
            },
            # CC6.6 - Security Events
            {
                'control_id': 'SOC2-SEC-006',
                'description': 'Security event logging and monitoring',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.6',
                'keywords_to_detect': ['log', 'monitor', 'alert', 'detect', 'siem'],
                'recommendation': 'Add requirement for security event logging'
            },
            # CC6.7 - Vulnerability Management
            {
                'control_id': 'SOC2-SEC-007',
                'description': 'Vulnerability scanning and patching',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC6.7',
                'keywords_to_detect': ['vulnerability', 'scan', 'patch', 'update', 'remediate'],
                'recommendation': 'Add requirement for vulnerability management'
            },
            # CC7.2 - System Monitoring
            {
                'control_id': 'SOC2-SEC-008',
                'description': 'Intrusion detection and prevention',
                'category': 'security',
                'tsc_category': 'Security',
                'tsc_reference': 'CC7.2',
                'keywords_to_detect': ['intrusion', 'ids', 'ips', 'detect', 'prevent', 'firewall'],
                'recommendation': 'Add requirement for intrusion detection'
            },

            # ================================================================
            # AVAILABILITY
            # ================================================================
            # A1.1 - System Availability
            {
                'control_id': 'SOC2-AVL-001',
                'description': 'System availability monitoring',
                'category': 'availability',
                'tsc_category': 'Availability',
                'tsc_reference': 'A1.1',
                'keywords_to_detect': ['uptime', 'availability', 'monitor', 'health check'],
                'recommendation': 'Add requirement for availability monitoring'
            },
            {
                'control_id': 'SOC2-AVL-002',
                'description': 'Redundancy and failover capabilities',
                'category': 'availability',
                'tsc_category': 'Availability',
                'tsc_reference': 'A1.1',
                'keywords_to_detect': ['redundant', 'failover', 'high availability', 'replica'],
                'recommendation': 'Add requirement for redundancy/failover'
            },
            # A1.2 - Recovery
            {
                'control_id': 'SOC2-AVL-003',
                'description': 'Backup and recovery procedures',
                'category': 'availability',
                'tsc_category': 'Availability',
                'tsc_reference': 'A1.2',
                'keywords_to_detect': ['backup', 'recovery', 'restore', 'rpo', 'rto'],
                'recommendation': 'Add requirement for backup and recovery'
            },
            {
                'control_id': 'SOC2-AVL-004',
                'description': 'Disaster recovery plan',
                'category': 'availability',
                'tsc_category': 'Availability',
                'tsc_reference': 'A1.2',
                'keywords_to_detect': ['disaster recovery', 'dr', 'business continuity', 'bcp'],
                'recommendation': 'Add requirement for disaster recovery planning'
            },

            # ================================================================
            # CONFIDENTIALITY
            # ================================================================
            # C1.1 - Confidential Information Identification
            {
                'control_id': 'SOC2-CON-001',
                'description': 'Data classification scheme',
                'category': 'confidentiality',
                'tsc_category': 'Confidentiality',
                'tsc_reference': 'C1.1',
                'keywords_to_detect': ['classify', 'classification', 'sensitive', 'confidential'],
                'recommendation': 'Add requirement for data classification'
            },
            # C1.2 - Confidentiality Protection
            {
                'control_id': 'SOC2-CON-002',
                'description': 'Access restrictions for confidential data',
                'category': 'confidentiality',
                'tsc_category': 'Confidentiality',
                'tsc_reference': 'C1.2',
                'keywords_to_detect': ['restrict', 'need to know', 'access control', 'permission'],
                'recommendation': 'Add requirement for confidential data access controls'
            },
            {
                'control_id': 'SOC2-CON-003',
                'description': 'Encryption of confidential data',
                'category': 'confidentiality',
                'tsc_category': 'Confidentiality',
                'tsc_reference': 'C1.2',
                'keywords_to_detect': ['encrypt', 'mask', 'obfuscate', 'protect'],
                'recommendation': 'Add requirement for confidential data encryption'
            },

            # ================================================================
            # PROCESSING INTEGRITY
            # ================================================================
            # PI1.1 - Processing Completeness
            {
                'control_id': 'SOC2-PI-001',
                'description': 'Input validation controls',
                'category': 'processing_integrity',
                'tsc_category': 'Processing Integrity',
                'tsc_reference': 'PI1.1',
                'keywords_to_detect': ['validate', 'validation', 'input check', 'format'],
                'recommendation': 'Add requirement for input validation'
            },
            {
                'control_id': 'SOC2-PI-002',
                'description': 'Processing error handling',
                'category': 'processing_integrity',
                'tsc_category': 'Processing Integrity',
                'tsc_reference': 'PI1.2',
                'keywords_to_detect': ['error handling', 'exception', 'error', 'fail'],
                'recommendation': 'Add requirement for error handling'
            },
            {
                'control_id': 'SOC2-PI-003',
                'description': 'Output reconciliation and verification',
                'category': 'processing_integrity',
                'tsc_category': 'Processing Integrity',
                'tsc_reference': 'PI1.3',
                'keywords_to_detect': ['reconcile', 'verify output', 'check', 'compare'],
                'recommendation': 'Add requirement for output verification'
            },
            # PI1.4 - Transaction Processing
            {
                'control_id': 'SOC2-PI-004',
                'description': 'Transaction audit trail',
                'category': 'processing_integrity',
                'tsc_category': 'Processing Integrity',
                'tsc_reference': 'PI1.4',
                'keywords_to_detect': ['audit trail', 'transaction log', 'track', 'history'],
                'recommendation': 'Add requirement for transaction audit trail'
            },

            # ================================================================
            # PRIVACY
            # ================================================================
            # P1 - Notice
            {
                'control_id': 'SOC2-PRI-001',
                'description': 'Privacy notice provided to data subjects',
                'category': 'privacy',
                'tsc_category': 'Privacy',
                'tsc_reference': 'P1.1',
                'keywords_to_detect': ['notice', 'policy', 'inform', 'disclose'],
                'recommendation': 'Add requirement for privacy notice'
            },
            # P2 - Choice and Consent
            {
                'control_id': 'SOC2-PRI-002',
                'description': 'Consent collection and management',
                'category': 'privacy',
                'tsc_category': 'Privacy',
                'tsc_reference': 'P2.1',
                'keywords_to_detect': ['consent', 'opt-in', 'opt-out', 'agree', 'permission'],
                'recommendation': 'Add requirement for consent management'
            },
            # P3 - Collection
            {
                'control_id': 'SOC2-PRI-003',
                'description': 'Data minimization in collection',
                'category': 'privacy',
                'tsc_category': 'Privacy',
                'tsc_reference': 'P3.1',
                'keywords_to_detect': ['minimal', 'necessary', 'limit', 'only collect'],
                'recommendation': 'Add requirement for data minimization'
            },
            # P4 - Use, Retention, and Disposal
            {
                'control_id': 'SOC2-PRI-004',
                'description': 'Data retention and deletion policies',
                'category': 'privacy',
                'tsc_category': 'Privacy',
                'tsc_reference': 'P4.1',
                'keywords_to_detect': ['retention', 'delete', 'dispose', 'purge', 'expiration'],
                'recommendation': 'Add requirement for data retention/deletion'
            },
            # P6 - Access
            {
                'control_id': 'SOC2-PRI-005',
                'description': 'Data subject access requests',
                'category': 'privacy',
                'tsc_category': 'Privacy',
                'tsc_reference': 'P6.1',
                'keywords_to_detect': ['access request', 'data subject', 'right to access', 'dsar'],
                'recommendation': 'Add requirement for data subject access'
            }
        ]

    def _categorize_requirement(self, requirement: dict) -> list[str]:
        """Determine which SOC 2 TSC categories apply to a requirement."""
        text = self._get_requirement_text(requirement)

        # Check if generally relevant to SOC 2
        if not self._is_soc2_relevant(text):
            return []

        # Determine applicable TSC categories
        categories = []
        for category, keywords in self.CATEGORY_KEYWORDS.items():
            if self._text_contains_keywords(text, keywords):
                categories.append(category)

        # Default to security if relevant but no specific category
        if not categories:
            categories = ['security']

        return categories

    def _is_soc2_relevant(self, text: str) -> bool:
        """Check if text is relevant to SOC 2."""
        return self._text_contains_keywords(text, self.SOC2_RELEVANT_KEYWORDS)

    def _check_controls(
        self,
        requirement: dict,
        categories: list[str]
    ) -> list[dict]:
        """Check which SOC 2 controls are missing."""
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
                    'tsc_category': control.get('tsc_category', ''),
                    'tsc_reference': control.get('tsc_reference', ''),
                    'recommendation': control.get('recommendation', '')
                })

        return missing

    def get_gaps_by_tsc(self) -> dict[str, list[dict]]:
        """
        PURPOSE:
            Organize gaps by Trust Services Criteria.

        RETURNS:
            dict: Gaps grouped by TSC (Security, Availability, etc.)
        """
        by_tsc = {}

        for entry in self.gap_analysis:
            for control in entry.get('missing_controls', []):
                tsc = control.get('tsc_category', 'Unknown')
                if tsc not in by_tsc:
                    by_tsc[tsc] = []
                by_tsc[tsc].append({
                    'requirement_id': entry.get('requirement_id'),
                    'control': control
                })

        return by_tsc


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def validate_soc2(requirements: list[dict], prefix: str = "SOC2") -> dict:
    """Convenience function to validate requirements against SOC 2."""
    validator = SOC2Validator(prefix=prefix)
    return validator.generate_report(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("SOC 2 VALIDATOR TEST")
    print("=" * 70)

    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall authenticate users with password and MFA',
            'source_cell': 'A1'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'System shall maintain 99.9% uptime with failover capability',
            'source_cell': 'A2'
        },
        {
            'requirement_id': 'REQ-003',
            'description': 'User data shall be encrypted and classified as confidential',
            'source_cell': 'A3'
        },
        {
            'requirement_id': 'REQ-004',
            'description': 'All transactions must be validated and logged',
            'source_cell': 'A4'
        },
        {
            'requirement_id': 'REQ-005',
            'description': 'User consent must be collected before data processing',
            'source_cell': 'A5'
        }
    ]

    validator = SOC2Validator(prefix="TEST")
    report = validator.generate_report(sample_requirements)

    print(f"\n--- Summary ---")
    print(f"Requirements scanned: {report['summary']['total_requirements_scanned']}")
    print(f"With SOC 2 relevance: {report['summary']['requirements_with_compliance_relevance']}")
    print(f"Compliance score: {report['summary']['compliance_score']}%")

    print(f"\n--- Gaps by Category ---")
    for cat, count in report['gaps_by_category'].items():
        print(f"  {cat}: {count}")

    print(f"\n--- Gaps by TSC ---")
    gaps_by_tsc = validator.get_gaps_by_tsc()
    for tsc, gaps in gaps_by_tsc.items():
        print(f"  {tsc}: {len(gaps)} gaps")
