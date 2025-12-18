# generators/uat_generator.py
# ============================================================================
# UAT (User Acceptance Testing) Test Case Generator
# ============================================================================
#
# PURPOSE:
#     Takes user stories from UserStoryGenerator and creates comprehensive
#     UAT test cases covering happy path, negative tests, edge cases, and
#     boundary conditions.
#
# AVIATION ANALOGY:
#     Like creating a test flight card. You don't just test "can it fly" —
#     you test normal operations, emergency procedures, edge of envelope,
#     and failure modes. Each test has specific pass/fail criteria.
#
# R EQUIVALENT:
#     In R, you might use testthat for unit tests, but UAT is different —
#     it's human-executed testing. Think of this like generating a
#     structured test protocol that a QA person would follow manually.
#
# USAGE:
#     from generators.uat_generator import UATGenerator
#
#     generator = UATGenerator(
#         test_id_prefix="GRX",
#         category_abbreviations={"Authentication": "AUTH", "Reporting": "RPT"}
#     )
#     test_cases = generator.generate(user_stories)
#
# ============================================================================

import re
import hashlib
from typing import Optional
from datetime import datetime


class UATGenerator:
    """
    PURPOSE:
        Generate comprehensive UAT test cases from user stories.
        Creates structured test cases that can be executed by QA teams
        and exported to various formats (markdown, Excel).

    R EQUIVALENT:
        # R doesn't have a direct equivalent, but conceptually:
        # generate_test_cases <- function(stories, prefix = "TEST") {
        #     lapply(stories, function(story) {
        #         list(
        #             happy_path = create_happy_path_test(story),
        #             negative = create_negative_tests(story),
        #             edge_cases = create_edge_case_tests(story)
        #         )
        #     })
        # }

    ATTRIBUTES:
        test_id_prefix (str): Prefix for all test IDs (e.g., "GRX", "NCCN")
        category_abbreviations (dict): Maps categories to short codes
        test_counter (dict): Tracks test numbers per category
        moscow_mapping (dict): Maps priority levels to MoSCoW values

    WHY THIS CLASS:
        Encapsulating test generation in a class allows us to:
        1. Maintain state (counters) across multiple generate() calls
        2. Configure once, use many times
        3. Track statistics about generated tests
    """

    def __init__(
        self,
        test_id_prefix: str = "UAT",
        category_abbreviations: Optional[dict[str, str]] = None
    ):
        """
        PURPOSE:
            Initialize the UAT generator with configuration options.

        R EQUIVALENT:
            # In R, you'd set these as function parameters with defaults:
            # generate_uat <- function(stories, prefix = "UAT", categories = list())

        PARAMETERS:
            test_id_prefix (str): Prefix for test IDs. Examples:
                - "GRX" for Graphite Health project
                - "NCCN" for NCCN project
                - "TF" for TechFlow project
                Default: "UAT"

            category_abbreviations (dict): Maps full category names to short codes.
                Example: {"Authentication": "AUTH", "Reporting": "RPT"}
                If None, will auto-generate abbreviations.

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            Making these configurable means the same generator can be used
            across different projects with different naming conventions.
            The test_id_prefix is especially important for traceability —
            you want test IDs that are unique and identifiable.
        """
        # Store the prefix for test ID generation
        # WHY: This appears at the start of every test ID for project identification
        self.test_id_prefix = test_id_prefix.upper()

        # Store category abbreviations, or start with empty dict
        # WHY: Short codes make test IDs readable while keeping them compact
        # Example: "GRX-AUTH-001" instead of "GRX-Authentication-001"
        self.category_abbreviations = category_abbreviations or {}

        # Track test numbers per category for sequential numbering
        # WHY: We want "AUTH-001", "AUTH-002", not just random numbers
        # This resets when you create a new generator instance
        # R EQUIVALENT: Like using a named list to track counters
        #   counters <- list(AUTH = 0, RPT = 0)
        self.test_counter: dict[str, int] = {}

        # Map user story priorities to MoSCoW values
        # WHY: MoSCoW (Must/Should/Could/Won't) is standard UAT prioritization
        # Our user stories use Critical/High/Medium/Low, so we need mapping
        self.moscow_mapping = {
            'critical': 'Must Have',
            'high': 'Must Have',
            'medium': 'Should Have',
            'low': 'Could Have',
            'none': 'Could Have'  # Fallback for unspecified
        }

        # Keywords that indicate specific feature types
        # WHY: Different features need different types of tests
        # Login features need security tests; export features need format tests
        self._feature_keywords = {
            'authentication': [
                'login', 'logout', 'password', 'auth', 'sign in', 'sign out',
                'credential', 'session', 'token', 'sso', 'mfa', '2fa',
                'two-factor', 'authenticate', 'register', 'self-register'
            ],
            'data_entry': [
                'create', 'add', 'enter', 'input', 'submit', 'save',
                'capture', 'record', 'register', 'form', 'fill'
            ],
            'data_display': [
                'view', 'display', 'show', 'see', 'list', 'dashboard',
                'report', 'summary', 'overview', 'status'
            ],
            'data_modification': [
                'edit', 'update', 'modify', 'change', 'revise', 'correct'
            ],
            'data_deletion': [
                'delete', 'remove', 'cancel', 'archive', 'deactivate'
            ],
            'export': [
                'export', 'download', 'extract', 'generate report',
                'pdf', 'excel', 'csv', 'print'
            ],
            'import': [
                'import', 'upload', 'load', 'bulk', 'batch', 'migrate'
            ],
            'search': [
                'search', 'find', 'filter', 'query', 'lookup', 'locate'
            ],
            'notification': [
                'notify', 'alert', 'email', 'sms', 'message', 'remind',
                'notification', 'send'
            ],
            'scheduling': [
                'schedule', 'book', 'appointment', 'calendar', 'reserve',
                'reschedule', 'slot', 'availability'
            ],
            'validation': [
                'validate', 'verify', 'check', 'confirm', 'eligibility',
                'insurance', 'coverage'
            ],
            'integration': [
                'integrate', 'connect', 'sync', 'api', 'interface',
                'external', 'third-party', 'webhook'
            ]
        }

        # Time estimates by test complexity
        # WHY: Realistic time estimates help QA planning
        # These are based on typical manual testing durations
        self._time_estimates = {
            'simple': '2-3 min',      # Single action, obvious result
            'moderate': '5-7 min',    # Multiple steps, some verification
            'complex': '10-15 min',   # Many steps, data setup required
            'extensive': '15-20 min'  # Full workflow, multiple verifications
        }

        # Statistics tracking
        # WHY: Useful for reporting how many tests were generated
        self.stats = {
            'total_tests': 0,
            'happy_path_tests': 0,
            'negative_tests': 0,
            'edge_case_tests': 0,
            'boundary_tests': 0,
            'stories_processed': 0
        }

    def generate(self, user_stories: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Generate UAT test cases for a list of user stories.
            This is the main entry point for the generator.

        R EQUIVALENT:
            # Like using lapply to process each story:
            # all_tests <- do.call(rbind, lapply(stories, generate_tests_for_story))

        PARAMETERS:
            user_stories (list[dict]): List of user story dictionaries from
                UserStoryGenerator. Each should have:
                - title: Feature title
                - user_story: "As a X, I want Y, so that Z"
                - capability: The "Y" part
                - priority: Critical/High/Medium/Low
                - acceptance_criteria: List of criteria
                - category: Feature category (optional)

        RETURNS:
            list[dict]: List of test case dictionaries, each containing:
                - test_id: Unique identifier (e.g., "GRX-AUTH-001")
                - category: Full category name
                - category_code: Abbreviated category code
                - title: Short test description
                - prerequisites: List of setup requirements
                - test_steps: List of numbered steps
                - expected_results: List of expected outcomes
                - moscow: MoSCoW priority
                - est_time: Estimated execution time
                - notes: Additional considerations
                - test_type: 'happy_path', 'negative', 'edge_case', 'boundary'
                - source_story_id: ID of the user story this tests
                - source_story_title: Title of the source story

        WHY THIS APPROACH:
            We generate multiple test cases per user story because:
            1. Happy path alone isn't sufficient — users will hit errors
            2. Edge cases catch bugs that happy path misses
            3. Negative tests ensure graceful failure handling
            4. Comprehensive coverage reduces production issues
        """
        all_test_cases = []

        for story in user_stories:
            self.stats['stories_processed'] += 1

            # Determine the category for this story
            # WHY: Category drives test ID format and helps organize tests
            category = self._determine_category(story)
            category_code = self._get_category_code(category)

            # Detect what type of feature this is
            # WHY: Different features need different test strategies
            feature_type = self._detect_feature_type(story)

            # Generate the various types of tests
            # Each method returns a list of test case dicts

            # 1. Happy path — the "it works" test
            happy_path = self._generate_happy_path_test(
                story, category, category_code, feature_type
            )
            all_test_cases.extend(happy_path)

            # 2. Negative tests — the "it fails gracefully" tests
            negative_tests = self._generate_negative_tests(
                story, category, category_code, feature_type
            )
            all_test_cases.extend(negative_tests)

            # 3. Edge case tests — the "unusual but valid" tests
            edge_cases = self._generate_edge_case_tests(
                story, category, category_code, feature_type
            )
            all_test_cases.extend(edge_cases)

            # 4. Boundary tests — the "limits" tests (when applicable)
            boundary_tests = self._generate_boundary_tests(
                story, category, category_code, feature_type
            )
            all_test_cases.extend(boundary_tests)

        return all_test_cases

    def _determine_category(self, story: dict) -> str:
        """
        PURPOSE:
            Determine the category for a user story.
            Uses explicit category if provided, otherwise infers from content.

        R EQUIVALENT:
            # determine_category <- function(story) {
            #     if (!is.null(story$category)) return(story$category)
            #     # else infer from content...
            # }

        PARAMETERS:
            story (dict): The user story dictionary

        RETURNS:
            str: Category name (e.g., "Authentication", "Reporting")

        WHY THIS APPROACH:
            Categories help organize tests and create meaningful test IDs.
            We prefer explicit categories but can infer when not provided.
        """
        # Use explicit category if provided and not None/"None"
        explicit_category = story.get('category')
        if explicit_category and explicit_category.lower() != 'none':
            return explicit_category

        # Infer category from feature type detection
        feature_type = self._detect_feature_type(story)

        # Map feature types to category names
        # WHY: Provides user-friendly category names for test organization
        category_mapping = {
            'authentication': 'Authentication',
            'data_entry': 'Data Entry',
            'data_display': 'Data Display',
            'data_modification': 'Data Modification',
            'data_deletion': 'Data Management',
            'export': 'Reporting',
            'import': 'Data Import',
            'search': 'Search',
            'notification': 'Notifications',
            'scheduling': 'Scheduling',
            'validation': 'Validation',
            'integration': 'Integration'
        }

        return category_mapping.get(feature_type, 'General')

    def _get_category_code(self, category: str) -> str:
        """
        PURPOSE:
            Get the short code for a category (for test IDs).

        R EQUIVALENT:
            # get_code <- function(category, abbreviations) {
            #     if (category %in% names(abbreviations)) {
            #         return(abbreviations[[category]])
            #     }
            #     return(toupper(substr(category, 1, 3)))
            # }

        PARAMETERS:
            category (str): Full category name

        RETURNS:
            str: Short code (3-4 characters)

        WHY THIS APPROACH:
            Short codes keep test IDs readable while maintaining meaning.
            "GRX-AUTH-001" is clearer than "GRX-A-001" but shorter than
            "GRX-Authentication-001".
        """
        # Check if we have a configured abbreviation
        if category in self.category_abbreviations:
            return self.category_abbreviations[category]

        # Auto-generate abbreviation
        # Strategy: First 3-4 letters, uppercase
        # Special handling for multi-word categories
        words = category.split()
        if len(words) > 1:
            # Use first letter of each word (e.g., "Data Entry" → "DE")
            code = ''.join(word[0].upper() for word in words[:3])
        else:
            # Use first 3-4 characters
            code = category[:4].upper()

        # Store for future use
        self.category_abbreviations[category] = code
        return code

    def _generate_test_id(self, category_code: str) -> str:
        """
        PURPOSE:
            Generate a unique, sequential test ID.

        R EQUIVALENT:
            # In R, you'd increment a counter in an environment:
            # counter_env$AUTH <- counter_env$AUTH + 1
            # sprintf("%s-%s-%03d", prefix, code, counter_env$AUTH)

        PARAMETERS:
            category_code (str): The category abbreviation (e.g., "AUTH")

        RETURNS:
            str: Unique test ID (e.g., "GRX-AUTH-001")

        WHY THIS APPROACH:
            Sequential numbering within categories makes tests easy to
            reference and track. The format PREFIX-CATEGORY-NUMBER is
            standard in QA documentation.
        """
        # Initialize counter for this category if needed
        if category_code not in self.test_counter:
            self.test_counter[category_code] = 0

        # Increment and format
        self.test_counter[category_code] += 1
        number = self.test_counter[category_code]

        # Format: PREFIX-CATEGORY-NNN (3-digit padded)
        return f"{self.test_id_prefix}-{category_code}-{number:03d}"

    def _detect_feature_type(self, story: dict) -> str:
        """
        PURPOSE:
            Detect what type of feature a user story represents.
            This drives test generation strategy.

        R EQUIVALENT:
            # detect_type <- function(story) {
            #     text <- tolower(paste(story$capability, story$title))
            #     for (type in names(keywords)) {
            #         if (any(sapply(keywords[[type]], grepl, text))) {
            #             return(type)
            #         }
            #     }
            #     return("general")
            # }

        PARAMETERS:
            story (dict): The user story dictionary

        RETURNS:
            str: Feature type (e.g., 'authentication', 'data_entry', 'export')

        WHY THIS APPROACH:
            Different feature types need different testing strategies.
            Login features need security tests; export features need
            format verification tests. Keyword matching is simple and
            effective for this classification task.
        """
        # Combine relevant text fields for analysis
        text_to_analyze = ' '.join([
            story.get('title', ''),
            story.get('capability', ''),
            story.get('user_story', ''),
            story.get('description', '')
        ]).lower()

        # Check each feature type's keywords
        # WHY: We iterate in a specific order to prioritize more specific matches
        for feature_type, keywords in self._feature_keywords.items():
            for keyword in keywords:
                if keyword in text_to_analyze:
                    return feature_type

        # Default if no specific type detected
        return 'general'

    def _get_moscow_priority(self, story: dict) -> str:
        """
        PURPOSE:
            Map user story priority to MoSCoW classification.

        PARAMETERS:
            story (dict): The user story dictionary

        RETURNS:
            str: MoSCoW value ('Must Have', 'Should Have', 'Could Have')

        WHY THIS APPROACH:
            MoSCoW is the standard prioritization scheme for UAT.
            We map from our priority levels to ensure consistency.
        """
        priority = story.get('priority', 'medium').lower()
        return self.moscow_mapping.get(priority, 'Should Have')

    def _generate_happy_path_test(
        self,
        story: dict,
        category: str,
        category_code: str,
        feature_type: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate the "happy path" test — the normal, successful flow.
            Every feature needs at least one test that verifies it works
            as designed when used correctly.

        R EQUIVALENT:
            # create_happy_path <- function(story, category) {
            #     list(
            #         title = paste("Verify", story$capability),
            #         steps = generate_steps(story$capability),
            #         expected = generate_expectations(story$capability)
            #     )
            # }

        PARAMETERS:
            story (dict): The user story
            category (str): Category name
            category_code (str): Category abbreviation
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List containing one happy path test case

        WHY THIS APPROACH:
            Happy path is the foundation of UAT — it proves the feature
            works as specified. We generate steps from the capability
            and expected results from acceptance criteria.
        """
        test_id = self._generate_test_id(category_code)
        capability = story.get('capability', 'complete the action')
        title = story.get('title', capability)

        # Generate test steps based on feature type
        steps = self._generate_happy_path_steps(story, feature_type)

        # Generate expected results
        expected = self._generate_expected_results(story, feature_type, 'happy_path')

        # Generate prerequisites
        prerequisites = self._generate_prerequisites(story, feature_type, 'happy_path')

        # Estimate time based on step count
        est_time = self._estimate_time(len(steps), 'happy_path')

        # Create the test case
        test_case = {
            'test_id': test_id,
            'category': category,
            'category_code': category_code,
            'title': f"Verify {self._clean_title(title)}",
            'prerequisites': prerequisites,
            'test_steps': steps,
            'expected_results': expected,
            'moscow': self._get_moscow_priority(story),
            'est_time': est_time,
            'notes': self._generate_notes(story, feature_type, 'happy_path'),
            'test_type': 'happy_path',
            'source_story_id': story.get('generated_id', 'N/A'),
            'source_story_title': story.get('title', 'N/A')
        }

        self.stats['total_tests'] += 1
        self.stats['happy_path_tests'] += 1

        return [test_case]

    def _generate_happy_path_steps(self, story: dict, feature_type: str) -> list[str]:
        """
        PURPOSE:
            Generate numbered test steps for the happy path.

        PARAMETERS:
            story (dict): The user story
            feature_type (str): Type of feature

        RETURNS:
            list[str]: List of numbered step strings

        WHY THIS APPROACH:
            Steps are generated based on feature type patterns.
            Each feature type has typical workflows that we can template.
        """
        capability = story.get('capability', 'perform the action')
        role = story.get('role', 'user')

        # Feature-specific step templates
        # WHY: Each feature type has a typical workflow pattern
        step_templates = {
            'authentication': [
                f"Navigate to the login page",
                f"Enter valid username/email",
                f"Enter valid password",
                f"Click the login/sign-in button",
                f"Verify successful authentication"
            ],
            'data_entry': [
                f"Navigate to the {self._extract_data_subject(capability)} entry screen",
                f"Enter all required fields with valid data",
                f"Enter optional fields as needed",
                f"Click Save/Submit button",
                f"Verify confirmation message appears"
            ],
            'data_display': [
                f"Log in as {role} with appropriate permissions",
                f"Navigate to the {self._extract_data_subject(capability)} view",
                f"Verify the data displays correctly",
                f"Check that all expected fields are visible"
            ],
            'data_modification': [
                f"Navigate to the existing {self._extract_data_subject(capability)} record",
                f"Click Edit button",
                f"Modify one or more fields with valid data",
                f"Click Save/Update button",
                f"Verify changes are saved and displayed correctly"
            ],
            'data_deletion': [
                f"Navigate to the {self._extract_data_subject(capability)} to be deleted",
                f"Click Delete/Remove button",
                f"Confirm the deletion in the confirmation dialog",
                f"Verify the item is removed from the list"
            ],
            'export': [
                f"Navigate to the {self._extract_data_subject(capability)} area",
                f"Select the data or date range to export",
                f"Click Export/Download button",
                f"Choose the desired format if prompted",
                f"Verify the file downloads successfully",
                f"Open the file and verify contents are correct"
            ],
            'import': [
                f"Navigate to the import function",
                f"Select a valid import file in the correct format",
                f"Click Upload/Import button",
                f"Wait for import processing to complete",
                f"Verify success message and record count",
                f"Verify imported data appears correctly in the system"
            ],
            'search': [
                f"Navigate to the search feature",
                f"Enter valid search criteria",
                f"Click Search button or press Enter",
                f"Verify matching results are displayed",
                f"Verify result count is accurate"
            ],
            'notification': [
                f"Trigger the notification condition",
                f"Wait for the notification to be sent",
                f"Verify notification is received (email/SMS/in-app)",
                f"Verify notification content is correct"
            ],
            'scheduling': [
                f"Navigate to the scheduling/booking feature",
                f"Select an available date and time slot",
                f"Enter any required booking details",
                f"Confirm the booking",
                f"Verify confirmation message/email is received"
            ],
            'validation': [
                f"Navigate to the validation feature",
                f"Enter the data to be validated",
                f"Click Validate/Check button",
                f"Wait for validation to complete",
                f"Verify validation result is displayed correctly"
            ],
            'integration': [
                f"Ensure external system is accessible",
                f"Trigger the integration action",
                f"Wait for sync/connection to complete",
                f"Verify data is correctly exchanged",
                f"Check both systems show consistent data"
            ]
        }

        # Get template or use generic steps
        if feature_type in step_templates:
            steps = step_templates[feature_type]
        else:
            # Generic steps based on capability
            steps = [
                f"Log in with appropriate credentials",
                f"Navigate to the relevant feature area",
                f"Perform the action: {capability}",
                f"Verify the action completes successfully"
            ]

        # Number the steps
        return [f"{i}. {step}" for i, step in enumerate(steps, 1)]

    def _generate_negative_tests(
        self,
        story: dict,
        category: str,
        category_code: str,
        feature_type: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate negative tests — what happens when things go wrong?
            These verify the system handles errors gracefully.

        R EQUIVALENT:
            # create_negative_tests <- function(story, type) {
            #     scenarios <- get_failure_scenarios(type)
            #     lapply(scenarios, function(s) create_test(story, s))
            # }

        PARAMETERS:
            story (dict): The user story
            category (str): Category name
            category_code (str): Category abbreviation
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List of negative test cases

        WHY THIS APPROACH:
            Negative tests are crucial for robust systems. Users WILL
            enter bad data, lose network, click wrong buttons. We need
            to verify the system doesn't crash or lose data.
        """
        negative_tests = []

        # Get failure scenarios based on feature type
        scenarios = self._get_negative_scenarios(feature_type)

        for scenario in scenarios:
            test_id = self._generate_test_id(category_code)

            test_case = {
                'test_id': test_id,
                'category': category,
                'category_code': category_code,
                'title': scenario['title'],
                'prerequisites': scenario.get('prerequisites', [
                    "User is logged in with appropriate role",
                    "Test data is prepared as specified"
                ]),
                'test_steps': [f"{i}. {step}" for i, step in enumerate(scenario['steps'], 1)],
                'expected_results': scenario['expected'],
                'moscow': 'Should Have',  # Negative tests are typically Should Have
                'est_time': self._estimate_time(len(scenario['steps']), 'negative'),
                'notes': scenario.get('notes', 'Verify error handling and user feedback'),
                'test_type': 'negative',
                'source_story_id': story.get('generated_id', 'N/A'),
                'source_story_title': story.get('title', 'N/A')
            }

            negative_tests.append(test_case)
            self.stats['total_tests'] += 1
            self.stats['negative_tests'] += 1

        return negative_tests

    def _get_negative_scenarios(self, feature_type: str) -> list[dict]:
        """
        PURPOSE:
            Get failure scenarios specific to a feature type.

        PARAMETERS:
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List of scenario definitions

        WHY THIS APPROACH:
            Different features have different failure modes.
            Login can fail with bad password; export can fail with
            no data. We define common scenarios per feature type.
        """
        # Common scenarios applicable to most features
        common_scenarios = [
            {
                'title': 'Verify unauthorized access is blocked',
                'steps': [
                    "Log out of the system",
                    "Attempt to access the feature URL directly",
                    "Observe the system response"
                ],
                'expected': [
                    "• User is redirected to login page",
                    "• No protected data is displayed",
                    "• Session is not created"
                ],
                'notes': 'Security test - verify authentication is enforced'
            }
        ]

        # Feature-specific scenarios
        feature_scenarios = {
            'authentication': [
                {
                    'title': 'Verify login fails with invalid password',
                    'steps': [
                        "Navigate to login page",
                        "Enter valid username",
                        "Enter incorrect password",
                        "Click login button"
                    ],
                    'expected': [
                        "• Error message displayed (generic, not revealing which field is wrong)",
                        "• User remains on login page",
                        "• Failed attempt is logged"
                    ],
                    'notes': 'Do not reveal whether username or password was incorrect'
                },
                {
                    'title': 'Verify login fails with non-existent user',
                    'steps': [
                        "Navigate to login page",
                        "Enter non-existent username",
                        "Enter any password",
                        "Click login button"
                    ],
                    'expected': [
                        "• Same generic error message as invalid password",
                        "• No indication that user doesn't exist",
                        "• Response time similar to valid user check"
                    ],
                    'notes': 'Prevents user enumeration attacks'
                }
            ],
            'data_entry': [
                {
                    'title': 'Verify form submission fails with missing required fields',
                    'steps': [
                        "Navigate to the data entry form",
                        "Leave required fields empty",
                        "Attempt to submit the form"
                    ],
                    'expected': [
                        "• Form submission is prevented",
                        "• Required fields are highlighted",
                        "• Clear error message indicates what's missing",
                        "• Previously entered data is preserved"
                    ]
                },
                {
                    'title': 'Verify form validation for invalid data format',
                    'steps': [
                        "Navigate to the data entry form",
                        "Enter invalid format (e.g., letters in phone field, invalid email)",
                        "Attempt to submit"
                    ],
                    'expected': [
                        "• Validation error is displayed",
                        "• Invalid field is highlighted",
                        "• Helpful format guidance is shown"
                    ]
                }
            ],
            'export': [
                {
                    'title': 'Verify export handles no data gracefully',
                    'steps': [
                        "Navigate to export feature",
                        "Select filters/date range with no matching data",
                        "Attempt to export"
                    ],
                    'expected': [
                        "• Informative message: 'No data to export' or similar",
                        "• No empty/corrupt file is generated",
                        "• User can adjust filters and retry"
                    ]
                }
            ],
            'import': [
                {
                    'title': 'Verify import rejects invalid file format',
                    'steps': [
                        "Navigate to import feature",
                        "Select a file in wrong format (e.g., .txt instead of .xlsx)",
                        "Attempt to upload"
                    ],
                    'expected': [
                        "• Clear error message about invalid format",
                        "• List of supported formats is shown",
                        "• System state is unchanged"
                    ]
                },
                {
                    'title': 'Verify import handles corrupted file',
                    'steps': [
                        "Navigate to import feature",
                        "Upload a corrupted/invalid file",
                        "Attempt to process"
                    ],
                    'expected': [
                        "• Error message indicates file is unreadable",
                        "• Partial data is NOT imported",
                        "• Transaction is rolled back if applicable"
                    ],
                    'notes': 'Important for data integrity'
                }
            ],
            'search': [
                {
                    'title': 'Verify search handles no results',
                    'steps': [
                        "Navigate to search feature",
                        "Enter search term with no matches",
                        "Execute search"
                    ],
                    'expected': [
                        "• 'No results found' message displayed",
                        "• Suggestions offered (check spelling, broaden search)",
                        "• Search criteria remains visible for modification"
                    ]
                }
            ],
            'scheduling': [
                {
                    'title': 'Verify booking unavailable slot fails gracefully',
                    'steps': [
                        "Navigate to scheduling feature",
                        "Attempt to book an already-taken slot",
                        "Submit the booking"
                    ],
                    'expected': [
                        "• Error indicates slot is no longer available",
                        "• Alternative slots are suggested",
                        "• No double-booking occurs"
                    ],
                    'notes': 'Handles race condition when slot is taken between display and booking'
                }
            ],
            'validation': [
                {
                    'title': 'Verify validation handles invalid data',
                    'steps': [
                        "Navigate to validation feature",
                        "Enter data that should fail validation",
                        "Execute validation"
                    ],
                    'expected': [
                        "• Clear indication of validation failure",
                        "• Specific reason for failure is shown",
                        "• Guidance on correcting the data"
                    ]
                }
            ]
        }

        # Get scenarios for this feature type, plus common ones
        scenarios = feature_scenarios.get(feature_type, []) + common_scenarios

        return scenarios

    def _generate_edge_case_tests(
        self,
        story: dict,
        category: str,
        category_code: str,
        feature_type: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate edge case tests — unusual but valid scenarios.
            These catch bugs that happy path testing misses.

        PARAMETERS:
            story (dict): The user story
            category (str): Category name
            category_code (str): Category abbreviation
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List of edge case test cases

        WHY THIS APPROACH:
            Edge cases represent the boundaries of normal usage.
            Empty inputs, special characters, very long text — these
            are valid inputs that often break systems.
        """
        edge_tests = []

        # Get edge case scenarios
        scenarios = self._get_edge_case_scenarios(feature_type, story)

        for scenario in scenarios:
            test_id = self._generate_test_id(category_code)

            test_case = {
                'test_id': test_id,
                'category': category,
                'category_code': category_code,
                'title': scenario['title'],
                'prerequisites': scenario.get('prerequisites', [
                    "User is logged in with appropriate role",
                    "Test environment supports edge case data"
                ]),
                'test_steps': [f"{i}. {step}" for i, step in enumerate(scenario['steps'], 1)],
                'expected_results': scenario['expected'],
                'moscow': 'Could Have',  # Edge cases are typically Could Have
                'est_time': self._estimate_time(len(scenario['steps']), 'edge_case'),
                'notes': scenario.get('notes', 'Edge case - verify robustness'),
                'test_type': 'edge_case',
                'source_story_id': story.get('generated_id', 'N/A'),
                'source_story_title': story.get('title', 'N/A')
            }

            edge_tests.append(test_case)
            self.stats['total_tests'] += 1
            self.stats['edge_case_tests'] += 1

        return edge_tests

    def _get_edge_case_scenarios(self, feature_type: str, story: dict) -> list[dict]:
        """
        PURPOSE:
            Get edge case scenarios for a feature type.

        PARAMETERS:
            feature_type (str): Type of feature
            story (dict): The user story (for context)

        RETURNS:
            list[dict]: List of edge case scenario definitions
        """
        # Common edge cases applicable to many features
        common_edge_cases = [
            {
                'title': 'Verify handling of special characters in input',
                'steps': [
                    "Navigate to the feature",
                    "Enter data containing special characters: < > & \" ' / \\",
                    "Submit/save the data",
                    "Verify data is handled correctly"
                ],
                'expected': [
                    "• Special characters are properly escaped/encoded",
                    "• No XSS or injection vulnerabilities",
                    "• Data displays correctly when retrieved"
                ],
                'notes': 'Security consideration - prevents injection attacks'
            }
        ]

        # Feature-specific edge cases
        feature_edge_cases = {
            'data_entry': [
                {
                    'title': 'Verify handling of maximum length input',
                    'steps': [
                        "Navigate to the entry form",
                        "Enter maximum allowed characters in text fields",
                        "Submit the form"
                    ],
                    'expected': [
                        "• System accepts input up to max length",
                        "• No truncation occurs without warning",
                        "• Database stores full value"
                    ]
                },
                {
                    'title': 'Verify duplicate entry prevention',
                    'steps': [
                        "Create a record with specific identifying data",
                        "Attempt to create another record with same identifiers",
                        "Observe system behavior"
                    ],
                    'expected': [
                        "• Duplicate is detected",
                        "• Clear message about existing record",
                        "• Option to view existing or modify entry"
                    ],
                    'notes': 'May not apply if duplicates are allowed'
                }
            ],
            'search': [
                {
                    'title': 'Verify search with Unicode/international characters',
                    'steps': [
                        "Navigate to search",
                        "Enter search term with accented/international characters",
                        "Execute search"
                    ],
                    'expected': [
                        "• Search executes without error",
                        "• Matching results are returned",
                        "• Characters display correctly"
                    ]
                },
                {
                    'title': 'Verify search with very long query',
                    'steps': [
                        "Navigate to search",
                        "Enter a very long search query (100+ characters)",
                        "Execute search"
                    ],
                    'expected': [
                        "• Search executes or is gracefully limited",
                        "• No system error or crash",
                        "• User is informed if query was truncated"
                    ]
                }
            ],
            'export': [
                {
                    'title': 'Verify export of large dataset',
                    'steps': [
                        "Select filters that return large result set (1000+ records)",
                        "Initiate export",
                        "Wait for completion"
                    ],
                    'expected': [
                        "• Progress indicator shown for long operations",
                        "• Export completes successfully",
                        "• File is complete and not corrupted"
                    ],
                    'notes': 'May require longer timeout'
                }
            ],
            'import': [
                {
                    'title': 'Verify import of large batch file',
                    'steps': [
                        "Prepare import file with 1000+ records",
                        "Upload and process the file",
                        "Verify import results"
                    ],
                    'expected': [
                        "• Progress indicator during processing",
                        "• All valid records imported",
                        "• Summary report of success/failure counts"
                    ],
                    'notes': 'Performance test - may need adjusted timeout'
                },
                {
                    'title': 'Verify import handles blank rows gracefully',
                    'steps': [
                        "Prepare import file with scattered blank rows",
                        "Upload and process",
                        "Check results"
                    ],
                    'expected': [
                        "• Blank rows are skipped without error",
                        "• Valid data rows are processed",
                        "• Report indicates rows skipped"
                    ]
                }
            ],
            'scheduling': [
                {
                    'title': 'Verify concurrent booking handling',
                    'steps': [
                        "Open booking page in two browser windows",
                        "Select same time slot in both",
                        "Submit both bookings simultaneously"
                    ],
                    'expected': [
                        "• Only one booking succeeds",
                        "• Other receives 'slot taken' message",
                        "• No double-booking in system"
                    ],
                    'notes': 'Race condition test - critical for booking systems'
                }
            ]
        }

        # Get applicable scenarios
        scenarios = feature_edge_cases.get(feature_type, [])

        # Add common edge cases for data entry/modification features
        if feature_type in ['data_entry', 'data_modification', 'search']:
            scenarios.extend(common_edge_cases)

        return scenarios

    def _generate_boundary_tests(
        self,
        story: dict,
        category: str,
        category_code: str,
        feature_type: str
    ) -> list[dict]:
        """
        PURPOSE:
            Generate boundary condition tests — testing the limits.
            These verify behavior at minimum, maximum, and edge values.

        PARAMETERS:
            story (dict): The user story
            category (str): Category name
            category_code (str): Category abbreviation
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List of boundary test cases

        WHY THIS APPROACH:
            Boundary testing catches off-by-one errors and limit issues.
            If a field allows 1-100, test 0, 1, 100, and 101.
        """
        boundary_tests = []

        # Only generate boundary tests for features that have clear boundaries
        if feature_type not in ['data_entry', 'search', 'scheduling', 'data_modification']:
            return boundary_tests

        # Get boundary scenarios
        scenarios = self._get_boundary_scenarios(feature_type)

        for scenario in scenarios:
            test_id = self._generate_test_id(category_code)

            test_case = {
                'test_id': test_id,
                'category': category,
                'category_code': category_code,
                'title': scenario['title'],
                'prerequisites': scenario.get('prerequisites', [
                    "User is logged in with appropriate role",
                    "Boundary values are documented"
                ]),
                'test_steps': [f"{i}. {step}" for i, step in enumerate(scenario['steps'], 1)],
                'expected_results': scenario['expected'],
                'moscow': 'Could Have',
                'est_time': self._estimate_time(len(scenario['steps']), 'boundary'),
                'notes': scenario.get('notes', 'Boundary test - verify limits are enforced'),
                'test_type': 'boundary',
                'source_story_id': story.get('generated_id', 'N/A'),
                'source_story_title': story.get('title', 'N/A')
            }

            boundary_tests.append(test_case)
            self.stats['total_tests'] += 1
            self.stats['boundary_tests'] += 1

        return boundary_tests

    def _get_boundary_scenarios(self, feature_type: str) -> list[dict]:
        """
        PURPOSE:
            Get boundary test scenarios for a feature type.

        PARAMETERS:
            feature_type (str): Type of feature

        RETURNS:
            list[dict]: List of boundary scenario definitions
        """
        boundary_scenarios = {
            'data_entry': [
                {
                    'title': 'Verify minimum required field length',
                    'steps': [
                        "Navigate to the form",
                        "Enter single character in a required text field",
                        "Attempt to submit"
                    ],
                    'expected': [
                        "• If minimum > 1, validation error displayed",
                        "• If minimum = 1, submission succeeds",
                        "• Clear message about minimum length requirement"
                    ]
                },
                {
                    'title': 'Verify numeric field minimum value',
                    'steps': [
                        "Navigate to the form",
                        "Enter 0 or negative number in numeric field",
                        "Attempt to submit"
                    ],
                    'expected': [
                        "• Validation enforces minimum value",
                        "• Error message shows allowed range"
                    ],
                    'notes': 'Document actual min/max for each numeric field'
                }
            ],
            'search': [
                {
                    'title': 'Verify minimum search query length',
                    'steps': [
                        "Navigate to search",
                        "Enter single character search query",
                        "Attempt to search"
                    ],
                    'expected': [
                        "• System either performs search or",
                        "• Shows message about minimum query length"
                    ]
                }
            ],
            'scheduling': [
                {
                    'title': 'Verify booking at earliest available time',
                    'steps': [
                        "Navigate to scheduling",
                        "Select the earliest available slot",
                        "Complete the booking"
                    ],
                    'expected': [
                        "• Booking is accepted",
                        "• Confirmation shows correct time"
                    ]
                },
                {
                    'title': 'Verify booking at latest available time',
                    'steps': [
                        "Navigate to scheduling",
                        "Select the latest available slot in the day",
                        "Complete the booking"
                    ],
                    'expected': [
                        "• Booking is accepted",
                        "• No time zone issues at day boundary"
                    ]
                }
            ]
        }

        return boundary_scenarios.get(feature_type, [])

    def _generate_expected_results(
        self,
        story: dict,
        feature_type: str,
        test_type: str
    ) -> list[str]:
        """
        PURPOSE:
            Generate expected results for a test case.
            Uses acceptance criteria from the story plus type-specific outcomes.

        PARAMETERS:
            story (dict): The user story
            feature_type (str): Type of feature
            test_type (str): Type of test (happy_path, negative, etc.)

        RETURNS:
            list[str]: List of bulleted expected results

        WHY THIS APPROACH:
            Expected results should be specific and observable.
            We combine story acceptance criteria with common expectations
            for the feature type.
        """
        expected = []

        # Use acceptance criteria from the story if available
        acceptance_criteria = story.get('acceptance_criteria', [])
        for criterion in acceptance_criteria[:3]:  # Limit to avoid overwhelming
            # Clean up the criterion for expected result format
            clean = criterion.strip().rstrip('.')
            if not clean.startswith('•'):
                clean = f"• {clean}"
            expected.append(clean)

        # Add feature-specific expected results if we don't have enough
        if len(expected) < 2:
            type_expected = {
                'authentication': [
                    "• User is successfully authenticated",
                    "• Dashboard/home page is displayed",
                    "• Session is created with appropriate timeout"
                ],
                'data_entry': [
                    "• Record is created successfully",
                    "• Confirmation message is displayed",
                    "• New record appears in the list/search"
                ],
                'data_display': [
                    "• Data displays correctly and completely",
                    "• Formatting is consistent and readable",
                    "• No placeholder or error text visible"
                ],
                'data_modification': [
                    "• Changes are saved successfully",
                    "• Updated values display correctly",
                    "• Modification timestamp is updated"
                ],
                'data_deletion': [
                    "• Record is removed from active list",
                    "• Confirmation message displayed",
                    "• Related data handled appropriately"
                ],
                'export': [
                    "• File downloads to user's device",
                    "• File format is correct",
                    "• Data in file matches source"
                ],
                'import': [
                    "• All valid records are imported",
                    "• Success count is displayed",
                    "• Imported data is visible in system"
                ],
                'search': [
                    "• Matching results are displayed",
                    "• Results are relevant to search criteria",
                    "• Result count is shown"
                ],
                'notification': [
                    "• Notification is sent successfully",
                    "• Content is correct and formatted properly",
                    "• Delivery timing is within SLA"
                ],
                'scheduling': [
                    "• Booking is confirmed",
                    "• Confirmation details are accurate",
                    "• Calendar/schedule reflects the booking"
                ],
                'validation': [
                    "• Validation result is clearly displayed",
                    "• Valid data receives success indication",
                    "• Processing time is acceptable"
                ],
                'integration': [
                    "• Data syncs successfully",
                    "• Both systems reflect changes",
                    "• No duplicate records created"
                ]
            }

            # Add type-specific expected results
            for result in type_expected.get(feature_type, []):
                if result not in expected:
                    expected.append(result)

        return expected[:5]  # Limit to 5 expected results

    def _generate_prerequisites(
        self,
        story: dict,
        feature_type: str,
        test_type: str
    ) -> list[str]:
        """
        PURPOSE:
            Generate prerequisites (setup requirements) for a test case.

        PARAMETERS:
            story (dict): The user story
            feature_type (str): Type of feature
            test_type (str): Type of test

        RETURNS:
            list[str]: List of prerequisite statements

        WHY THIS APPROACH:
            Clear prerequisites ensure tests are repeatable.
            Testers need to know exactly what state the system
            should be in before executing the test.
        """
        prereqs = []
        role = story.get('role', 'user')

        # Base prerequisites
        if feature_type != 'authentication':
            prereqs.append(f"User is logged in as {role}")

        # Feature-specific prerequisites
        feature_prereqs = {
            'authentication': [
                "Valid test user credentials are available",
                "User account is not locked"
            ],
            'data_entry': [
                "User has permission to create records",
                "Required reference data exists (dropdowns, lookups)"
            ],
            'data_display': [
                "Test data exists in the system",
                "User has view permissions"
            ],
            'data_modification': [
                "Target record exists in the system",
                "User has edit permissions"
            ],
            'data_deletion': [
                "Target record exists in the system",
                "User has delete permissions"
            ],
            'export': [
                "Exportable data exists in the system",
                "User has export permissions"
            ],
            'import': [
                "Valid import file is prepared",
                "User has import permissions"
            ],
            'search': [
                "Searchable data exists in the system"
            ],
            'notification': [
                "Notification settings are configured",
                "Recipient contact information is valid"
            ],
            'scheduling': [
                "Available time slots exist",
                "Calendar/schedule is accessible"
            ],
            'validation': [
                "Validation service is accessible",
                "Test data for validation is prepared"
            ],
            'integration': [
                "External system is accessible",
                "Integration credentials are configured"
            ]
        }

        prereqs.extend(feature_prereqs.get(feature_type, []))

        return prereqs

    def _generate_notes(
        self,
        story: dict,
        feature_type: str,
        test_type: str
    ) -> str:
        """
        PURPOSE:
            Generate notes/considerations for a test case.

        PARAMETERS:
            story (dict): The user story
            feature_type (str): Type of feature
            test_type (str): Type of test

        RETURNS:
            str: Notes string

        WHY THIS APPROACH:
            Notes capture important context that doesn't fit elsewhere:
            edge cases to watch, known issues, environment requirements.
        """
        notes_parts = []

        # Check for quality flags from the story
        flags = story.get('flags', [])
        if 'priority_inferred' in flags:
            notes_parts.append("Priority was auto-assigned")
        if 'vague_requirement' in flags:
            notes_parts.append("Source requirement may need clarification")

        # Feature-specific notes
        feature_notes = {
            'authentication': "Verify across different browsers/devices",
            'data_entry': "Test with both minimum and maximum field lengths",
            'export': "Verify file opens correctly in target application",
            'import': "Have rollback plan for failed imports",
            'search': "Performance may vary with large datasets",
            'integration': "External system availability may affect results",
            'scheduling': "Consider time zone implications"
        }

        if feature_type in feature_notes:
            notes_parts.append(feature_notes[feature_type])

        return '; '.join(notes_parts) if notes_parts else ""

    def _estimate_time(self, step_count: int, test_type: str) -> str:
        """
        PURPOSE:
            Estimate test execution time based on steps and complexity.

        PARAMETERS:
            step_count (int): Number of test steps
            test_type (str): Type of test

        RETURNS:
            str: Time estimate string (e.g., "5-7 min")

        WHY THIS APPROACH:
            Realistic time estimates help QA planning. We base estimates
            on step count and test complexity. Happy path is typically
            faster; negative tests may require setup.
        """
        # Base time per step (in minutes)
        # WHY: Assume 1-2 minutes per step for manual testing
        base_minutes = step_count * 1.5

        # Adjust for test type
        # WHY: Some test types require more setup or verification
        multipliers = {
            'happy_path': 1.0,
            'negative': 1.2,      # Extra setup for failure scenarios
            'edge_case': 1.3,    # May need special data preparation
            'boundary': 1.1       # Straightforward but needs precision
        }

        multiplier = multipliers.get(test_type, 1.0)
        estimated = base_minutes * multiplier

        # Convert to time ranges
        if estimated < 3:
            return "2-3 min"
        elif estimated < 6:
            return "5-7 min"
        elif estimated < 10:
            return "8-10 min"
        elif estimated < 15:
            return "10-15 min"
        else:
            return "15-20 min"

    def _clean_title(self, title: str) -> str:
        """
        PURPOSE:
            Clean a story title for use in test case title.

        PARAMETERS:
            title (str): Raw title string

        RETURNS:
            str: Cleaned title suitable for test case

        WHY THIS APPROACH:
            Titles should be concise but descriptive. We remove
            filler words and truncate if too long.
        """
        # Remove common filler phrases
        title = re.sub(r'^(?:ability to|able to)\s+', '', title, flags=re.IGNORECASE)
        title = re.sub(r'^(?:users? can|users? should)\s+', '', title, flags=re.IGNORECASE)

        # Truncate if too long (keep first 60 chars)
        if len(title) > 60:
            title = title[:57] + "..."

        # Capitalize first letter
        if title:
            title = title[0].upper() + title[1:]

        return title

    def _extract_data_subject(self, capability: str) -> str:
        """
        PURPOSE:
            Extract the main data subject/entity from a capability.
            E.g., "create patient records" → "patient"

        PARAMETERS:
            capability (str): The capability string

        RETURNS:
            str: The data subject or "record" as fallback

        WHY THIS APPROACH:
            Having the specific entity makes test steps more readable.
            "Navigate to patient entry" vs "Navigate to the entry form"
        """
        # Common entity patterns
        entities = [
            'patient', 'user', 'account', 'appointment', 'report',
            'record', 'order', 'invoice', 'claim', 'case', 'ticket',
            'document', 'file', 'message', 'notification', 'task',
            'project', 'contact', 'customer', 'product', 'service'
        ]

        capability_lower = capability.lower()
        for entity in entities:
            if entity in capability_lower:
                return entity

        return "record"

    def get_stats(self) -> dict:
        """
        PURPOSE:
            Return statistics about generated test cases.

        RETURNS:
            dict: Statistics dictionary

        WHY THIS APPROACH:
            Statistics help track coverage and understand the
            balance between different test types.
        """
        return self.stats.copy()

    def reset_counters(self):
        """
        PURPOSE:
            Reset test ID counters for a new generation run.
            Call this when starting fresh on a new set of stories.

        WHY THIS APPROACH:
            Allows reuse of the generator while starting with
            fresh numbering for a new project or phase.
        """
        self.test_counter = {}
        self.stats = {
            'total_tests': 0,
            'happy_path_tests': 0,
            'negative_tests': 0,
            'edge_case_tests': 0,
            'boundary_tests': 0,
            'stories_processed': 0
        }


# ============================================================================
# STANDALONE TEST
# ============================================================================
# Run this file directly to test with sample data:
#     python generators/uat_generator.py
# ============================================================================

if __name__ == "__main__":
    # Create a sample user story for testing
    sample_stories = [
        {
            'generated_id': 'US-001',
            'title': 'Login with valid credentials',
            'user_story': 'As a user, I want to login with my credentials, so that I can access the system.',
            'capability': 'login with my credentials',
            'benefit': 'I can access the system',
            'role': 'user',
            'priority': 'High',
            'category': 'Authentication',
            'acceptance_criteria': [
                'User can enter username and password',
                'Successful login redirects to dashboard',
                'Session expires after 30 minutes of inactivity'
            ],
            'flags': []
        },
        {
            'generated_id': 'US-002',
            'title': 'Export dashboard data to Excel',
            'user_story': 'As an analyst, I want to export dashboard data to Excel, so that I can analyze and share data externally.',
            'capability': 'export dashboard data to Excel',
            'benefit': 'I can analyze and share data externally',
            'role': 'analyst',
            'priority': 'Medium',
            'category': 'Reporting',
            'acceptance_criteria': [
                'Export button is visible on dashboard',
                'Excel file downloads within 10 seconds',
                'All visible columns are included in export'
            ],
            'flags': ['priority_inferred']
        }
    ]

    # Create generator with sample configuration
    generator = UATGenerator(
        test_id_prefix="TEST",
        category_abbreviations={
            "Authentication": "AUTH",
            "Reporting": "RPT"
        }
    )

    # Generate test cases
    test_cases = generator.generate(sample_stories)

    # Print results
    print("=" * 70)
    print("UAT GENERATOR TEST OUTPUT")
    print("=" * 70)
    print()

    for tc in test_cases[:5]:  # Show first 5
        print(f"**{tc['test_id']}** - {tc['title']}")
        print(f"  Type: {tc['test_type']} | MoSCoW: {tc['moscow']} | Est: {tc['est_time']}")
        print(f"  Prerequisites:")
        for prereq in tc['prerequisites'][:2]:
            print(f"    - {prereq}")
        print(f"  Steps: {len(tc['test_steps'])} steps")
        print(f"  Expected Results: {len(tc['expected_results'])} results")
        if tc['notes']:
            print(f"  Notes: {tc['notes']}")
        print()

    # Print stats
    stats = generator.get_stats()
    print("=" * 70)
    print("STATISTICS")
    print("=" * 70)
    print(f"Stories Processed: {stats['stories_processed']}")
    print(f"Total Tests Generated: {stats['total_tests']}")
    print(f"  - Happy Path: {stats['happy_path_tests']}")
    print(f"  - Negative: {stats['negative_tests']}")
    print(f"  - Edge Cases: {stats['edge_case_tests']}")
    print(f"  - Boundary: {stats['boundary_tests']}")
