# generators/traceability_generator.py
# ============================================================================
# PURPOSE: Generate Requirements Traceability Matrix (RTM)
#
# A Requirements Traceability Matrix maps the chain from source requirements
# through user stories to test cases, ensuring complete coverage and
# identifying gaps.
#
# AVIATION ANALOGY:
#     Like the Master Minimum Equipment List (MMEL) that traces each aircraft
#     system to its maintenance requirements, inspection procedures, and
#     airworthiness directives. Every requirement has a clear chain of
#     accountability showing what tests verify it.
#
# R EQUIVALENT:
#     Like creating a join table across multiple data frames:
#     requirements %>%
#       left_join(stories, by = "requirement_id") %>%
#       left_join(tests, by = "story_id") %>%
#       group_by(requirement_id) %>%
#       summarize(test_coverage = n())
#
# USAGE:
#     from generators.traceability_generator import generate_traceability_matrix
#
#     rtm = generate_traceability_matrix(
#         requirements=requirements,
#         stories=stories,
#         test_cases=test_cases
#     )
#     print(f"Coverage: {rtm['summary']['full_coverage_pct']}%")
#
# ============================================================================

import re
from typing import Optional
from datetime import datetime


class TraceabilityGenerator:
    """
    PURPOSE:
        Build a Requirements Traceability Matrix (RTM) that maps source
        requirements through user stories to test cases.

    R EQUIVALENT:
        Like an R6 class that builds traceability relationships.

    WHY TRACEABILITY:
        - Ensures every requirement has test coverage
        - Identifies gaps in testing
        - Required for regulatory compliance (Part 11, HIPAA, SOC 2)
        - Supports impact analysis when requirements change
        - Proves to auditors that all requirements are verified

    USAGE:
        generator = TraceabilityGenerator()
        rtm = generator.generate(requirements, stories, test_cases)

    OUTPUT:
        {
            'matrix': [...],        # List of traceability rows
            'summary': {...},       # Coverage statistics
            'gaps': [...],          # Identified coverage gaps
            'generated_at': '...'   # Timestamp
        }
    """

    # Compliance framework identifiers found in test IDs
    COMPLIANCE_FRAMEWORKS = {
        'P11': 'Part11',
        'HIPAA': 'HIPAA',
        'SOC2': 'SOC2'
    }

    def __init__(self) -> None:
        """
        PURPOSE:
            Initialize the traceability generator.
        """
        # Statistics tracking
        self.stats = {
            'requirements_count': 0,
            'stories_count': 0,
            'test_cases_count': 0,
            'full_coverage': 0,
            'partial_coverage': 0,
            'no_coverage': 0
        }

        # Store generated matrix
        self.matrix: list[dict] = []
        self.gaps: list[dict] = []

    def generate(
        self,
        requirements: list[dict],
        stories: list[dict],
        test_cases: list[dict]
    ) -> dict:
        """
        PURPOSE:
            Generate the Requirements Traceability Matrix.

        PARAMETERS:
            requirements (list[dict]): Original requirements from parser
            stories (list[dict]): User stories from UserStoryGenerator
            test_cases (list[dict]): Test cases from UATGenerator and compliance generators

        RETURNS:
            dict: Complete RTM with matrix, summary, and gaps

        R EQUIVALENT:
            Like a function that builds a comprehensive join result with
            grouping and summarization.

        WHY THIS APPROACH:
            We build the matrix by:
            1. Index stories by their source requirement
            2. Index test cases by their source story
            3. Walk through requirements, finding linked stories and tests
            4. Calculate coverage status for each requirement
            5. Identify gaps
        """
        self.matrix = []
        self.gaps = []

        # Reset stats
        self.stats = {
            'requirements_count': len(requirements),
            'stories_count': len(stories),
            'test_cases_count': len(test_cases),
            'full_coverage': 0,
            'partial_coverage': 0,
            'no_coverage': 0,
            'compliance_coverage': {
                'Part11': {'requirements': 0, 'tests': 0},
                'HIPAA': {'requirements': 0, 'tests': 0},
                'SOC2': {'requirements': 0, 'tests': 0}
            }
        }

        # ====================================================================
        # STEP 1: Build lookup indexes
        # ====================================================================
        # WHY: Fast lookups instead of O(n^2) nested loops

        # Map: requirement_id -> list of stories
        stories_by_req = self._index_stories_by_requirement(stories)

        # Map: story_id -> list of test cases
        tests_by_story = self._index_tests_by_story(test_cases)

        # ====================================================================
        # STEP 2: Build traceability rows
        # ====================================================================

        for req in requirements:
            # Ensure requirement has an ID (use row_number if not present)
            req_id = req.get('requirement_id')
            if not req_id:
                row_num = req.get('row_number', 0)
                req_id = f"REQ-ROW{row_num}"
                req['requirement_id'] = req_id

            row = self._build_traceability_row(
                requirement=req,
                stories_by_req=stories_by_req,
                tests_by_story=tests_by_story,
                all_test_cases=test_cases
            )
            self.matrix.append(row)

            # Update coverage stats
            if row['coverage_status'] == 'Full':
                self.stats['full_coverage'] += 1
            elif row['coverage_status'] == 'Partial':
                self.stats['partial_coverage'] += 1
            else:
                self.stats['no_coverage'] += 1

            # Track gaps
            if row['gaps']:
                self.gaps.append({
                    'requirement_id': row['requirement_id'],
                    'requirement_text': row['requirement_text'],
                    'gaps': row['gaps']
                })

        # ====================================================================
        # STEP 3: Calculate compliance coverage
        # ====================================================================
        self._calculate_compliance_coverage(test_cases)

        # ====================================================================
        # STEP 4: Build summary
        # ====================================================================
        summary = self._build_summary()

        return {
            'matrix': self.matrix,
            'summary': summary,
            'gaps': self.gaps,
            'generated_at': datetime.now().isoformat()
        }

    def _index_stories_by_requirement(
        self,
        stories: list[dict]
    ) -> dict[str, list[dict]]:
        """
        PURPOSE:
            Create a lookup index mapping requirement IDs to their stories.

        PARAMETERS:
            stories (list[dict]): User stories

        RETURNS:
            dict: requirement_id -> list of stories

        WHY THIS APPROACH:
            Stories have a source_requirement field that links back to the
            original requirement. We index by this for O(1) lookups.

            For requirements without explicit IDs, we use row_number to create
            synthetic IDs like REQ-ROW2, REQ-ROW3, etc.
        """
        index = {}

        for story in stories:
            # Stories link to requirements via source_requirement
            source = story.get('source_requirement', {})
            req_id = source.get('requirement_id', '')

            # If no requirement_id, try using row_number to create synthetic ID
            if not req_id:
                row_num = source.get('row_number', 0)
                if row_num:
                    req_id = f"REQ-ROW{row_num}"

            # Also try generated_id which sometimes holds the source
            if not req_id:
                req_id = story.get('generated_id', '')

            # Also check if the story ID itself references a requirement
            if not req_id:
                story_id = story.get('generated_id', '')
                if story_id:
                    req_id = story_id

            if req_id:
                if req_id not in index:
                    index[req_id] = []
                index[req_id].append(story)

        return index

    def _index_tests_by_story(
        self,
        test_cases: list[dict]
    ) -> dict[str, list[dict]]:
        """
        PURPOSE:
            Create a lookup index mapping story IDs to their test cases.

        PARAMETERS:
            test_cases (list[dict]): Test cases

        RETURNS:
            dict: story_id -> list of test cases

        WHY THIS APPROACH:
            Test cases have source_story_id that links back to the story.
        """
        index = {}

        for test in test_cases:
            story_id = test.get('source_story_id', '')

            if story_id:
                if story_id not in index:
                    index[story_id] = []
                index[story_id].append(test)

        return index

    def _build_traceability_row(
        self,
        requirement: dict,
        stories_by_req: dict[str, list[dict]],
        tests_by_story: dict[str, list[dict]],
        all_test_cases: list[dict]
    ) -> dict:
        """
        PURPOSE:
            Build a single row of the traceability matrix.

        PARAMETERS:
            requirement (dict): The source requirement
            stories_by_req (dict): Stories indexed by requirement ID
            tests_by_story (dict): Tests indexed by story ID
            all_test_cases (list): All test cases for compliance lookup

        RETURNS:
            dict: Traceability row with coverage information
        """
        req_id = requirement.get('requirement_id', '')
        req_text = requirement.get('description', requirement.get('raw_text', ''))

        # Truncate long requirement text
        if len(req_text) > 200:
            req_text_display = req_text[:197] + '...'
        else:
            req_text_display = req_text

        # Find linked stories
        linked_stories = stories_by_req.get(req_id, [])

        # If no direct match, try partial matching
        if not linked_stories:
            linked_stories = self._find_stories_by_partial_match(
                req_id, stories_by_req
            )

        # Collect all test cases for this requirement
        all_tests = []
        story_info = []

        for story in linked_stories:
            story_id = story.get('generated_id', '')
            story_title = story.get('title', '')

            story_info.append({
                'story_id': story_id,
                'story_title': story_title
            })

            # Get tests for this story
            story_tests = tests_by_story.get(story_id, [])
            all_tests.extend(story_tests)

        # Also find compliance tests that might reference this requirement
        compliance_tests = self._find_compliance_tests_for_requirement(
            req_id, all_test_cases
        )
        all_tests.extend(compliance_tests)

        # Remove duplicates
        seen_ids = set()
        unique_tests = []
        for test in all_tests:
            test_id = test.get('test_id', '')
            if test_id not in seen_ids:
                seen_ids.add(test_id)
                unique_tests.append(test)

        # Extract test case IDs
        test_case_ids = [t.get('test_id', '') for t in unique_tests]

        # Determine compliance coverage
        compliance_coverage = self._get_compliance_coverage(unique_tests)

        # Determine coverage status
        coverage_status, gaps = self._determine_coverage_status(
            has_stories=len(linked_stories) > 0,
            has_tests=len(unique_tests) > 0,
            compliance_coverage=compliance_coverage,
            requirement=requirement
        )

        # Build primary story info (first story if multiple)
        primary_story_id = story_info[0]['story_id'] if story_info else ''
        primary_story_title = story_info[0]['story_title'] if story_info else ''

        return {
            'requirement_id': req_id,
            'requirement_text': req_text_display,
            'requirement_text_full': req_text,
            'user_story_id': primary_story_id,
            'user_story_title': primary_story_title,
            'all_stories': story_info,
            'test_case_ids': test_case_ids,
            'test_case_count': len(unique_tests),
            'compliance_coverage': compliance_coverage,
            'coverage_status': coverage_status,
            'gaps': gaps
        }

    def _find_stories_by_partial_match(
        self,
        req_id: str,
        stories_by_req: dict[str, list[dict]]
    ) -> list[dict]:
        """
        PURPOSE:
            Find stories that might match a requirement by partial ID matching.

        WHY THIS APPROACH:
            Sometimes IDs don't match exactly due to formatting differences.
            For example, "REQ-001" vs "REQ001" or "REQ-1".
        """
        if not req_id:
            return []

        # Normalize the requirement ID for comparison
        req_normalized = re.sub(r'[-_\s]', '', req_id.upper())

        for stored_id, stories in stories_by_req.items():
            stored_normalized = re.sub(r'[-_\s]', '', stored_id.upper())
            if req_normalized == stored_normalized:
                return stories

        return []

    def _find_compliance_tests_for_requirement(
        self,
        req_id: str,
        all_test_cases: list[dict]
    ) -> list[dict]:
        """
        PURPOSE:
            Find compliance tests that reference a requirement.

        WHY THIS APPROACH:
            Compliance tests are linked via source_story_id which might
            be the requirement ID for direct compliance testing.
        """
        compliance_tests = []

        for test in all_test_cases:
            source = test.get('source_story_id', '')
            test_id = test.get('test_id', '')

            # Check if it's a compliance test
            is_compliance = any(
                fw in test_id
                for fw in self.COMPLIANCE_FRAMEWORKS.keys()
            )

            if is_compliance and source == req_id:
                compliance_tests.append(test)

        return compliance_tests

    def _get_compliance_coverage(self, tests: list[dict]) -> list[str]:
        """
        PURPOSE:
            Determine which compliance frameworks have test coverage.

        PARAMETERS:
            tests (list[dict]): Test cases to analyze

        RETURNS:
            list[str]: List of frameworks with coverage (e.g., ['Part11', 'HIPAA'])
        """
        frameworks_found = set()

        for test in tests:
            test_id = test.get('test_id', '')
            category = test.get('category', '')

            # Check test ID for framework indicators
            for code, name in self.COMPLIANCE_FRAMEWORKS.items():
                if code in test_id:
                    frameworks_found.add(name)

            # Also check category
            if 'Part 11' in category or 'Part11' in category:
                frameworks_found.add('Part11')
            elif 'HIPAA' in category:
                frameworks_found.add('HIPAA')
            elif 'SOC 2' in category or 'SOC2' in category:
                frameworks_found.add('SOC2')

        return sorted(list(frameworks_found))

    def _determine_coverage_status(
        self,
        has_stories: bool,
        has_tests: bool,
        compliance_coverage: list[str],
        requirement: dict
    ) -> tuple[str, list[str]]:
        """
        PURPOSE:
            Determine the coverage status and identify any gaps.

        PARAMETERS:
            has_stories (bool): Whether requirement has linked stories
            has_tests (bool): Whether requirement has test cases
            compliance_coverage (list[str]): Compliance frameworks with coverage
            requirement (dict): The requirement being analyzed

        RETURNS:
            tuple: (status, gaps) where status is Full/Partial/None
        """
        gaps = []

        if not has_stories:
            gaps.append("No user story generated")

        if not has_tests:
            gaps.append("No test cases")

        # Check if requirement seems to need compliance coverage
        req_text = requirement.get('description', '').lower()
        req_text += ' ' + requirement.get('raw_text', '').lower()

        # Check for compliance-relevant keywords
        needs_part11 = any(kw in req_text for kw in [
            'audit', 'signature', 'electronic', 'log', 'trail'
        ])
        needs_hipaa = any(kw in req_text for kw in [
            'patient', 'health', 'phi', 'hipaa', 'medical'
        ])
        needs_soc2 = any(kw in req_text for kw in [
            'security', 'encrypt', 'access control', 'availability'
        ])

        if needs_part11 and 'Part11' not in compliance_coverage:
            gaps.append("May need Part 11 compliance tests")
        if needs_hipaa and 'HIPAA' not in compliance_coverage:
            gaps.append("May need HIPAA compliance tests")
        if needs_soc2 and 'SOC2' not in compliance_coverage:
            gaps.append("May need SOC 2 compliance tests")

        # Determine status
        if not has_stories or not has_tests:
            return ('None', gaps)
        elif gaps:
            return ('Partial', gaps)
        else:
            return ('Full', gaps)

    def _calculate_compliance_coverage(self, test_cases: list[dict]) -> None:
        """
        PURPOSE:
            Calculate compliance coverage statistics.

        WHY THIS APPROACH:
            We count unique requirements covered by each compliance framework
            and total tests per framework.
        """
        for framework in self.stats['compliance_coverage'].keys():
            reqs_covered = set()
            test_count = 0

            for test in test_cases:
                test_id = test.get('test_id', '')
                category = test.get('category', '')
                source = test.get('source_story_id', '')

                # Check if this is a test for this framework
                is_framework_test = False

                if framework == 'Part11':
                    is_framework_test = 'P11' in test_id or 'Part 11' in category
                elif framework == 'HIPAA':
                    is_framework_test = 'HIPAA' in test_id or 'HIPAA' in category
                elif framework == 'SOC2':
                    is_framework_test = 'SOC2' in test_id or 'SOC 2' in category

                if is_framework_test:
                    test_count += 1
                    if source:
                        reqs_covered.add(source)

            self.stats['compliance_coverage'][framework] = {
                'requirements': len(reqs_covered),
                'tests': test_count
            }

    def _build_summary(self) -> dict:
        """
        PURPOSE:
            Build the summary statistics for the RTM.

        RETURNS:
            dict: Comprehensive summary statistics
        """
        total_reqs = self.stats['requirements_count']

        # Calculate percentages
        if total_reqs > 0:
            full_pct = round(self.stats['full_coverage'] / total_reqs * 100, 1)
            partial_pct = round(self.stats['partial_coverage'] / total_reqs * 100, 1)
            none_pct = round(self.stats['no_coverage'] / total_reqs * 100, 1)
        else:
            full_pct = partial_pct = none_pct = 0.0

        return {
            'total_requirements': total_reqs,
            'total_stories': self.stats['stories_count'],
            'total_test_cases': self.stats['test_cases_count'],
            'full_coverage_count': self.stats['full_coverage'],
            'full_coverage_pct': full_pct,
            'partial_coverage_count': self.stats['partial_coverage'],
            'partial_coverage_pct': partial_pct,
            'no_coverage_count': self.stats['no_coverage'],
            'no_coverage_pct': none_pct,
            'compliance_coverage': self.stats['compliance_coverage'],
            'total_gaps': len(self.gaps)
        }

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_traceability_matrix(
    requirements: list[dict],
    stories: list[dict],
    test_cases: list[dict]
) -> dict:
    """
    PURPOSE:
        Convenience function to generate a Requirements Traceability Matrix.

    PARAMETERS:
        requirements (list[dict]): Original requirements from parser
        stories (list[dict]): User stories from UserStoryGenerator
        test_cases (list[dict]): Test cases (UAT + compliance)

    RETURNS:
        dict: Complete RTM with matrix, summary, and gaps

    USAGE:
        rtm = generate_traceability_matrix(requirements, stories, test_cases)
        print(f"Full coverage: {rtm['summary']['full_coverage_pct']}%")
        for row in rtm['matrix']:
            print(f"{row['requirement_id']}: {row['coverage_status']}")
    """
    generator = TraceabilityGenerator()
    return generator.generate(requirements, stories, test_cases)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 70)
    print("TRACEABILITY GENERATOR TEST")
    print("=" * 70)

    # Sample data to test
    sample_requirements = [
        {
            'requirement_id': 'REQ-001',
            'description': 'System shall allow users to login with email and password'
        },
        {
            'requirement_id': 'REQ-002',
            'description': 'System shall store patient health records securely'
        },
        {
            'requirement_id': 'REQ-003',
            'description': 'System shall generate monthly reports'
        }
    ]

    sample_stories = [
        {
            'generated_id': 'REQ-001',
            'title': 'User login with email',
            'source_requirement': {'requirement_id': 'REQ-001'}
        },
        {
            'generated_id': 'REQ-002',
            'title': 'Store patient records',
            'source_requirement': {'requirement_id': 'REQ-002'}
        },
        {
            'generated_id': 'REQ-003',
            'title': 'Generate monthly reports',
            'source_requirement': {'requirement_id': 'REQ-003'}
        }
    ]

    sample_tests = [
        {'test_id': 'TEST-AUTH-001', 'source_story_id': 'REQ-001', 'category': 'Authentication'},
        {'test_id': 'TEST-AUTH-002', 'source_story_id': 'REQ-001', 'category': 'Authentication'},
        {'test_id': 'TEST-P11-AUDI-001', 'source_story_id': 'REQ-002', 'category': 'Part 11 - Audit'},
        {'test_id': 'TEST-HIPAA-ACC-001', 'source_story_id': 'REQ-002', 'category': 'HIPAA - Access'},
        {'test_id': 'TEST-RPT-001', 'source_story_id': 'REQ-003', 'category': 'Reporting'}
    ]

    print(f"\nInput:")
    print(f"  Requirements: {len(sample_requirements)}")
    print(f"  Stories: {len(sample_stories)}")
    print(f"  Test Cases: {len(sample_tests)}")

    rtm = generate_traceability_matrix(
        sample_requirements,
        sample_stories,
        sample_tests
    )

    print(f"\n--- Summary ---")
    summary = rtm['summary']
    print(f"  Total requirements: {summary['total_requirements']}")
    print(f"  Total stories: {summary['total_stories']}")
    print(f"  Total test cases: {summary['total_test_cases']}")
    print(f"  Full coverage: {summary['full_coverage_count']} ({summary['full_coverage_pct']}%)")
    print(f"  Partial coverage: {summary['partial_coverage_count']} ({summary['partial_coverage_pct']}%)")
    print(f"  No coverage: {summary['no_coverage_count']} ({summary['no_coverage_pct']}%)")

    print(f"\n--- Compliance Coverage ---")
    for framework, stats in summary['compliance_coverage'].items():
        print(f"  {framework}: {stats['requirements']} reqs, {stats['tests']} tests")

    print(f"\n--- Traceability Matrix ---")
    for row in rtm['matrix']:
        print(f"\n  {row['requirement_id']}:")
        print(f"    Requirement: {row['requirement_text'][:50]}...")
        print(f"    Story: {row['user_story_id']} - {row['user_story_title'][:30]}...")
        print(f"    Tests: {row['test_case_count']} ({', '.join(row['test_case_ids'][:3])}...)")
        print(f"    Compliance: {', '.join(row['compliance_coverage']) or 'None'}")
        print(f"    Status: {row['coverage_status']}")
        if row['gaps']:
            print(f"    Gaps: {', '.join(row['gaps'])}")

    print(f"\n--- Gaps ---")
    if rtm['gaps']:
        for gap in rtm['gaps']:
            print(f"  {gap['requirement_id']}: {', '.join(gap['gaps'])}")
    else:
        print("  No gaps identified")

    print("\n" + "=" * 70)
    print("TEST COMPLETE")
