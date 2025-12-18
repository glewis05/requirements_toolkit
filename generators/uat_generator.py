# generators/uat_generator.py
# ============================================================================
# UAT (User Acceptance Testing) Test Case Generator
# ============================================================================
#
# PURPOSE:
#     Takes user stories from UserStoryGenerator and creates comprehensive
#     UAT test cases DERIVED FROM acceptance criteria.
#
# SEPARATION OF CONCERNS:
#     - Acceptance Criteria (user_story_generator.py): WHAT success looks like
#     - UAT Test Cases (this file): HOW to verify it works
#
# KEY CHANGES:
#     - Test cases are DERIVED from acceptance criteria, not duplicated
#     - Each testable statement becomes one or more test cases
#     - Gherkin scenarios in Expected Results (not acceptance criteria)
#     - Skips non-technical items (is_technical = False)
#     - Test IDs link back to Story ID they validate
#
# TEST ID FORMAT:
#     {PREFIX}-{CATEGORY}-{SEQ}
#     Example: PROP-RECRUIT-001
#
# AVIATION ANALOGY:
#     Like creating a test flight card. The acceptance criteria say "aircraft must
#     achieve V1 speed within X feet" - the test case says "HOW to verify this:
#     setup, steps, expected readings, pass/fail criteria."
#
# ============================================================================

import re
from typing import Optional
from datetime import datetime


class UATGenerator:
    """
    PURPOSE:
        Generate UAT test cases DERIVED FROM acceptance criteria.
        Creates structured test cases that can be executed by QA teams.

    KEY FEATURES:
        - Derives test cases from acceptance criteria (testable statements)
        - Generates Gherkin scenarios as expected results
        - Skips non-technical items
        - Links test cases back to source Story ID

    ATTRIBUTES:
        test_id_prefix (str): Prefix for test IDs (e.g., "PROP", "GRX")
        test_counter (dict): Tracks test numbers per category
        moscow_mapping (dict): Maps priority levels to MoSCoW values

    USAGE:
        generator = UATGenerator(test_id_prefix="PROP")
        test_cases = generator.generate(user_stories)
    """

    # ========================================================================
    # MoSCoW PRIORITY MAPPING
    # ========================================================================
    MOSCOW_MAPPING = {
        'Critical': 'Must Have',
        'High': 'Must Have',
        'Medium': 'Should Have',
        'Low': 'Could Have',
        'Nice to Have': 'Won\'t Have (this time)',
    }

    # ========================================================================
    # TEST TYPE DEFINITIONS
    # ========================================================================
    TEST_TYPES = {
        'happy_path': 'Happy Path',
        'negative': 'Negative',
        'edge_case': 'Edge Case',
        'boundary': 'Boundary',
        'validation': 'Validation',
        'verification': 'Verification',
    }

    def __init__(
        self,
        test_id_prefix: str = "UAT",
        category_abbreviations: Optional[dict[str, str]] = None
    ):
        """
        PURPOSE:
            Initialize the UAT generator with configuration.

        PARAMETERS:
            test_id_prefix (str): Prefix for test IDs (e.g., "PROP", "GRX")
            category_abbreviations (dict): Maps categories to short codes
        """
        self.test_id_prefix = test_id_prefix

        # Default category abbreviations
        self.category_abbreviations = category_abbreviations or {
            'RECRUIT': 'RECRUIT',
            'DASH': 'DASH',
            'MSG': 'MSG',
            'DATA': 'DATA',
            'INTEG': 'INTEG',
            'AUTH': 'AUTH',
            'CONSENT': 'CONSENT',
            'RPT': 'RPT',
            'SEARCH': 'SEARCH',
            'WF': 'WF',
            'ADMIN': 'ADMIN',
            'GEN': 'GEN',
        }

        # Track test numbers per category
        self.test_counter: dict[str, int] = {}

        # Statistics
        self.stats = {
            'total_stories_processed': 0,
            'technical_stories': 0,
            'non_technical_skipped': 0,
            'total_tests_generated': 0,
            'by_type': {
                'happy_path': 0,
                'negative': 0,
                'edge_case': 0,
                'validation': 0,
            }
        }

    # ========================================================================
    # MAIN GENERATION METHOD
    # ========================================================================

    def generate(self, user_stories: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Generate UAT test cases from user stories' acceptance criteria.

        PARAMETERS:
            user_stories (list[dict]): User stories from UserStoryGenerator
                Each should have:
                - generated_id: Story ID (e.g., "PROP-RECRUIT-001")
                - title: Feature title
                - category_abbrev: Category code (e.g., "RECRUIT")
                - is_technical: True if technical feature
                - acceptance_criteria: List of criteria from patterns
                - priority: Critical/High/Medium/Low

        RETURNS:
            list[dict]: List of test case dictionaries
        """
        all_tests = []
        self.stats['total_stories_processed'] = len(user_stories)

        for story in user_stories:
            # Skip non-technical items
            if not story.get('is_technical', True):
                self.stats['non_technical_skipped'] += 1
                continue

            self.stats['technical_stories'] += 1

            # Generate tests from this story's acceptance criteria
            tests = self._generate_tests_for_story(story)
            all_tests.extend(tests)

        self.stats['total_tests_generated'] = len(all_tests)
        return all_tests

    def _generate_tests_for_story(self, story: dict) -> list[dict]:
        """
        PURPOSE:
            Generate all test cases for a single story.

        APPROACH:
            1. Parse acceptance criteria to extract testable statements
            2. For each testable statement, generate appropriate test cases
            3. Add happy path, negative, and edge case tests
            4. Generate Gherkin scenarios for expected results
        """
        tests = []

        # Get story metadata
        story_id = story.get('generated_id', 'UNKNOWN')
        category = story.get('category_abbrev', 'GEN')
        priority = story.get('priority', 'Medium')
        title = story.get('title', '')
        capability = story.get('capability', '')
        acceptance_criteria = story.get('acceptance_criteria', [])

        # Parse acceptance criteria to extract testable statements
        testable_statements = self._extract_testable_statements(acceptance_criteria)
        success_metrics = self._extract_success_metrics(acceptance_criteria)

        # Generate happy path test (always one per story)
        happy_test = self._generate_happy_path_test(
            story_id, category, priority, title, capability, testable_statements
        )
        tests.append(happy_test)
        self.stats['by_type']['happy_path'] += 1

        # Generate validation tests from testable statements
        for i, statement in enumerate(testable_statements[:5]):  # Limit to 5
            validation_test = self._generate_validation_test(
                story_id, category, priority, title, statement, i
            )
            tests.append(validation_test)
            self.stats['by_type']['validation'] += 1

        # Generate negative tests
        negative_tests = self._generate_negative_tests(
            story_id, category, priority, title, capability
        )
        tests.extend(negative_tests)
        self.stats['by_type']['negative'] += len(negative_tests)

        # Generate edge case tests
        edge_tests = self._generate_edge_case_tests(
            story_id, category, priority, title, capability
        )
        tests.extend(edge_tests)
        self.stats['by_type']['edge_case'] += len(edge_tests)

        return tests

    # ========================================================================
    # ACCEPTANCE CRITERIA PARSING
    # ========================================================================

    def _extract_testable_statements(self, criteria: list[str]) -> list[str]:
        """
        PURPOSE:
            Extract testable statements from acceptance criteria.

        RETURNS:
            list[str]: Testable statements (without bullet points)
        """
        statements = []
        in_acceptance_section = False

        for line in criteria:
            line = line.strip()

            # Track section
            if 'ACCEPTANCE CRITERIA' in line:
                in_acceptance_section = True
                continue
            elif 'SUCCESS METRICS' in line:
                in_acceptance_section = False
                continue

            # Extract bullet points from acceptance section
            if in_acceptance_section and line.startswith('•'):
                # Remove bullet and clean up
                statement = line[1:].strip()
                if len(statement) > 10:
                    statements.append(statement)

        return statements

    def _extract_success_metrics(self, criteria: list[str]) -> list[str]:
        """
        PURPOSE:
            Extract success metrics from acceptance criteria.

        RETURNS:
            list[str]: Success metrics (without bullet points)
        """
        metrics = []
        in_metrics_section = False

        for line in criteria:
            line = line.strip()

            # Track section
            if 'SUCCESS METRICS' in line:
                in_metrics_section = True
                continue
            elif line.startswith('ACCEPTANCE') or line.startswith('PROCESS'):
                in_metrics_section = False
                continue

            # Extract bullet points from metrics section
            if in_metrics_section and line.startswith('•'):
                metric = line[1:].strip()
                if len(metric) > 10:
                    metrics.append(metric)

        return metrics

    # ========================================================================
    # TEST ID GENERATION
    # ========================================================================

    def _generate_test_id(self, category: str) -> str:
        """
        PURPOSE:
            Generate unique test ID in format: PREFIX-CATEGORY-SEQ

        EXAMPLES:
            PROP-RECRUIT-001, PROP-RECRUIT-002, PROP-DASH-001
        """
        if category not in self.test_counter:
            self.test_counter[category] = 0
        self.test_counter[category] += 1

        seq = self.test_counter[category]
        return f"{self.test_id_prefix}-{category}-{seq:03d}"

    # ========================================================================
    # HAPPY PATH TEST GENERATION
    # ========================================================================

    def _generate_happy_path_test(
        self,
        story_id: str,
        category: str,
        priority: str,
        title: str,
        capability: str,
        testable_statements: list[str]
    ) -> dict:
        """
        PURPOSE:
            Generate a happy path test case that validates the main flow.
        """
        test_id = self._generate_test_id(category)
        moscow = self.MOSCOW_MAPPING.get(priority, 'Should Have')

        # Build prerequisites from context
        prerequisites = self._build_prerequisites(category)

        # Build test steps from capability
        test_steps = self._build_happy_path_steps(capability, category)

        # Build expected results with Gherkin format
        expected_results = self._build_expected_results(testable_statements, capability)

        return {
            'test_id': test_id,
            'source_story_id': story_id,
            'category': category,
            'category_code': category,
            'title': f"Verify {title}",
            'test_type': 'happy_path',
            'prerequisites': prerequisites,
            'test_steps': test_steps,
            'expected_results': expected_results,
            'moscow': moscow,
            'est_time': '5-10 min',
            'notes': f"Validates acceptance criteria for {story_id}",
        }

    def _build_prerequisites(self, category: str) -> list[str]:
        """Build prerequisites based on category."""
        base_prereqs = [
            "User is logged in with appropriate permissions",
            "Test data is available in the system",
        ]

        category_prereqs = {
            'RECRUIT': ["Recruitment analytics module is enabled"],
            'MSG': ["Email/SMS service is configured"],
            'CONSENT': ["Consent forms are configured"],
            'DATA': ["Sample patient records exist"],
            'INTEG': ["External system integration is active"],
            'AUTH': ["User roles are configured"],
        }

        return base_prereqs + category_prereqs.get(category, [])

    def _build_happy_path_steps(self, capability: str, category: str) -> list[str]:
        """Build test steps for happy path."""
        base_steps = [
            "1. Navigate to the relevant module/page",
            "2. Verify the feature is accessible",
        ]

        # Add category-specific steps
        if category in ['RECRUIT', 'DASH']:
            base_steps.extend([
                "3. Observe the dashboard/display loads",
                "4. Verify data is displayed correctly",
                "5. Test any filters or date range selectors",
                "6. Verify data accuracy against source",
            ])
        elif category == 'MSG':
            base_steps.extend([
                "3. Trigger the notification action",
                "4. Verify notification is logged",
                "5. Check notification status updates",
            ])
        elif category == 'DATA':
            base_steps.extend([
                "3. Access the data/list view",
                "4. Apply filters/search as needed",
                "5. Verify data is accurate",
                "6. Test export functionality",
            ])
        elif category == 'CONSENT':
            base_steps.extend([
                "3. Navigate to consent flow",
                "4. Complete consent process",
                "5. Verify consent is recorded",
            ])
        else:
            base_steps.extend([
                f"3. Perform action: {capability[:50]}",
                "4. Verify action completes successfully",
                "5. Check for confirmation message",
            ])

        return base_steps

    def _build_expected_results(
        self,
        testable_statements: list[str],
        capability: str
    ) -> list[str]:
        """
        PURPOSE:
            Build expected results with Gherkin format.
        """
        results = []

        # Add Gherkin scenario
        results.append("**Expected Behavior (Gherkin):**")
        results.append(f"  Given the user has appropriate permissions")
        results.append(f"  When they access the {capability[:40]} feature")
        results.append(f"  Then the feature works as expected")
        results.append("")

        # Add specific expected outcomes from testable statements
        results.append("**Specific Outcomes:**")
        for stmt in testable_statements[:5]:
            results.append(f"  ✓ {stmt}")

        return results

    # ========================================================================
    # VALIDATION TEST GENERATION
    # ========================================================================

    def _generate_validation_test(
        self,
        story_id: str,
        category: str,
        priority: str,
        title: str,
        statement: str,
        index: int
    ) -> dict:
        """
        PURPOSE:
            Generate a validation test for a specific testable statement.
        """
        test_id = self._generate_test_id(category)
        moscow = self.MOSCOW_MAPPING.get(priority, 'Should Have')

        # Parse the statement to create focused test
        test_title = f"Validate: {statement[:60]}"
        if len(statement) > 60:
            test_title += "..."

        return {
            'test_id': test_id,
            'source_story_id': story_id,
            'category': category,
            'category_code': category,
            'title': test_title,
            'test_type': 'validation',
            'prerequisites': [
                "User is logged in",
                "Feature is accessible",
            ],
            'test_steps': [
                "1. Navigate to the relevant feature",
                f"2. Verify: {statement}",
                "3. Document actual behavior",
                "4. Compare to expected behavior",
            ],
            'expected_results': [
                f"**Given** the feature is accessible",
                f"**When** the validation is performed",
                f"**Then** {statement}",
            ],
            'moscow': moscow,
            'est_time': '3-5 min',
            'notes': f"Validates specific acceptance criterion from {story_id}",
        }

    # ========================================================================
    # NEGATIVE TEST GENERATION
    # ========================================================================

    def _generate_negative_tests(
        self,
        story_id: str,
        category: str,
        priority: str,
        title: str,
        capability: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate negative test cases that verify error handling.
        """
        tests = []

        # Generate 2-3 negative tests based on category
        negative_scenarios = self._get_negative_scenarios(category, capability)

        for scenario in negative_scenarios[:3]:
            test_id = self._generate_test_id(category)
            moscow = self.MOSCOW_MAPPING.get(priority, 'Should Have')

            tests.append({
                'test_id': test_id,
                'source_story_id': story_id,
                'category': category,
                'category_code': category,
                'title': scenario['title'],
                'test_type': 'negative',
                'prerequisites': scenario.get('prerequisites', ["User is logged in"]),
                'test_steps': scenario['steps'],
                'expected_results': scenario['expected'],
                'moscow': moscow,
                'est_time': '3-5 min',
                'notes': f"Negative test for {story_id}",
            })

        return tests

    def _get_negative_scenarios(self, category: str, capability: str) -> list[dict]:
        """Get negative test scenarios based on category."""
        scenarios = []

        # Universal negative tests
        scenarios.append({
            'title': f"Verify behavior with insufficient permissions",
            'steps': [
                "1. Log in as user without required permissions",
                "2. Attempt to access the feature",
                "3. Observe system response",
            ],
            'expected': [
                "**Given** a user without permissions",
                "**When** they attempt to access the feature",
                "**Then** access is denied with appropriate message",
            ],
        })

        # Category-specific negative tests
        if category in ['RECRUIT', 'DASH']:
            scenarios.append({
                'title': "Verify dashboard with no data",
                'steps': [
                    "1. Access dashboard with empty dataset",
                    "2. Observe display behavior",
                ],
                'expected': [
                    "**Then** empty state message is displayed",
                    "**And** no errors occur",
                ],
            })
        elif category == 'DATA':
            scenarios.append({
                'title': "Verify export with no data selected",
                'steps': [
                    "1. Navigate to export feature",
                    "2. Attempt export without selecting data",
                ],
                'expected': [
                    "**Then** user is prompted to select data",
                    "**And** export is prevented until selection is made",
                ],
            })
        elif category == 'MSG':
            scenarios.append({
                'title': "Verify notification with invalid recipient",
                'steps': [
                    "1. Attempt to send notification to invalid address",
                    "2. Observe system response",
                ],
                'expected': [
                    "**Then** error message indicates invalid recipient",
                    "**And** notification is not sent",
                ],
            })

        # Add invalid input test
        scenarios.append({
            'title': "Verify behavior with invalid/malformed input",
            'steps': [
                "1. Enter invalid data in required fields",
                "2. Attempt to submit/save",
                "3. Observe validation messages",
            ],
            'expected': [
                "**Given** invalid input is provided",
                "**When** the user submits",
                "**Then** clear validation errors are displayed",
                "**And** data is not saved",
            ],
        })

        return scenarios

    # ========================================================================
    # EDGE CASE TEST GENERATION
    # ========================================================================

    def _generate_edge_case_tests(
        self,
        story_id: str,
        category: str,
        priority: str,
        title: str,
        capability: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate edge case test cases.
        """
        tests = []

        # Generate 1-2 edge case tests
        edge_scenarios = self._get_edge_scenarios(category)

        for scenario in edge_scenarios[:2]:
            test_id = self._generate_test_id(category)
            moscow = 'Could Have'  # Edge cases are lower priority

            tests.append({
                'test_id': test_id,
                'source_story_id': story_id,
                'category': category,
                'category_code': category,
                'title': scenario['title'],
                'test_type': 'edge_case',
                'prerequisites': scenario.get('prerequisites', ["User is logged in"]),
                'test_steps': scenario['steps'],
                'expected_results': scenario['expected'],
                'moscow': moscow,
                'est_time': '5-10 min',
                'notes': f"Edge case test for {story_id}",
            })

        return tests

    def _get_edge_scenarios(self, category: str) -> list[dict]:
        """Get edge case scenarios based on category."""
        scenarios = []

        if category in ['RECRUIT', 'DASH']:
            scenarios.append({
                'title': "Verify with large dataset (10,000+ records)",
                'steps': [
                    "1. Load dashboard with 10,000+ records",
                    "2. Observe load time and performance",
                    "3. Test pagination/scrolling",
                ],
                'expected': [
                    "**Then** data loads within acceptable time (<10s)",
                    "**And** pagination works correctly",
                    "**And** no performance degradation",
                ],
            })
            scenarios.append({
                'title': "Verify with extreme date range",
                'steps': [
                    "1. Select date range spanning multiple years",
                    "2. Observe data aggregation",
                ],
                'expected': [
                    "**Then** data aggregates correctly",
                    "**And** display remains readable",
                ],
            })
        elif category == 'DATA':
            scenarios.append({
                'title': "Verify export with maximum records",
                'steps': [
                    "1. Select maximum allowable records for export",
                    "2. Initiate export",
                    "3. Observe completion",
                ],
                'expected': [
                    "**Then** export completes without timeout",
                    "**And** all records are included",
                ],
            })
        elif category == 'MSG':
            scenarios.append({
                'title': "Verify notification with special characters",
                'steps': [
                    "1. Create notification with special characters in content",
                    "2. Send notification",
                    "3. Verify delivery",
                ],
                'expected': [
                    "**Then** special characters are handled correctly",
                    "**And** notification is delivered",
                ],
            })
        else:
            # Generic edge case
            scenarios.append({
                'title': "Verify concurrent user access",
                'steps': [
                    "1. Open feature in two browser sessions",
                    "2. Perform actions simultaneously",
                    "3. Observe behavior",
                ],
                'expected': [
                    "**Then** both sessions function correctly",
                    "**And** no data conflicts occur",
                ],
            })

        return scenarios

    # ========================================================================
    # STATISTICS
    # ========================================================================

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_uat_tests(
    user_stories: list[dict],
    prefix: str = "UAT"
) -> list[dict]:
    """
    PURPOSE:
        Convenience function to generate UAT test cases.

    PARAMETERS:
        user_stories (list[dict]): Stories from UserStoryGenerator
        prefix (str): Test ID prefix

    RETURNS:
        list[dict]: List of test case dictionaries
    """
    generator = UATGenerator(test_id_prefix=prefix)
    return generator.generate(user_stories)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("UAT GENERATOR TEST (Derived from Acceptance Criteria)")
    print("=" * 70)

    # Sample user stories (as would come from UserStoryGenerator)
    sample_stories = [
        {
            'generated_id': 'TEST-RECRUIT-001',
            'title': 'Number (N) Invited',
            'category_abbrev': 'RECRUIT',
            'is_technical': True,
            'capability': 'track number of patients who received invitations',
            'priority': 'High',
            'acceptance_criteria': [
                'ACCEPTANCE CRITERIA:',
                '• Count of invited patients displays accurately',
                '• Metrics are segmented by program/channel',
                '• Data exportable for offline analysis',
                '',
                'SUCCESS METRICS:',
                '• Zero discrepancy between source and display',
                '• Data refresh completes within 15 minutes',
            ],
        },
        {
            'generated_id': 'TEST-MSG-001',
            'title': 'Email Opt-Out Tracking',
            'category_abbrev': 'MSG',
            'is_technical': True,
            'capability': 'track when patients opt out of email reminders',
            'priority': 'Medium',
            'acceptance_criteria': [
                'ACCEPTANCE CRITERIA:',
                '• System logs email sent with timestamp',
                '• Opt-out status captured with timestamp',
                '',
                'SUCCESS METRICS:',
                '• 100% of opt-outs honored within 24 hours',
            ],
        },
        {
            'generated_id': 'TEST-WF-001',
            'title': 'Manual Review Process',
            'category_abbrev': 'WF',
            'is_technical': False,  # Should be skipped
            'capability': 'update manual review workflow',
            'priority': 'Low',
            'acceptance_criteria': [
                'PROCESS CHANGE REQUIREMENTS:',
                '• Process documentation is updated',
            ],
        },
    ]

    generator = UATGenerator(test_id_prefix="TEST")
    tests = generator.generate(sample_stories)

    print(f"\nGenerated {len(tests)} test cases:")
    for test in tests[:5]:  # Show first 5
        print(f"\n{'─'*70}")
        print(f"Test ID: {test['test_id']}")
        print(f"Source Story: {test['source_story_id']}")
        print(f"Title: {test['title']}")
        print(f"Type: {test['test_type']}")
        print(f"MoSCoW: {test['moscow']}")
        print(f"\nExpected Results:")
        for er in test['expected_results'][:4]:
            print(f"  {er}")

    print(f"\n{'='*70}")
    print("Stats:", generator.get_stats())
