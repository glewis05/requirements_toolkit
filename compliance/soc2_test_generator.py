# compliance/soc2_test_generator.py
# ============================================================================
# PURPOSE: Generate SOC 2-specific UAT test cases
#
# Creates test cases that verify SOC 2 Trust Services Criteria compliance:
# - Security: Access controls, encryption, vulnerability management
# - Availability: Uptime, failover, backup/recovery
# - Confidentiality: Data classification, access restrictions
# - Processing Integrity: Validation, error handling, reconciliation
# - Privacy: Consent, retention, data subject rights
#
# AVIATION ANALOGY:
#     Like FAA certification testing - each test proves compliance with
#     specific regulations. Security tests are like checking locks and
#     access controls, Availability tests verify the plane can fly reliably,
#     Processing Integrity tests verify navigation systems are accurate.
#
# ============================================================================

from typing import Optional

from .soc2_validator import SOC2Validator


class SOC2TestGenerator:
    """
    PURPOSE:
        Generate SOC 2-specific UAT test cases for requirements.
        Organizes tests by Trust Services Criteria (TSC).

    USAGE:
        generator = SOC2TestGenerator(prefix="GRX")
        tests = generator.generate(requirements)

    OUTPUT FORMAT:
        Test IDs use format: [PREFIX]-SOC2-[TSC]-[NUMBER]
        Example: GRX-SOC2-SEC-001, GRX-SOC2-AVL-001
    """

    # TSC abbreviations for test IDs
    TSC_CODES = {
        'security': 'SEC',
        'availability': 'AVL',
        'confidentiality': 'CON',
        'processing_integrity': 'PI',
        'privacy': 'PRI'
    }

    TEST_TEMPLATES = {
        'security': [
            {
                'title_template': 'Verify role-based access control for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Users with different roles exist',
                    'Access permissions configured'
                ],
                'steps_template': [
                    '1. Log in as user with specific role',
                    '2. Navigate to {feature}',
                    '3. Attempt to perform role-appropriate action',
                    '4. Verify action succeeds'
                ],
                'expected_template': [
                    '• Access granted for authorized actions',
                    '• Unauthorized actions are blocked',
                    '• Access logged in audit trail'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify unauthorized access is denied for {feature}',
                'test_type': 'negative',
                'prerequisites': [
                    'User without required permissions exists'
                ],
                'steps_template': [
                    '1. Log in as user WITHOUT access to {feature}',
                    '2. Attempt to access {feature}',
                    '3. Observe system response'
                ],
                'expected_template': [
                    '• Access is denied',
                    '• Appropriate error message shown',
                    '• Unauthorized attempt is logged'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify MFA is enforced for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'MFA is configured',
                    'User has MFA enabled'
                ],
                'steps_template': [
                    '1. Navigate to login',
                    '2. Enter username and password',
                    '3. Complete MFA challenge',
                    '4. Access {feature}'
                ],
                'expected_template': [
                    '• MFA prompt displayed after password',
                    '• Access granted only after MFA',
                    '• Failed MFA blocks access'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify data encryption in transit',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Network monitoring tool available',
                    'Test environment accessible'
                ],
                'steps_template': [
                    '1. Configure traffic capture',
                    '2. Perform data operation',
                    '3. Examine captured traffic',
                    '4. Verify TLS/encryption'
                ],
                'expected_template': [
                    '• All traffic uses HTTPS/TLS',
                    '• Data not visible in plain text',
                    '• Valid certificates in use'
                ],
                'moscow': 'Must Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify security event logging',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Audit logging enabled',
                    'Access to security logs'
                ],
                'steps_template': [
                    '1. Perform security-relevant action (login, access, etc.)',
                    '2. Navigate to security logs',
                    '3. Locate event entry',
                    '4. Verify log content'
                ],
                'expected_template': [
                    '• Event logged with timestamp',
                    '• User identity captured',
                    '• Action type recorded',
                    '• Source IP/location logged'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify account lockout after failed attempts',
                'test_type': 'negative',
                'prerequisites': [
                    'Account lockout configured',
                    'Valid user account'
                ],
                'steps_template': [
                    '1. Navigate to login',
                    '2. Enter valid username',
                    '3. Enter incorrect password (repeat until lockout)',
                    '4. Attempt login with correct password'
                ],
                'expected_template': [
                    '• Account locked after threshold',
                    '• Login denied even with correct password',
                    '• Lockout event logged',
                    '• User notified of lockout'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            }
        ],
        'availability': [
            {
                'title_template': 'Verify system uptime monitoring for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Monitoring tools configured',
                    'Health check endpoints available'
                ],
                'steps_template': [
                    '1. Access monitoring dashboard',
                    '2. Verify {feature} status',
                    '3. Check uptime metrics',
                    '4. Verify alerting configured'
                ],
                'expected_template': [
                    '• System status visible',
                    '• Uptime metrics tracked',
                    '• Alerts configured for downtime',
                    '• Historical data available'
                ],
                'moscow': 'Should Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify failover capability',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Failover configured',
                    'Test environment available',
                    'Approval for failover test'
                ],
                'steps_template': [
                    '1. Verify primary system operational',
                    '2. Simulate primary failure',
                    '3. Observe failover to secondary',
                    '4. Verify service continuity'
                ],
                'expected_template': [
                    '• Failover completes within RTO',
                    '• Service remains available',
                    '• Data integrity maintained',
                    '• Alerts generated'
                ],
                'moscow': 'Should Have',
                'est_time': '30 min'
            },
            {
                'title_template': 'Verify backup completion',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Backup system configured',
                    'Access to backup logs'
                ],
                'steps_template': [
                    '1. Review backup schedule',
                    '2. Check latest backup status',
                    '3. Verify backup completion',
                    '4. Check backup integrity'
                ],
                'expected_template': [
                    '• Backup completed successfully',
                    '• Backup size appropriate',
                    '• Backup stored securely',
                    '• Backup logs available'
                ],
                'moscow': 'Must Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify backup restoration',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Valid backup exists',
                    'Test/restore environment available'
                ],
                'steps_template': [
                    '1. Identify backup to restore',
                    '2. Initiate restoration',
                    '3. Monitor restoration progress',
                    '4. Verify data integrity'
                ],
                'expected_template': [
                    '• Restoration completes successfully',
                    '• Data is complete and accurate',
                    '• Application functions correctly',
                    '• Restoration time within RTO'
                ],
                'moscow': 'Must Have',
                'est_time': '45 min'
            }
        ],
        'confidentiality': [
            {
                'title_template': 'Verify data classification enforcement for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Data classification policy exists',
                    'Classified data in system'
                ],
                'steps_template': [
                    '1. Identify confidential data in {feature}',
                    '2. Verify classification label',
                    '3. Check access restrictions',
                    '4. Verify handling requirements'
                ],
                'expected_template': [
                    '• Data classification visible',
                    '• Access restricted appropriately',
                    '• Handling requirements enforced'
                ],
                'moscow': 'Should Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify confidential data encryption',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Confidential data exists',
                    'Database access available'
                ],
                'steps_template': [
                    '1. Enter confidential data via application',
                    '2. Access database directly',
                    '3. Examine stored data',
                    '4. Verify encryption'
                ],
                'expected_template': [
                    '• Data encrypted at rest',
                    '• Raw data not readable',
                    '• Encryption keys protected'
                ],
                'moscow': 'Must Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify need-to-know access restriction',
                'test_type': 'negative',
                'prerequisites': [
                    'User without need-to-know exists',
                    'Restricted data available'
                ],
                'steps_template': [
                    '1. Log in as user without access',
                    '2. Attempt to access restricted data',
                    '3. Observe system response'
                ],
                'expected_template': [
                    '• Access denied',
                    '• No data exposed',
                    '• Attempt logged'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'processing_integrity': [
            {
                'title_template': 'Verify input validation for {feature}',
                'test_type': 'negative',
                'prerequisites': [
                    'Data entry form available',
                    'Validation rules known'
                ],
                'steps_template': [
                    '1. Navigate to {feature} form',
                    '2. Enter invalid data',
                    '3. Attempt to submit',
                    '4. Observe validation response'
                ],
                'expected_template': [
                    '• Invalid data rejected',
                    '• Clear error message shown',
                    '• Invalid data not saved',
                    '• Form indicates error field'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify error handling in {feature}',
                'test_type': 'negative',
                'prerequisites': [
                    'Ability to trigger error condition'
                ],
                'steps_template': [
                    '1. Navigate to {feature}',
                    '2. Trigger error condition',
                    '3. Observe error handling',
                    '4. Verify graceful recovery'
                ],
                'expected_template': [
                    '• Error handled gracefully',
                    '• User-friendly message shown',
                    '• No data corruption',
                    '• Error logged for review'
                ],
                'moscow': 'Must Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify transaction audit trail',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Audit logging enabled'
                ],
                'steps_template': [
                    '1. Perform transaction in {feature}',
                    '2. Navigate to audit log',
                    '3. Locate transaction entry',
                    '4. Verify logged details'
                ],
                'expected_template': [
                    '• Transaction logged',
                    '• All relevant fields captured',
                    '• Timestamp accurate',
                    '• User identity recorded'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify calculation accuracy',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Known calculation scenario',
                    'Expected results calculated'
                ],
                'steps_template': [
                    '1. Enter known input values',
                    '2. Execute calculation',
                    '3. Compare result to expected',
                    '4. Verify accuracy'
                ],
                'expected_template': [
                    '• Result matches expected value',
                    '• Calculation documented',
                    '• Rounding handled correctly'
                ],
                'moscow': 'Must Have',
                'est_time': '10 min'
            }
        ],
        'privacy': [
            {
                'title_template': 'Verify privacy notice is displayed',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Privacy notice configured',
                    'New user scenario available'
                ],
                'steps_template': [
                    '1. Navigate to registration/signup',
                    '2. Locate privacy notice link',
                    '3. Review privacy notice content',
                    '4. Verify completeness'
                ],
                'expected_template': [
                    '• Privacy notice accessible',
                    '• Notice is current and complete',
                    '• Easy to understand',
                    '• Contact information provided'
                ],
                'moscow': 'Should Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify consent collection',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Consent mechanism configured'
                ],
                'steps_template': [
                    '1. Navigate to data collection point',
                    '2. Verify consent request displayed',
                    '3. Provide consent',
                    '4. Verify consent recorded'
                ],
                'expected_template': [
                    '• Consent clearly requested',
                    '• Options clearly explained',
                    '• Consent recorded with timestamp',
                    '• User can review consent status'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify opt-out functionality',
                'test_type': 'happy_path',
                'prerequisites': [
                    'User with active consent',
                    'Opt-out mechanism available'
                ],
                'steps_template': [
                    '1. Log in as user with consent',
                    '2. Navigate to privacy settings',
                    '3. Exercise opt-out option',
                    '4. Verify opt-out processed'
                ],
                'expected_template': [
                    '• Opt-out option available',
                    '• Opt-out confirmation received',
                    '• Consent status updated',
                    '• Data processing stopped'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify data deletion request',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Data deletion mechanism available',
                    'User data exists'
                ],
                'steps_template': [
                    '1. Submit data deletion request',
                    '2. Verify request acknowledged',
                    '3. Check deletion status',
                    '4. Verify data removed'
                ],
                'expected_template': [
                    '• Request mechanism available',
                    '• Request acknowledged',
                    '• Deletion completed within policy timeframe',
                    '• Confirmation provided'
                ],
                'moscow': 'Should Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify data subject access request',
                'test_type': 'happy_path',
                'prerequisites': [
                    'DSAR mechanism available'
                ],
                'steps_template': [
                    '1. Submit data access request',
                    '2. Verify identity as required',
                    '3. Receive data export',
                    '4. Verify data completeness'
                ],
                'expected_template': [
                    '• Access request mechanism available',
                    '• Identity verification required',
                    '• Data provided in usable format',
                    '• All personal data included'
                ],
                'moscow': 'Should Have',
                'est_time': '15 min'
            }
        ]
    }

    def __init__(self, prefix: str = "SOC2") -> None:
        """Initialize SOC 2 test generator."""
        self.prefix = prefix
        self.test_counter = {}
        self.stats = {
            'requirements_processed': 0,
            'tests_generated': 0,
            'by_tsc': {}
        }

    def generate(self, requirements: list[dict]) -> list[dict]:
        """Generate SOC 2 UAT test cases for requirements."""
        validator = SOC2Validator(prefix=self.prefix)
        gap_analysis = validator.scan_requirements(requirements)

        all_tests = []
        self.test_counter = {}

        for gap_entry in gap_analysis:
            req_id = gap_entry.get('requirement_id', 'UNKNOWN')
            categories = gap_entry.get('categories', [])
            req_text = gap_entry.get('requirement_text', '')

            for category in categories:
                tests = self._generate_category_tests(
                    requirement_id=req_id,
                    requirement_text=req_text,
                    category=category
                )
                all_tests.extend(tests)

            self.stats['requirements_processed'] += 1

        self.stats['tests_generated'] = len(all_tests)
        return all_tests

    def _generate_category_tests(
        self,
        requirement_id: str,
        requirement_text: str,
        category: str
    ) -> list[dict]:
        """Generate tests for a specific SOC 2 TSC category."""
        templates = self.TEST_TEMPLATES.get(category, [])
        tests = []

        feature = self._extract_feature(requirement_text)
        tsc_code = self.TSC_CODES.get(category, 'GEN')

        for template in templates:
            test_id = self._generate_test_id(category)

            title = template['title_template'].format(feature=feature)
            steps = [step.format(feature=feature) for step in template['steps_template']]
            expected = [exp.format(feature=feature) for exp in template['expected_template']]

            test = {
                'test_id': test_id,
                'source_story_id': requirement_id,
                'title': title,
                'category': self._category_display_name(category),
                'category_code': tsc_code,
                'test_type': template['test_type'],
                'prerequisites': template['prerequisites'].copy(),
                'test_steps': steps,
                'expected_results': expected,
                'moscow': template['moscow'],
                'est_time': template['est_time'],
                'notes': f'SOC 2 {category.replace("_", " ").title()} test'
            }

            tests.append(test)
            self.stats['by_tsc'][category] = self.stats['by_tsc'].get(category, 0) + 1

        return tests

    def _generate_test_id(self, category: str) -> str:
        """Generate unique test ID with TSC code."""
        tsc_code = self.TSC_CODES.get(category, 'GEN')
        if tsc_code not in self.test_counter:
            self.test_counter[tsc_code] = 0
        self.test_counter[tsc_code] += 1
        return f"{self.prefix}-SOC2-{tsc_code}-{self.test_counter[tsc_code]:03d}"

    def _extract_feature(self, text: str) -> str:
        """Extract feature/function from requirement text."""
        text_lower = text.lower()
        if 'user' in text_lower:
            return 'user management'
        if 'data' in text_lower:
            return 'data processing'
        if 'report' in text_lower:
            return 'reporting'
        if 'system' in text_lower:
            return 'system'
        return 'application'

    def _category_display_name(self, category: str) -> str:
        """Convert category code to display name."""
        names = {
            'security': 'SOC 2 - Security',
            'availability': 'SOC 2 - Availability',
            'confidentiality': 'SOC 2 - Confidentiality',
            'processing_integrity': 'SOC 2 - Processing Integrity',
            'privacy': 'SOC 2 - Privacy'
        }
        return names.get(category, f'SOC 2 - {category.replace("_", " ").title()}')

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_soc2_tests(requirements: list[dict], prefix: str = "SOC2") -> list[dict]:
    """Convenience function to generate SOC 2 test cases."""
    generator = SOC2TestGenerator(prefix=prefix)
    return generator.generate(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("SOC 2 TEST GENERATOR TEST")
    print("=" * 70)

    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall authenticate users with MFA'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'System shall maintain 99.9% availability'
        },
        {
            'requirement_id': 'REQ-003',
            'description': 'Confidential data shall be encrypted'
        },
        {
            'requirement_id': 'REQ-004',
            'description': 'All transactions shall be validated and logged'
        },
        {
            'requirement_id': 'REQ-005',
            'description': 'User consent shall be collected for data processing'
        }
    ]

    generator = SOC2TestGenerator(prefix="TEST")
    tests = generator.generate(sample_requirements)

    print(f"\nGenerated {len(tests)} test cases")
    print(f"\nStats: {generator.get_stats()}")

    print(f"\n--- Tests by TSC ---")
    for tsc, count in generator.stats['by_tsc'].items():
        print(f"  {tsc}: {count} tests")

    print(f"\n--- Sample Tests ---")
    for test in tests[:5]:
        print(f"\n  {test['test_id']}: {test['title']}")
        print(f"    Category: {test['category']}")
        print(f"    Type: {test['test_type']}")
