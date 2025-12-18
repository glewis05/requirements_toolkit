# compliance/part11_test_generator.py
# ============================================================================
# PURPOSE: Generate Part 11-specific UAT test cases
#
# Creates test cases that verify FDA 21 CFR Part 11 compliance:
# - Audit trail tests (logging, timestamps, before/after values)
# - E-signature tests (authentication, manifestation, linking)
# - Access control tests (authorization, lockout, timeout)
# - Data integrity tests (validation, tamper detection)
#
# AVIATION ANALOGY:
#     Like creating specific test procedures for airworthiness certification.
#     You don't just test that the plane flies - you test specific regulatory
#     requirements: stall warning works, emergency exits open, fire suppression
#     activates. Part 11 tests verify specific regulatory requirements are met.
#
# R EQUIVALENT:
#     Like using purrr::map to generate test cases:
#     requirements %>%
#       filter(needs_part11) %>%
#       map(~ generate_part11_tests(.x))
#
# ============================================================================

from typing import Optional
from datetime import datetime

from .part11_validator import Part11Validator


class Part11TestGenerator:
    """
    PURPOSE:
        Generate Part 11-specific UAT test cases for requirements.
        Works alongside the standard UAT generator to add compliance tests.

    R EQUIVALENT:
        Like an R6 class that takes requirements and produces test cases.

    USAGE:
        generator = Part11TestGenerator(prefix="GRX")
        tests = generator.generate(requirements)
        # tests is a list of test case dicts matching UATGenerator format

    OUTPUT FORMAT:
        Test cases match the same structure as generators/uat_generator.py
        so they can be combined with standard tests and formatted together.
    """

    # Test templates for each Part 11 control category
    TEST_TEMPLATES = {
        'audit_trail': [
            {
                'title_template': 'Verify audit log captures user identity for {action}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Test user account exists',
                    'User is logged in with known identity',
                    'Audit logging is enabled'
                ],
                'steps_template': [
                    '1. Log in as test user ({username})',
                    '2. Perform {action} on a record',
                    '3. Navigate to audit log / history',
                    '4. Locate the audit entry for the action'
                ],
                'expected_template': [
                    '• Audit entry exists for the action',
                    '• User identity (username/ID) is recorded',
                    '• User identity matches logged-in user'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify audit log captures timestamp for {action}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'System clock is synchronized',
                    'User is logged in'
                ],
                'steps_template': [
                    '1. Note the current date/time',
                    '2. Perform {action} on a record',
                    '3. View audit log entry for the action',
                    '4. Compare timestamp to noted time'
                ],
                'expected_template': [
                    '• Timestamp is recorded in audit entry',
                    '• Timestamp is within acceptable tolerance of action time',
                    '• Timestamp includes date, time, and timezone'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify audit log captures before/after values for {action}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Record exists with known field values',
                    'User has permission to modify record'
                ],
                'steps_template': [
                    '1. Note current value of field to be changed',
                    '2. Modify the field value',
                    '3. View audit log entry',
                    '4. Verify before and after values are recorded'
                ],
                'expected_template': [
                    '• Previous (before) value is recorded',
                    '• New (after) value is recorded',
                    '• Both values are accurate'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify audit records cannot be modified or deleted',
                'test_type': 'negative',
                'prerequisites': [
                    'Audit records exist in system',
                    'User with highest privileges is logged in'
                ],
                'steps_template': [
                    '1. Log in as administrator/highest privilege user',
                    '2. Navigate to audit log',
                    '3. Attempt to edit an audit record',
                    '4. Attempt to delete an audit record'
                ],
                'expected_template': [
                    '• No option to edit audit records exists',
                    '• No option to delete audit records exists',
                    '• If attempted via other means, action is blocked'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'electronic_signature': [
            {
                'title_template': 'Verify e-signature displays signer name for {action}',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Document/record ready for signature',
                    'User authorized to sign'
                ],
                'steps_template': [
                    '1. Navigate to document requiring signature',
                    '2. Initiate signature process',
                    '3. Complete authentication',
                    '4. Apply signature',
                    '5. View signed document'
                ],
                'expected_template': [
                    '• Signer printed name is displayed',
                    '• Name matches authenticated user',
                    '• Name is human-readable (not just ID)'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify e-signature includes date and time',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Document ready for signature',
                    'System clock is accurate'
                ],
                'steps_template': [
                    '1. Note current date and time',
                    '2. Apply signature to document',
                    '3. View signature details',
                    '4. Compare signature timestamp to noted time'
                ],
                'expected_template': [
                    '• Date is displayed with signature',
                    '• Time is displayed with signature',
                    '• Timestamp is accurate to within acceptable tolerance'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify e-signature includes meaning/purpose',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Document requiring specific approval type exists'
                ],
                'steps_template': [
                    '1. Navigate to document for approval',
                    '2. Apply signature',
                    '3. View signature manifestation',
                    '4. Verify meaning is displayed'
                ],
                'expected_template': [
                    '• Signature meaning is displayed (e.g., "Approved", "Reviewed")',
                    '• Meaning accurately reflects signature purpose',
                    '• Meaning cannot be changed after signing'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify signature requires authentication',
                'test_type': 'happy_path',
                'prerequisites': [
                    'User is logged in',
                    'Document ready for signature'
                ],
                'steps_template': [
                    '1. Navigate to document requiring signature',
                    '2. Click sign/approve button',
                    '3. Observe authentication prompt',
                    '4. Enter credentials',
                    '5. Complete signature'
                ],
                'expected_template': [
                    '• System prompts for authentication before signing',
                    '• Password or other credential required',
                    '• Signature not applied without authentication'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify signature fails with incorrect credentials',
                'test_type': 'negative',
                'prerequisites': [
                    'User is logged in',
                    'Document ready for signature'
                ],
                'steps_template': [
                    '1. Navigate to document requiring signature',
                    '2. Initiate signature',
                    '3. Enter incorrect password',
                    '4. Attempt to complete signature'
                ],
                'expected_template': [
                    '• Signature is NOT applied',
                    '• Error message displayed',
                    '• User may retry with correct credentials'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'access_control': [
            {
                'title_template': 'Verify unauthorized user cannot access {feature}',
                'test_type': 'negative',
                'prerequisites': [
                    'User account without required role exists',
                    'Feature requires specific authorization'
                ],
                'steps_template': [
                    '1. Log in as user without {feature} access',
                    '2. Attempt to navigate to {feature}',
                    '3. Attempt to perform {feature} action'
                ],
                'expected_template': [
                    '• Access is denied',
                    '• Appropriate error message displayed',
                    '• No data is exposed'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify account lockout after failed login attempts',
                'test_type': 'negative',
                'prerequisites': [
                    'Valid user account exists',
                    'Lockout threshold is configured (e.g., 3 attempts)'
                ],
                'steps_template': [
                    '1. Navigate to login page',
                    '2. Enter valid username',
                    '3. Enter incorrect password',
                    '4. Repeat until lockout threshold reached',
                    '5. Attempt login with correct password'
                ],
                'expected_template': [
                    '• Account is locked after threshold attempts',
                    '• Login denied even with correct password',
                    '• Lockout message displayed',
                    '• Failed attempts are logged'
                ],
                'moscow': 'Must Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify session timeout after inactivity',
                'test_type': 'happy_path',
                'prerequisites': [
                    'User is logged in',
                    'Session timeout is configured'
                ],
                'steps_template': [
                    '1. Log in to system',
                    '2. Note login time',
                    '3. Leave session idle for timeout period',
                    '4. Attempt to perform action'
                ],
                'expected_template': [
                    '• Session is terminated after timeout period',
                    '• User is redirected to login',
                    '• Re-authentication required to continue'
                ],
                'moscow': 'Must Have',
                'est_time': '10 min'
            },
            {
                'title_template': 'Verify unique user identification',
                'test_type': 'negative',
                'prerequisites': [
                    'Existing user account',
                    'Ability to create new users'
                ],
                'steps_template': [
                    '1. Note existing username',
                    '2. Attempt to create new user with same username',
                    '3. Observe system response'
                ],
                'expected_template': [
                    '• System prevents duplicate usernames',
                    '• Error message indicates username taken',
                    '• Unique ID required for each user'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'data_integrity': [
            {
                'title_template': 'Verify data validation on input for {field}',
                'test_type': 'negative',
                'prerequisites': [
                    'Form with validated fields exists',
                    'Validation rules are known'
                ],
                'steps_template': [
                    '1. Navigate to data entry form',
                    '2. Enter invalid data in {field}',
                    '3. Attempt to save/submit',
                    '4. Observe validation response'
                ],
                'expected_template': [
                    '• Invalid data is rejected',
                    '• Clear error message displayed',
                    '• Form indicates which field failed validation',
                    '• Invalid data is not saved'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            },
            {
                'title_template': 'Verify required fields cannot be bypassed',
                'test_type': 'negative',
                'prerequisites': [
                    'Form with required fields exists'
                ],
                'steps_template': [
                    '1. Navigate to data entry form',
                    '2. Leave required field blank',
                    '3. Attempt to save/submit',
                    '4. Observe system response'
                ],
                'expected_template': [
                    '• Submission is prevented',
                    '• Required field is highlighted',
                    '• Clear message indicates required fields'
                ],
                'moscow': 'Must Have',
                'est_time': '5 min'
            }
        ],
        'record_retention': [
            {
                'title_template': 'Verify records can be retrieved after archival',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Archived records exist in system',
                    'User has permission to access archives'
                ],
                'steps_template': [
                    '1. Navigate to archive/historical records',
                    '2. Search for specific archived record',
                    '3. Open/view the record',
                    '4. Verify content is complete and readable'
                ],
                'expected_template': [
                    '• Archived record can be located',
                    '• Record opens successfully',
                    '• All content is intact and readable',
                    '• Associated metadata is preserved'
                ],
                'moscow': 'Should Have',
                'est_time': '7 min'
            },
            {
                'title_template': 'Verify backup restoration',
                'test_type': 'happy_path',
                'prerequisites': [
                    'Backup exists',
                    'Test/staging environment available'
                ],
                'steps_template': [
                    '1. Identify backup to restore',
                    '2. Initiate restoration to test environment',
                    '3. Verify restoration completes',
                    '4. Validate data integrity post-restoration'
                ],
                'expected_template': [
                    '• Backup restores successfully',
                    '• Data is complete and accurate',
                    '• Records are accessible',
                    '• Audit trails are preserved'
                ],
                'moscow': 'Should Have',
                'est_time': '30 min'
            }
        ]
    }

    def __init__(self, prefix: str = "P11") -> None:
        """
        PURPOSE:
            Initialize the Part 11 test generator.

        PARAMETERS:
            prefix (str): Prefix for test IDs (default: "P11")
        """
        self.prefix = prefix
        self.test_counter = {}  # Track test numbers by category

        # Statistics
        self.stats = {
            'requirements_processed': 0,
            'tests_generated': 0,
            'by_category': {}
        }

    def generate(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Generate Part 11 UAT test cases for requirements.

        PARAMETERS:
            requirements (list[dict]): Requirements from parser

        RETURNS:
            list[dict]: Test cases in standard UATGenerator format

        WHY THIS APPROACH:
            We first validate requirements to find applicable categories,
            then generate appropriate tests for each category.
        """
        # Use Part11Validator to categorize requirements
        validator = Part11Validator(prefix=self.prefix)
        gap_analysis = validator.scan_requirements(requirements)

        all_tests = []
        self.test_counter = {}

        for gap_entry in gap_analysis:
            req_id = gap_entry.get('requirement_id', 'UNKNOWN')
            categories = gap_entry.get('categories', [])
            req_text = gap_entry.get('requirement_text', '')

            # Generate tests for each applicable category
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
        """
        PURPOSE:
            Generate test cases for a specific Part 11 category.

        PARAMETERS:
            requirement_id (str): Source requirement ID
            requirement_text (str): Requirement description
            category (str): Part 11 category (audit_trail, electronic_signature, etc.)

        RETURNS:
            list[dict]: Test cases for this category
        """
        templates = self.TEST_TEMPLATES.get(category, [])
        tests = []

        # Determine action/feature from requirement text
        action = self._extract_action(requirement_text)
        feature = self._extract_feature(requirement_text)
        field = self._extract_field(requirement_text)

        for template in templates:
            test_id = self._generate_test_id(category)

            # Fill in template placeholders
            title = template['title_template'].format(
                action=action, feature=feature, field=field
            )

            steps = [
                step.format(
                    action=action, feature=feature, field=field,
                    username='test_user'
                )
                for step in template['steps_template']
            ]

            expected = [
                exp.format(action=action, feature=feature, field=field)
                for exp in template['expected_template']
            ]

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
                'notes': f'Part 11 compliance test for {category.replace("_", " ")}'
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
        return f"{self.prefix}-P11-{cat_code}-{self.test_counter[cat_code]:03d}"

    def _extract_action(self, text: str) -> str:
        """Extract primary action from requirement text."""
        # Common actions
        actions = [
            'create', 'update', 'delete', 'modify', 'edit', 'save',
            'submit', 'approve', 'review', 'sign', 'enter', 'record'
        ]
        text_lower = text.lower()
        for action in actions:
            if action in text_lower:
                return action
        return 'data modification'

    def _extract_feature(self, text: str) -> str:
        """Extract feature/function from requirement text."""
        # Try to find what system/feature is mentioned
        text_lower = text.lower()
        if 'patient' in text_lower:
            return 'patient records'
        if 'batch' in text_lower:
            return 'batch records'
        if 'form' in text_lower:
            return 'form data'
        if 'report' in text_lower:
            return 'reports'
        return 'records'

    def _extract_field(self, text: str) -> str:
        """Extract field/data element from requirement text."""
        # Default field name
        return 'data field'

    def _category_display_name(self, category: str) -> str:
        """Convert category code to display name."""
        names = {
            'audit_trail': 'Part 11 - Audit Trail',
            'electronic_signature': 'Part 11 - E-Signature',
            'access_control': 'Part 11 - Access Control',
            'data_integrity': 'Part 11 - Data Integrity',
            'record_retention': 'Part 11 - Record Retention'
        }
        return names.get(category, f'Part 11 - {category.replace("_", " ").title()}')

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_part11_tests(requirements: list[dict], prefix: str = "P11") -> list[dict]:
    """
    PURPOSE:
        Convenience function to generate Part 11 test cases.

    PARAMETERS:
        requirements (list[dict]): Requirements to process
        prefix (str): Test ID prefix

    RETURNS:
        list[dict]: Part 11 test cases
    """
    generator = Part11TestGenerator(prefix=prefix)
    return generator.generate(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("PART 11 TEST GENERATOR TEST")
    print("=" * 70)

    # Sample requirements
    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall allow users to enter patient data into forms',
            'raw_text': 'Data entry for patient records'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'Supervisor must approve batch release with signature',
            'raw_text': 'Batch approval requirement'
        }
    ]

    print(f"\nGenerating tests for {len(sample_requirements)} requirements...")

    generator = Part11TestGenerator(prefix="TEST")
    tests = generator.generate(sample_requirements)

    print(f"\nGenerated {len(tests)} test cases")
    print(f"\nStats: {generator.get_stats()}")

    print(f"\n--- Sample Tests ---")
    for test in tests[:5]:
        print(f"\n  {test['test_id']}: {test['title']}")
        print(f"    Category: {test['category']}")
        print(f"    Type: {test['test_type']}")
        print(f"    MoSCoW: {test['moscow']}")
