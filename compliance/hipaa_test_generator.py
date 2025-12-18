# compliance/hipaa_test_generator.py
# ============================================================================
# PURPOSE: Generate HIPAA-specific UAT test cases
#
# Creates test cases that verify HIPAA compliance:
# - PHI access controls (role-based, minimum necessary)
# - Encryption (in transit and at rest)
# - Audit logging (access tracking, log review)
# - Breach notification procedures
# - Business associate requirements
#
# AVIATION ANALOGY:
#     Like security testing at airports - verifying that only authorized
#     personnel can access restricted areas, that surveillance systems
#     record all activity, and that breach protocols are in place.
#     HIPAA testing ensures the same protections for patient data.
#
# ============================================================================

from typing import Optional

from .hipaa_validator import HIPAAValidator


class HIPAATestGenerator:
    """
    PURPOSE:
        Generate HIPAA-specific UAT test cases for requirements.

    USAGE:
        generator = HIPAATestGenerator(prefix="GRX")
        tests = generator.generate(requirements)

    OUTPUT FORMAT:
        Test cases match the same structure as generators/uat_generator.py
    """

    TEST_TEMPLATES = {
        'access_control': [
            {
                'title_template': 'Verify role-based access to {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Users with different roles exist',
                    'PHI access permissions are configured'
                ],
                'steps_template': [
                    '1. Log in as user with appropriate role',
                    '2. Navigate to {feature}',
                    '3. Attempt to access PHI',
                    '4. Verify access is granted appropriately'
                ],
                'expected_template': [
                    '• User can access PHI appropriate to their role',
                    '• Access limited to minimum necessary',
                    '• Access logged in audit trail'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify unauthorized user cannot access PHI in {feature}',
                'test_type': 'negative',
                'prerequisites': [
                    'User without PHI access role exists'
                ],
                'steps_template': [
                    '1. Log in as user WITHOUT PHI access',
                    '2. Attempt to navigate to {feature}',
                    '3. Attempt to view PHI'
                ],
                'expected_template': [
                    '• Access is denied',
                    '• Error message does not reveal PHI',
                    '• Unauthorized access attempt is logged'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify session timeout protects PHI',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Session timeout is configured',
                    'User is logged in viewing PHI'
                ],
                'steps_template': [
                    '1. Log in and access PHI',
                    '2. Leave session idle for timeout period',
                    '3. Attempt to perform action',
                    '4. Verify session terminated'
                ],
                'expected_template': [
                    '• Session terminates after timeout',
                    '• PHI is no longer visible',
                    '• Re-authentication required'
                ],
                'moscow': 'Must Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify access revocation is immediate',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Active user session exists',
                    'Admin can revoke access'
                ],
                'steps_template': [
                    '1. User A is logged in with PHI access',
                    '2. Admin revokes User A PHI access',
                    '3. User A attempts to access PHI',
                    '4. Verify access denied'
                ],
                'expected_template': [
                    '• Access revocation takes effect immediately',
                    '• User cannot access PHI after revocation',
                    '• Revocation is logged'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            }
        ],
        'encryption': [
            {
                'title_template': 'Verify PHI is encrypted in transit for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Network monitoring tool available',
                    'Test environment configured'
                ],
                'steps_template': [
                    '1. Configure network traffic capture',
                    '2. Access PHI through {feature}',
                    '3. Examine captured traffic',
                    '4. Verify encryption'
                ],
                'expected_template': [
                    '• All PHI traffic uses TLS/HTTPS',
                    '• PHI not visible in plain text',
                    '• Certificate is valid and trusted'
                ],
                'moscow': 'Must Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify PHI is encrypted at rest',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Database access available',
                    'Encryption configured'
                ],
                'steps_template': [
                    '1. Enter PHI through application',
                    '2. Access database directly',
                    '3. Examine stored PHI',
                    '4. Verify encryption'
                ],
                'expected_template': [
                    '• PHI is not readable in raw database',
                    '• Encryption keys properly managed',
                    '• Only application can decrypt'
                ],
                'moscow': 'Must Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify insecure connection rejected',
                'test_type': 'negative',
                'prerequisites': [
                    'Ability to attempt HTTP connection'
                ],
                'steps_template': [
                    '1. Attempt to access {feature} via HTTP (not HTTPS)',
                    '2. Observe system response'
                ],
                'expected_template': [
                    '• HTTP connection rejected or redirected to HTTPS',
                    '• PHI not accessible over unencrypted connection',
                    '• Security warning displayed if applicable'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'audit_logging': [
            {
                'title_template': 'Verify PHI access is logged for {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Audit logging enabled',
                    'User with PHI access'
                ],
                'steps_template': [
                    '1. Note current time',
                    '2. Access PHI in {feature}',
                    '3. View audit log',
                    '4. Locate access entry'
                ],
                'expected_template': [
                    '• Access is recorded in audit log',
                    '• Log includes: user, timestamp, action, PHI accessed',
                    '• Log entry cannot be modified'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify audit log includes required details',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Recent PHI access events exist'
                ],
                'steps_template': [
                    '1. Navigate to audit log',
                    '2. Select recent PHI access event',
                    '3. Review log entry details'
                ],
                'expected_template': [
                    '• User identity recorded',
                    '• Date and time recorded',
                    '• Type of action recorded (view/edit/delete)',
                    '• Record/patient identifier logged'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify failed PHI access attempts are logged',
                'test_type': 'negative',
                'prerequisites': [
                    'User without PHI access'
                ],
                'steps_template': [
                    '1. Attempt to access PHI without authorization',
                    '2. Access is denied (expected)',
                    '3. View audit log',
                    '4. Verify failed attempt logged'
                ],
                'expected_template': [
                    '• Failed access attempt is logged',
                    '• Log includes user and timestamp',
                    '• Alerts generated if configured'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify audit logs cannot be deleted',
                'test_type': 'negative',
                'prerequisites': [
                    'Admin access to system'
                ],
                'steps_template': [
                    '1. Log in as administrator',
                    '2. Navigate to audit logs',
                    '3. Attempt to delete or modify log entry'
                ],
                'expected_template': [
                    '• Delete/modify options not available',
                    '• If attempted, action is blocked',
                    '• Attempt to tamper is itself logged'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'breach_notification': [
            {
                'title_template': 'Verify breach detection triggers alerts',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Breach detection configured',
                    'Test scenario available'
                ],
                'steps_template': [
                    '1. Simulate breach scenario (e.g., bulk PHI export)',
                    '2. Monitor for alerts',
                    '3. Verify alert received'
                ],
                'expected_template': [
                    '• Alert triggered by suspicious activity',
                    '• Alert includes relevant details',
                    '• Appropriate personnel notified'
                ],
                'moscow': 'Should Have',
                'est_time': '15 min'
            },
            {
                'title_template': 'Verify breach can be documented',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Breach documentation system available'
                ],
                'steps_template': [
                    '1. Access breach documentation area',
                    '2. Create breach report',
                    '3. Enter required details',
                    '4. Save and verify'
                ],
                'expected_template': [
                    '• Breach report can be created',
                    '• Required fields enforced',
                    '• Report is saved and retrievable'
                ],
                'moscow': 'Should Have',
                'est_time': '10 min'
            }
        ],
        'minimum_necessary': [
            {
                'title_template': 'Verify minimum necessary PHI displayed in {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Role with limited PHI access exists'
                ],
                'steps_template': [
                    '1. Log in as user with limited role',
                    '2. Access {feature}',
                    '3. Review PHI displayed',
                    '4. Verify only necessary fields shown'
                ],
                'expected_template': [
                    '• Only PHI necessary for role is displayed',
                    '• Unnecessary PHI fields hidden or masked',
                    '• Role limitations enforced'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify PHI search returns minimum necessary results',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Search function with PHI results'
                ],
                'steps_template': [
                    '1. Perform search that returns PHI',
                    '2. Review search results',
                    '3. Verify displayed fields'
                ],
                'expected_template': [
                    '• Search results show minimum PHI',
                    '• Full PHI only visible after opening record',
                    '• Access to full record is logged'
                ],
                'moscow': 'Should Have',
                'est_time': '5 min'
            }
        ],
        'phi_handling': [
            {
                'title_template': 'Verify PHI can be securely updated in {feature}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'User with PHI edit permission',
                    'Existing PHI record'
                ],
                'steps_template': [
                    '1. Log in as authorized user',
                    '2. Navigate to PHI record',
                    '3. Update PHI field',
                    '4. Save changes'
                ],
                'expected_template': [
                    '• PHI update successful',
                    '• Previous value retained in history',
                    '• Update logged in audit trail',
                    '• Change transmitted securely'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify PHI export includes only authorized data',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Export function exists',
                    'User with export permission'
                ],
                'steps_template': [
                    '1. Select records for export',
                    '2. Initiate export',
                    '3. Review exported data'
                ],
                'expected_template': [
                    '• Export contains only authorized PHI',
                    '• Export is logged',
                    '• Export file is encrypted or password-protected'
                ],
                'moscow': 'Should Have',
                'est_time': '10 min'
            }
        ],
        'business_associate': [
            {
                'title_template': 'Verify third-party PHI access is controlled',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Third-party integration configured',
                    'BAA in place'
                ],
                'steps_template': [
                    '1. Initiate third-party data exchange',
                    '2. Monitor data transmission',
                    '3. Verify access controls'
                ],
                'expected_template': [
                    '• PHI transmitted securely',
                    '• Access limited to agreed scope',
                    '• Third-party access logged'
                ],
                'moscow': 'Should Have',
                'est_time': '15 min'
            }
        ],
        'training': [
            {
                'title_template': 'Verify HIPAA training acknowledgment is required',
                'test_type': 'happy_path',
                'prerequisites': [
                    'New user account',
                    'Training module configured'
                ],
                'steps_template': [
                    '1. Log in as new user',
                    '2. Attempt to access PHI',
                    '3. Verify training requirement enforced'
                ],
                'expected_template': [
                    '• PHI access blocked until training complete',
                    '• Training requirement clearly displayed',
                    '• Training completion date recorded'
                ],
                'moscow': 'Should Have',
                'est_time': '10 min'
            }
        ]
    }

    def __init__(self, prefix: str = "HIPAA") -> None:
        """Initialize HIPAA test generator."""
        self.prefix = prefix
        self.test_counter = {}
        self.stats = {
            'requirements_processed': 0,
            'tests_generated': 0,
            'by_category': {}
        }

    def generate(self, requirements: list[dict]) -> list[dict]:
        """Generate HIPAA UAT test cases for requirements."""
        validator = HIPAAValidator(prefix=self.prefix)
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
        """Generate tests for a specific HIPAA category."""
        templates = self.TEST_TEMPLATES.get(category, [])
        tests = []

        feature = self._extract_feature(requirement_text)

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
                'category_code': category.upper()[:4],
                'test_type': template['test_type'],
                'prerequisites': template['prerequisites'].copy(),
                'test_steps': steps,
                'expected_results': expected,
                'moscow': template['moscow'],
                'est_time': template['est_time'],
                'notes': f'HIPAA compliance test for {category.replace("_", " ")}'
            }

            tests.append(test)
            self.stats['by_category'][category] = self.stats['by_category'].get(category, 0) + 1

        return tests

    def _generate_test_id(self, category: str) -> str:
        """Generate unique test ID for category."""
        cat_code = category.upper()[:4]
        if cat_code not in self.test_counter:
            self.test_counter[cat_code] = 0
        self.test_counter[cat_code] += 1
        return f"{self.prefix}-HIPAA-{cat_code}-{self.test_counter[cat_code]:03d}"

    def _extract_feature(self, text: str) -> str:
        """Extract feature/function from requirement text."""
        text_lower = text.lower()
        if 'patient' in text_lower:
            return 'patient records'
        if 'medical' in text_lower:
            return 'medical records'
        if 'lab' in text_lower:
            return 'lab results'
        if 'prescription' in text_lower:
            return 'prescriptions'
        return 'health records'

    def _category_display_name(self, category: str) -> str:
        """Convert category code to display name."""
        names = {
            'access_control': 'HIPAA - Access Control',
            'encryption': 'HIPAA - Encryption',
            'audit_logging': 'HIPAA - Audit Controls',
            'breach_notification': 'HIPAA - Breach Notification',
            'minimum_necessary': 'HIPAA - Minimum Necessary',
            'phi_handling': 'HIPAA - PHI Handling',
            'business_associate': 'HIPAA - Business Associate',
            'training': 'HIPAA - Training'
        }
        return names.get(category, f'HIPAA - {category.replace("_", " ").title()}')

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_hipaa_tests(requirements: list[dict], prefix: str = "HIPAA") -> list[dict]:
    """Convenience function to generate HIPAA test cases."""
    generator = HIPAATestGenerator(prefix=prefix)
    return generator.generate(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("HIPAA TEST GENERATOR TEST")
    print("=" * 70)

    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall store patient health records securely'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'Users can view patient medical history'
        }
    ]

    generator = HIPAATestGenerator(prefix="TEST")
    tests = generator.generate(sample_requirements)

    print(f"\nGenerated {len(tests)} test cases")
    print(f"\nStats: {generator.get_stats()}")

    print(f"\n--- Sample Tests ---")
    for test in tests[:5]:
        print(f"\n  {test['test_id']}: {test['title']}")
        print(f"    Category: {test['category']}")
        print(f"    Type: {test['test_type']}")
