# formatters/notion_formatter.py
# ============================================================================
# PURPOSE: Export user stories and UAT test cases to Notion as a markdown page
#
# This creates a single well-formatted page in Notion containing all the
# requirements and test cases. Much simpler than databases - just a clean
# document that stakeholders can read and comment on.
#
# AVIATION ANALOGY:
#     This is like creating a flight briefing document. All the critical
#     information (weather, NOTAMs, fuel, route) in one organized page that
#     the crew can review together. Simple, readable, complete.
#
# R EQUIVALENT:
#     Like using httr to POST markdown content to Notion's API:
#     response <- POST(url, body = list(content = markdown_text))
#
# REQUIREMENTS:
#     pip install notion-client
#     Environment variable: NOTION_API_KEY
#
# ============================================================================

import os
import re
from typing import Optional
from datetime import datetime

# notion-client is the official Python SDK for Notion API
# R EQUIVALENT: Like using httr with Notion's REST API, but with nice wrappers
try:
    from notion_client import Client
    from notion_client.errors import APIResponseError
    NOTION_AVAILABLE = True
except ImportError:
    NOTION_AVAILABLE = False
    Client = None
    APIResponseError = Exception


class NotionFormatter:
    """
    PURPOSE:
        Export user stories and UAT test cases to Notion as a formatted page.
        Creates a single subpage with all content in readable markdown format.

    R EQUIVALENT:
        Similar to creating functions that wrap httr calls to Notion API.
        In R you'd manage tokens and build JSON payloads manually.

    WHY A CLASS:
        - Holds API client and configuration state
        - Provides clean interface for the export workflow
        - Tracks statistics and errors

    USAGE:
        formatter = NotionFormatter(project_name="HealthFlow", prefix="HF")
        result = formatter.export(stories, test_cases)
        # or use convenience function:
        result = export_to_notion(stories, test_cases, project_name="HealthFlow")

    AUTHENTICATION:
        Set environment variable NOTION_API_KEY with your integration token.
        Get token from: https://www.notion.so/my-integrations
        Then share a Notion page with your integration.
    """

    def __init__(
        self,
        project_name: str,
        prefix: str = "REQ",
        parent_page_id: Optional[str] = None,
        auto_create: bool = False,
        source_filename: str = ""
    ) -> None:
        """
        PURPOSE:
            Initialize the Notion formatter with project configuration.

        PARAMETERS:
            project_name (str): Name of the project (used for search and titles)
                               Example: "HealthFlow Patient Portal"
            prefix (str): Test ID prefix, also used for search
                         Example: "HF" for HealthFlow
            parent_page_id (str, optional): Notion page ID to use as parent.
                                           If provided, skips search.
                                           If None, searches shared pages.
            auto_create (bool): If True, skip confirmation prompts (for automation)
                               Default: False (interactive mode)
            source_filename (str): Original input filename for reference

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            We store configuration for use across multiple operations.
            The parent_page_id allows direct targeting of a specific page.
        """
        if not NOTION_AVAILABLE:
            raise ImportError(
                "notion-client is required for Notion export. "
                "Install with: pip install notion-client"
            )

        # Get API key from environment
        self.api_key = os.environ.get('NOTION_API_KEY')
        if not self.api_key:
            raise ValueError(
                "NOTION_API_KEY environment variable not set. "
                "Get your integration token from: https://www.notion.so/my-integrations"
            )

        # Initialize the Notion client
        self.client = Client(auth=self.api_key)

        # Store configuration
        self.project_name = project_name
        self.prefix = prefix
        self.parent_page_id = parent_page_id
        self.auto_create = auto_create
        self.source_filename = source_filename

        # Will hold the created page URL
        self.created_page_url: Optional[str] = None

        # Statistics tracking
        self.stats = {
            'stories_added': 0,
            'tests_added': 0,
            'flagged_items': 0,
            'errors': []
        }

    # ========================================================================
    # MAIN EXPORT ENTRY POINT
    # ========================================================================

    def export(
        self,
        stories: list[dict],
        test_cases: list[dict],
        traceability_matrix: dict = None
    ) -> dict:
        """
        PURPOSE:
            Main export function - finds parent page and creates content subpage.

        PARAMETERS:
            stories (list[dict]): User story dictionaries from UserStoryGenerator
            test_cases (list[dict]): Test case dictionaries from UATGenerator
            traceability_matrix (dict, optional): RTM from TraceabilityGenerator.
                If provided, adds a Traceability Matrix section.

        RETURNS:
            dict: Results including URL, counts, and any errors

        WHY THIS APPROACH:
            This orchestrates the full export workflow:
            1. Find or verify parent page
            2. Check for existing subpage
            3. Create/update content page
            4. Return results
        """
        print("\n" + "=" * 60)
        print("  Notion Export")
        print("=" * 60)

        results = {
            'success': False,
            'page_url': None,
            'stories_added': 0,
            'tests_added': 0,
            'errors': []
        }

        try:
            # ==============================================================
            # STEP 1: Find parent page
            # ==============================================================
            parent_id = None

            if self.parent_page_id:
                # Use provided parent page ID directly
                print(f"\n  Using provided parent page ID...")
                parent_id = self._verify_page_access(self.parent_page_id)
                if not parent_id:
                    results['errors'].append(
                        f"Cannot access page {self.parent_page_id}. "
                        "Make sure the page is shared with your integration."
                    )
                    return results

            else:
                # Search for shared pages matching project/prefix
                print(f"\n  Searching for shared pages matching '{self.project_name}'...")
                parent_id = self._find_parent_page()

                if not parent_id:
                    error_msg = (
                        f"No shared page found for '{self.project_name}' or '{self.prefix}'.\n"
                        "Please share a parent page with your Notion integration first:\n"
                        "  1. Open a Notion page where you want the export\n"
                        "  2. Click '...' menu → 'Add connections'\n"
                        "  3. Select your integration\n"
                        "  4. Run export again"
                    )
                    print(f"\n  ERROR: {error_msg}")
                    results['errors'].append(error_msg)
                    return results

            # ==============================================================
            # STEP 2: Check for existing subpage
            # ==============================================================
            subpage_title = f"{self.project_name} Requirements & UAT"
            print(f"\n  Checking for existing '{subpage_title}' page...")

            existing_page = self._find_existing_subpage(parent_id, subpage_title)

            if existing_page:
                # Handle existing page
                action = self._handle_existing_page(existing_page)

                if action == 'CANCEL':
                    results['errors'].append("Export cancelled by user")
                    return results
                elif action == 'UPDATE':
                    # Delete and recreate (Notion doesn't support full page content replacement easily)
                    print("  Archiving old page and creating updated version...")
                    self._archive_page(existing_page['id'])
                elif action == 'NEW_VERSION':
                    # Add timestamp to title
                    timestamp = datetime.now().strftime('%Y%m%d_%H%M')
                    subpage_title = f"{self.project_name} Requirements & UAT ({timestamp})"

            # ==============================================================
            # STEP 3: Build page content
            # ==============================================================
            print(f"\n  Building page content...")
            blocks = self._build_page_blocks(stories, test_cases, traceability_matrix)

            # ==============================================================
            # STEP 4: Create the page
            # ==============================================================
            print(f"\n  Creating page: '{subpage_title}'...")
            page = self._create_page(parent_id, subpage_title, blocks)

            self.created_page_url = page.get('url', '')
            self.stats['stories_added'] = len(stories)
            self.stats['tests_added'] = len(test_cases)

            # ==============================================================
            # STEP 5: Compile results
            # ==============================================================
            results['success'] = True
            results['page_url'] = self.created_page_url
            results['stories_added'] = self.stats['stories_added']
            results['tests_added'] = self.stats['tests_added']
            results['errors'] = self.stats['errors']

            print("\n" + "-" * 60)
            print("  Export Complete!")
            print("-" * 60)
            print(f"  User stories: {results['stories_added']}")
            print(f"  Test cases: {results['tests_added']}")
            print(f"\n  Page URL: {results['page_url']}")

        except APIResponseError as e:
            error_msg = f"Notion API error: {e.code} - {e.message}"
            results['errors'].append(error_msg)
            print(f"\n  ERROR: {error_msg}")

        except Exception as e:
            error_msg = f"Export failed: {str(e)}"
            results['errors'].append(error_msg)
            print(f"\n  ERROR: {error_msg}")

        return results

    # ========================================================================
    # PAGE FINDING & VERIFICATION
    # ========================================================================

    def _verify_page_access(self, page_id: str) -> Optional[str]:
        """
        PURPOSE:
            Verify we can access a page by its ID.

        PARAMETERS:
            page_id (str): Notion page ID

        RETURNS:
            str or None: Page ID if accessible, None otherwise

        WHY THIS APPROACH:
            Before using a page ID, we verify the integration has access.
        """
        try:
            # Clean the page ID (remove dashes if present)
            clean_id = page_id.replace('-', '')

            # Try to retrieve the page
            page = self.client.pages.retrieve(page_id=clean_id)
            print(f"  Found page: {self._extract_page_title(page)}")
            return page['id']

        except APIResponseError as e:
            if e.code == 'object_not_found':
                return None
            raise

    def _find_parent_page(self) -> Optional[str]:
        """
        PURPOSE:
            Search shared pages for one matching the project name or prefix.

        RETURNS:
            str or None: Page ID if found, None otherwise

        WHY THIS APPROACH:
            We search for pages the integration has access to that match
            our project. This finds pages that have been shared with us.
        """
        search_terms = [
            self.project_name,
            self.prefix,
            f"{self.project_name} Requirements",
            f"{self.prefix} Requirements"
        ]

        matches = []
        seen_ids = set()

        for term in search_terms:
            try:
                response = self.client.search(
                    query=term,
                    filter={"property": "object", "value": "page"},
                    page_size=10
                )

                for result in response.get('results', []):
                    page_id = result['id']
                    if page_id in seen_ids:
                        continue
                    seen_ids.add(page_id)

                    title = self._extract_page_title(result)
                    title_lower = title.lower()
                    project_lower = self.project_name.lower()
                    prefix_lower = self.prefix.lower()

                    # Check if title is relevant
                    if (project_lower in title_lower or
                        prefix_lower in title_lower):
                        matches.append({
                            'id': page_id,
                            'title': title,
                            'url': result.get('url', '')
                        })

            except APIResponseError:
                continue

        if not matches:
            return None

        if len(matches) == 1:
            print(f"  Found: {matches[0]['title']}")
            return matches[0]['id']

        # Multiple matches - let user choose
        return self._select_from_matches(matches)

    def _select_from_matches(self, matches: list[dict]) -> Optional[str]:
        """
        PURPOSE:
            Let user select from multiple matching pages.

        PARAMETERS:
            matches (list[dict]): List of matching pages

        RETURNS:
            str or None: Selected page ID or None if cancelled
        """
        print(f"\n  Found {len(matches)} matching pages:")
        print("-" * 50)

        for i, page in enumerate(matches, 1):
            print(f"  [{i}] {page['title']}")
            print(f"      {page['url']}")

        print(f"  [0] Cancel")
        print("-" * 50)

        if self.auto_create:
            print("  Auto-mode: Using first match")
            return matches[0]['id']

        while True:
            try:
                choice = input("  Select parent page: ").strip()
                if choice == '0':
                    return None
                choice_num = int(choice)
                if 1 <= choice_num <= len(matches):
                    return matches[choice_num - 1]['id']
                print("  Invalid choice. Try again.")
            except ValueError:
                print("  Please enter a number.")

    def _find_existing_subpage(self, parent_id: str, title: str) -> Optional[dict]:
        """
        PURPOSE:
            Check if a subpage with the given title already exists.

        PARAMETERS:
            parent_id (str): Parent page ID
            title (str): Title to search for

        RETURNS:
            dict or None: Existing page info if found

        WHY THIS APPROACH:
            Before creating, we check if we already have a page with
            this title to avoid duplicates.
        """
        try:
            # Search for pages with similar title
            response = self.client.search(
                query=title,
                filter={"property": "object", "value": "page"},
                page_size=20
            )

            for result in response.get('results', []):
                page_title = self._extract_page_title(result)

                # Check if title matches and parent is our page
                if title.lower() in page_title.lower():
                    page_parent = result.get('parent', {})
                    if page_parent.get('page_id', '').replace('-', '') == parent_id.replace('-', ''):
                        return {
                            'id': result['id'],
                            'title': page_title,
                            'url': result.get('url', ''),
                            'last_edited': result.get('last_edited_time', '')
                        }

        except APIResponseError:
            pass

        return None

    def _handle_existing_page(self, existing: dict) -> str:
        """
        PURPOSE:
            Handle case where subpage already exists.

        PARAMETERS:
            existing (dict): Existing page info

        RETURNS:
            str: Action to take ('UPDATE', 'NEW_VERSION', or 'CANCEL')
        """
        print(f"\n  Found existing page: {existing['title']}")
        print(f"  URL: {existing['url']}")
        if existing['last_edited']:
            print(f"  Last edited: {existing['last_edited'][:10]}")

        if self.auto_create:
            print("  Auto-mode: Updating existing page")
            return 'UPDATE'

        print("\n  Options:")
        print("  [1] Update existing page (archive old, create new)")
        print("  [2] Create new version (with timestamp)")
        print("  [0] Cancel")

        while True:
            choice = input("  Select option: ").strip()
            if choice == '0':
                return 'CANCEL'
            if choice == '1':
                return 'UPDATE'
            if choice == '2':
                return 'NEW_VERSION'
            print("  Invalid choice. Try again.")

    def _archive_page(self, page_id: str) -> None:
        """
        PURPOSE:
            Archive (soft delete) a page.

        PARAMETERS:
            page_id (str): Page ID to archive
        """
        try:
            self.client.pages.update(
                page_id=page_id,
                archived=True
            )
        except APIResponseError:
            pass  # Non-critical if archive fails

    # ========================================================================
    # PAGE CONTENT BUILDING
    # ========================================================================

    def _build_page_blocks(
        self,
        stories: list[dict],
        test_cases: list[dict],
        traceability_matrix: dict = None
    ) -> list[dict]:
        """
        PURPOSE:
            Build Notion block content for the page.

        PARAMETERS:
            stories (list[dict]): User stories
            test_cases (list[dict]): Test cases
            traceability_matrix (dict, optional): RTM from TraceabilityGenerator

        RETURNS:
            list[dict]: Notion block objects

        WHY THIS APPROACH:
            Notion pages are made of blocks. We build each section
            as a series of blocks that will render as formatted content.
        """
        blocks = []

        # ==================================================================
        # SUMMARY SECTION
        # ==================================================================
        blocks.append(self._heading_1("Summary"))

        # Count flagged items
        flagged_count = sum(1 for s in stories if s.get('flags'))
        self.stats['flagged_items'] = flagged_count

        summary_items = [
            f"Total user stories: {len(stories)}",
            f"Total test cases: {len(test_cases)}",
            f"Flagged items: {flagged_count}",
            f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}",
        ]
        if self.source_filename:
            summary_items.append(f"Source: {self.source_filename}")

        for item in summary_items:
            blocks.append(self._bulleted_list(item))

        blocks.append(self._divider())

        # ==================================================================
        # USER STORIES SECTION
        # ==================================================================
        blocks.append(self._heading_1("User Stories"))

        for story in stories:
            # Story heading
            story_id = story.get('generated_id', 'UNKNOWN')
            title = story.get('title', story_id)
            blocks.append(self._heading_2(f"{story_id}: {title}"))

            # User story text
            user_story = story.get('user_story', '')
            if user_story:
                blocks.append(self._callout(user_story, "📝"))

            # Priority and category
            priority = story.get('priority', 'Medium')
            category = story.get('category', 'General')
            blocks.append(self._paragraph(f"**Priority:** {priority} | **Category:** {category}"))

            # Description
            description = story.get('description', '')
            if description:
                blocks.append(self._paragraph(description))

            # Acceptance criteria
            criteria = story.get('acceptance_criteria', [])
            if criteria:
                blocks.append(self._paragraph("**Acceptance Criteria:**"))
                for criterion in criteria:
                    blocks.append(self._to_do(criterion))

            # Flags
            flags = story.get('flags', [])
            if flags:
                flag_text = ", ".join(flags)
                blocks.append(self._paragraph(f"⚠️ **Flags:** {flag_text}"))

            blocks.append(self._divider())

        # ==================================================================
        # UAT TEST CASES SECTION
        # ==================================================================
        blocks.append(self._heading_1("UAT Test Cases"))

        # Group test cases by category
        tests_by_category = {}
        for test in test_cases:
            cat = test.get('category', 'General')
            if cat not in tests_by_category:
                tests_by_category[cat] = []
            tests_by_category[cat].append(test)

        for category, tests in tests_by_category.items():
            blocks.append(self._heading_2(category))

            for test in tests:
                test_id = test.get('test_id', 'UNKNOWN')
                title = test.get('title', test_id)
                test_type = test.get('test_type', 'happy_path').replace('_', ' ').title()
                moscow = test.get('moscow', 'Should Have')

                # Test case toggle (collapsible)
                toggle_children = []

                # Prerequisites
                prereqs = test.get('prerequisites', [])
                if prereqs:
                    toggle_children.append(self._paragraph("**Prerequisites:**"))
                    for prereq in prereqs:
                        toggle_children.append(self._bulleted_list(prereq))

                # Test steps
                steps = test.get('test_steps', [])
                if steps:
                    toggle_children.append(self._paragraph("**Test Steps:**"))
                    for step in steps:
                        toggle_children.append(self._numbered_list(step))

                # Expected results
                results = test.get('expected_results', [])
                if results:
                    toggle_children.append(self._paragraph("**Expected Results:**"))
                    for result in results:
                        toggle_children.append(self._bulleted_list(result))

                # Notes
                notes = test.get('notes', '')
                if notes:
                    toggle_children.append(self._paragraph(f"**Notes:** {notes}"))

                # Create toggle block
                toggle_title = f"{test_id} - {title} [{test_type}] ({moscow})"
                blocks.append(self._toggle(toggle_title, toggle_children))

        # ==================================================================
        # TRACEABILITY MATRIX SECTION (if provided)
        # ==================================================================
        if traceability_matrix:
            rtm_blocks = self._build_traceability_blocks(traceability_matrix)
            blocks.extend(rtm_blocks)

        # ==================================================================
        # FLAGGED ITEMS SECTION (if any)
        # ==================================================================
        flagged_stories = [s for s in stories if s.get('flags')]
        if flagged_stories:
            blocks.append(self._divider())
            blocks.append(self._heading_1("Flagged Items"))
            blocks.append(self._paragraph(
                "The following items have been flagged and may need review:"
            ))

            for story in flagged_stories:
                story_id = story.get('generated_id', 'UNKNOWN')
                title = story.get('title', story_id)
                flags = ", ".join(story.get('flags', []))
                blocks.append(self._bulleted_list(f"**{story_id}**: {title} — _{flags}_"))

        return blocks

    def _build_traceability_blocks(self, rtm: dict) -> list[dict]:
        """
        PURPOSE:
            Build Notion blocks for the Traceability Matrix section.

        PARAMETERS:
            rtm (dict): Traceability matrix from TraceabilityGenerator

        RETURNS:
            list[dict]: Notion block objects for RTM section

        WHY THIS APPROACH:
            Traceability matrices are essential for:
            - Regulatory compliance (Part 11, HIPAA, SOC 2)
            - Audit readiness
            - Gap analysis
            - Impact assessment when requirements change
        """
        blocks = []

        blocks.append(self._divider())
        blocks.append(self._heading_1("Traceability Matrix"))

        # ================================================================
        # COVERAGE SUMMARY
        # ================================================================
        summary = rtm.get('summary', {})

        blocks.append(self._heading_2("Coverage Summary"))

        total_reqs = summary.get('total_requirements', 0)
        total_tests = summary.get('total_test_cases', 0)
        full_count = summary.get('full_coverage_count', 0)
        full_pct = summary.get('full_coverage_pct', 0)
        partial_count = summary.get('partial_coverage_count', 0)
        partial_pct = summary.get('partial_coverage_pct', 0)
        none_count = summary.get('no_coverage_count', 0)
        none_pct = summary.get('no_coverage_pct', 0)

        # Summary callout
        summary_text = (
            f"Total Requirements: {total_reqs} | "
            f"Total Test Cases: {total_tests}"
        )
        blocks.append(self._callout(summary_text, "📊"))

        # Coverage breakdown
        blocks.append(self._bulleted_list(f"🟢 Full coverage: {full_count} requirements ({full_pct}%)"))
        blocks.append(self._bulleted_list(f"🟡 Partial coverage: {partial_count} requirements ({partial_pct}%)"))
        blocks.append(self._bulleted_list(f"🔴 No coverage: {none_count} requirements ({none_pct}%)"))

        # Compliance coverage
        compliance = summary.get('compliance_coverage', {})
        has_compliance = any(c.get('tests', 0) > 0 for c in compliance.values())

        if has_compliance:
            blocks.append(self._heading_3("Compliance Test Coverage"))
            for framework, stats in compliance.items():
                tests = stats.get('tests', 0)
                reqs = stats.get('requirements', 0)
                if tests > 0:
                    blocks.append(self._bulleted_list(f"{framework}: {tests} tests covering {reqs} requirements"))

        # ================================================================
        # DETAILED TRACEABILITY (in collapsible toggles)
        # ================================================================
        blocks.append(self._heading_2("Detailed Traceability"))

        matrix = rtm.get('matrix', [])

        # Group by coverage status for organization
        by_status = {'Full': [], 'Partial': [], 'None': []}
        for row in matrix:
            status = row.get('coverage_status', 'None')
            by_status.get(status, by_status['None']).append(row)

        # Status icons
        status_icons = {'Full': '🟢', 'Partial': '🟡', 'None': '🔴'}

        for status in ['Full', 'Partial', 'None']:
            rows = by_status[status]
            if not rows:
                continue

            icon = status_icons[status]
            blocks.append(self._heading_3(f"{icon} {status} Coverage ({len(rows)} requirements)"))

            for row in rows:
                req_id = row.get('requirement_id', 'UNKNOWN')
                req_text = row.get('requirement_text', '')
                if len(req_text) > 100:
                    req_text = req_text[:97] + '...'

                story_id = row.get('user_story_id', 'None')
                story_title = row.get('user_story_title', 'No story')
                if len(story_title) > 50:
                    story_title = story_title[:47] + '...'

                test_count = row.get('test_case_count', 0)
                test_ids = row.get('test_case_ids', [])
                compliance_coverage = row.get('compliance_coverage', [])
                gaps = row.get('gaps', [])

                # Build toggle content
                toggle_children = []

                toggle_children.append(self._paragraph(f"**Requirement:** {req_text}"))
                toggle_children.append(self._paragraph(f"**User Story:** {story_id} - {story_title}"))
                toggle_children.append(self._paragraph(f"**Test Cases:** {test_count}"))

                if test_ids:
                    # Show first 5 test IDs
                    display_ids = test_ids[:5]
                    if len(test_ids) > 5:
                        display_ids.append(f"...and {len(test_ids) - 5} more")
                    for tid in display_ids:
                        toggle_children.append(self._bulleted_list(tid))

                if compliance_coverage:
                    toggle_children.append(self._paragraph(
                        f"**Compliance Coverage:** {', '.join(compliance_coverage)}"
                    ))

                if gaps:
                    toggle_children.append(self._paragraph("**Gaps:**"))
                    for gap in gaps:
                        toggle_children.append(self._bulleted_list(f"⚠️ {gap}"))

                # Create toggle
                toggle_title = f"{req_id}: {req_text[:50]}..." if len(req_text) > 50 else f"{req_id}: {req_text}"
                blocks.append(self._toggle(toggle_title, toggle_children))

        # ================================================================
        # GAPS SUMMARY (if any)
        # ================================================================
        all_gaps = rtm.get('gaps', [])
        if all_gaps:
            blocks.append(self._heading_2("Identified Gaps"))
            blocks.append(self._callout(
                f"{len(all_gaps)} requirements have coverage gaps that may need attention.",
                "⚠️"
            ))

            for gap in all_gaps:
                req_id = gap.get('requirement_id', '')
                gap_list = gap.get('gaps', [])
                gap_text = f"**{req_id}:** {', '.join(gap_list)}"
                blocks.append(self._bulleted_list(gap_text))

        return blocks

    # ========================================================================
    # NOTION BLOCK BUILDERS
    # ========================================================================
    # These methods create properly formatted Notion block objects.
    # WHY: Notion's API requires specific JSON structures for each block type.

    def _heading_1(self, text: str) -> dict:
        """Create a Heading 1 block."""
        return {
            "object": "block",
            "type": "heading_1",
            "heading_1": {
                "rich_text": [{"type": "text", "text": {"content": text[:2000]}}]
            }
        }

    def _heading_2(self, text: str) -> dict:
        """Create a Heading 2 block."""
        return {
            "object": "block",
            "type": "heading_2",
            "heading_2": {
                "rich_text": [{"type": "text", "text": {"content": text[:2000]}}]
            }
        }

    def _heading_3(self, text: str) -> dict:
        """Create a Heading 3 block."""
        return {
            "object": "block",
            "type": "heading_3",
            "heading_3": {
                "rich_text": [{"type": "text", "text": {"content": text[:2000]}}]
            }
        }

    def _paragraph(self, text: str) -> dict:
        """Create a paragraph block with optional bold/italic markdown."""
        # Parse simple markdown (bold and italic)
        rich_text = self._parse_markdown_to_rich_text(text)
        return {
            "object": "block",
            "type": "paragraph",
            "paragraph": {
                "rich_text": rich_text
            }
        }

    def _bulleted_list(self, text: str) -> dict:
        """Create a bulleted list item."""
        rich_text = self._parse_markdown_to_rich_text(text)
        return {
            "object": "block",
            "type": "bulleted_list_item",
            "bulleted_list_item": {
                "rich_text": rich_text
            }
        }

    def _numbered_list(self, text: str) -> dict:
        """Create a numbered list item."""
        # Remove leading number if present (e.g., "1. Step" -> "Step")
        clean_text = re.sub(r'^\d+\.\s*', '', text)
        rich_text = self._parse_markdown_to_rich_text(clean_text)
        return {
            "object": "block",
            "type": "numbered_list_item",
            "numbered_list_item": {
                "rich_text": rich_text
            }
        }

    def _to_do(self, text: str) -> dict:
        """Create a to-do (checkbox) item."""
        rich_text = self._parse_markdown_to_rich_text(text)
        return {
            "object": "block",
            "type": "to_do",
            "to_do": {
                "rich_text": rich_text,
                "checked": False
            }
        }

    def _callout(self, text: str, emoji: str = "💡") -> dict:
        """Create a callout block."""
        rich_text = self._parse_markdown_to_rich_text(text)
        return {
            "object": "block",
            "type": "callout",
            "callout": {
                "rich_text": rich_text,
                "icon": {"type": "emoji", "emoji": emoji}
            }
        }

    def _toggle(self, title: str, children: list[dict]) -> dict:
        """Create a toggle (collapsible) block with children."""
        rich_text = self._parse_markdown_to_rich_text(title)
        return {
            "object": "block",
            "type": "toggle",
            "toggle": {
                "rich_text": rich_text,
                "children": children[:100]  # Notion limits children
            }
        }

    def _divider(self) -> dict:
        """Create a divider block."""
        return {
            "object": "block",
            "type": "divider",
            "divider": {}
        }

    def _parse_markdown_to_rich_text(self, text: str) -> list[dict]:
        """
        PURPOSE:
            Parse simple markdown (bold, italic) to Notion rich text format.

        PARAMETERS:
            text (str): Text possibly containing **bold** or _italic_

        RETURNS:
            list[dict]: Notion rich_text array

        WHY THIS APPROACH:
            Notion doesn't accept raw markdown in rich_text. We need to
            convert markdown formatting to Notion's annotation structure.
        """
        if not text:
            return [{"type": "text", "text": {"content": ""}}]

        # Truncate if too long
        text = text[:2000]

        # Simple approach: just return plain text for now
        # Full markdown parsing would make this much more complex
        # and Notion handles some markdown in the UI anyway

        # Handle **bold** -> annotations
        rich_text = []
        remaining = text

        # Pattern for **bold**
        bold_pattern = r'\*\*(.+?)\*\*'
        # Pattern for _italic_ or *italic*
        italic_pattern = r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)|_(.+?)_'

        # For simplicity, just strip markdown and return plain text
        # This preserves readability without complex parsing
        clean_text = re.sub(r'\*\*(.+?)\*\*', r'\1', text)  # Remove bold markers
        clean_text = re.sub(r'_(.+?)_', r'\1', clean_text)  # Remove italic markers

        return [{"type": "text", "text": {"content": clean_text}}]

    # ========================================================================
    # PAGE CREATION
    # ========================================================================

    def _create_page(
        self,
        parent_id: str,
        title: str,
        blocks: list[dict]
    ) -> dict:
        """
        PURPOSE:
            Create a new Notion page with the given content.

        PARAMETERS:
            parent_id (str): Parent page ID
            title (str): Page title
            blocks (list[dict]): Page content blocks

        RETURNS:
            dict: Created page object

        WHY THIS APPROACH:
            Notion API limits blocks per request to 100. For larger pages,
            we create the page first, then append blocks in batches.
        """
        # Create page with first batch of blocks (up to 100)
        first_batch = blocks[:100]
        remaining_blocks = blocks[100:]

        page = self.client.pages.create(
            parent={"page_id": parent_id},
            properties={
                "title": {
                    "title": [{"type": "text", "text": {"content": title}}]
                }
            },
            children=first_batch
        )

        # Append remaining blocks in batches
        page_id = page['id']
        while remaining_blocks:
            batch = remaining_blocks[:100]
            remaining_blocks = remaining_blocks[100:]

            self.client.blocks.children.append(
                block_id=page_id,
                children=batch
            )

        return page

    # ========================================================================
    # UTILITY METHODS
    # ========================================================================

    def _extract_page_title(self, page: dict) -> str:
        """Extract title from a Notion page object."""
        properties = page.get('properties', {})

        # Try various property names
        for prop_name in ['title', 'Title', 'Name', 'name']:
            if prop_name in properties:
                title_array = properties[prop_name].get('title', [])
                if title_array:
                    return title_array[0].get('plain_text', 'Untitled')

        return "Untitled"

    def get_stats(self) -> dict:
        """Return export statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def export_to_notion(
    stories: list[dict],
    test_cases: list[dict],
    project_name: str,
    prefix: str = "REQ",
    parent_page_id: Optional[str] = None,
    auto_create: bool = False,
    source_filename: str = "",
    traceability_matrix: dict = None
) -> dict:
    """
    PURPOSE:
        Convenience function to export stories and test cases to Notion.

    R EQUIVALENT:
        Like a wrapper function: export_to_notion <- function(stories, tests, ...)

    PARAMETERS:
        stories (list[dict]): User story dictionaries
        test_cases (list[dict]): Test case dictionaries
        project_name (str): Name of the project
        prefix (str): Test ID prefix (default: "REQ")
        parent_page_id (str, optional): Notion page ID for parent location
        auto_create (bool): Skip confirmations if True
        source_filename (str): Original input filename for reference
        traceability_matrix (dict, optional): RTM from TraceabilityGenerator.
            If provided, adds a Traceability Matrix section.

    RETURNS:
        dict: Export results with URL and counts

    USAGE:
        result = export_to_notion(
            stories, test_cases,
            project_name="HealthFlow",
            prefix="HF"
        )
        print(f"Page URL: {result['page_url']}")
    """
    formatter = NotionFormatter(
        project_name=project_name,
        prefix=prefix,
        parent_page_id=parent_page_id,
        auto_create=auto_create,
        source_filename=source_filename
    )

    return formatter.export(stories, test_cases, traceability_matrix)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    """
    PURPOSE:
        Test the NotionFormatter independently.

    USAGE:
        # First set your API key:
        export NOTION_API_KEY="your_integration_token"

        # Then run:
        python3 formatters/notion_formatter.py

        # Or with a specific parent page:
        python3 formatters/notion_formatter.py --parent-page-id "abc123..."

    WHY THIS APPROACH:
        Allows testing the formatter without running the full pipeline.
    """
    import sys

    print("=" * 70)
    print("NOTION FORMATTER TEST")
    print("=" * 70)

    # Check for API key
    if not os.environ.get('NOTION_API_KEY'):
        print("\nERROR: NOTION_API_KEY environment variable not set.")
        print("\nTo use the Notion formatter:")
        print("  1. Go to https://www.notion.so/my-integrations")
        print("  2. Create a new integration")
        print("  3. Copy the Internal Integration Token")
        print("  4. Set the environment variable:")
        print("     export NOTION_API_KEY='your_token_here'")
        print("  5. Share a Notion page with your integration:")
        print("     - Open the page in Notion")
        print("     - Click '...' menu → 'Add connections'")
        print("     - Select your integration")
        print("\nOnce configured, run this test again.")
        sys.exit(1)

    if not NOTION_AVAILABLE:
        print("\nERROR: notion-client not installed.")
        print("Install with: pip install notion-client")
        sys.exit(1)

    # Check for command line argument
    parent_id = None
    if len(sys.argv) > 1:
        if sys.argv[1] == '--parent-page-id' and len(sys.argv) > 2:
            parent_id = sys.argv[2]
            print(f"\nUsing parent page ID: {parent_id}")

    # Create sample data
    print("\nCreating sample data...")

    sample_stories = [
        {
            'generated_id': 'TEST-001',
            'title': 'User Login',
            'user_story': 'As a user, I want to login with my email and password, so that I can access my account securely.',
            'priority': 'High',
            'category': 'Authentication',
            'description': 'Basic authentication functionality for the patient portal.',
            'acceptance_criteria': [
                'User can enter email and password',
                'Invalid credentials show clear error message',
                'Successful login redirects to dashboard',
                'Session is created with appropriate timeout'
            ],
            'flags': ['priority_inferred'],
            'source_requirement': {'row_number': 1, 'source_cell': 'A1'}
        },
        {
            'generated_id': 'TEST-002',
            'title': 'Password Reset',
            'user_story': 'As a user, I want to reset my password via email, so that I can regain access if I forget it.',
            'priority': 'High',
            'category': 'Authentication',
            'description': 'Password recovery functionality via email verification.',
            'acceptance_criteria': [
                'User can request password reset from login page',
                'Reset email is sent within 1 minute',
                'Reset link expires after 24 hours',
                'New password must meet complexity requirements'
            ],
            'flags': [],
            'source_requirement': {'row_number': 2, 'source_cell': 'A2'}
        }
    ]

    sample_tests = [
        {
            'test_id': 'TEST-AUTH-001',
            'source_story_id': 'TEST-001',
            'title': 'Verify successful login with valid credentials',
            'category': 'Authentication',
            'test_type': 'happy_path',
            'prerequisites': ['Valid user account exists', 'User is not logged in'],
            'test_steps': [
                '1. Navigate to login page',
                '2. Enter valid email address',
                '3. Enter valid password',
                '4. Click Login button'
            ],
            'expected_results': [
                '• User is logged in successfully',
                '• Dashboard page is displayed',
                '• Welcome message shows user name'
            ],
            'moscow': 'Must Have',
            'est_time': '3 min',
            'notes': 'Core authentication test - must pass for go-live'
        },
        {
            'test_id': 'TEST-AUTH-002',
            'source_story_id': 'TEST-001',
            'title': 'Verify error message on invalid password',
            'category': 'Authentication',
            'test_type': 'negative',
            'prerequisites': ['Valid user account exists'],
            'test_steps': [
                '1. Navigate to login page',
                '2. Enter valid email address',
                '3. Enter incorrect password',
                '4. Click Login button'
            ],
            'expected_results': [
                '• Error message is displayed',
                '• User remains on login page',
                '• Password field is cleared'
            ],
            'moscow': 'Must Have',
            'est_time': '2 min',
            'notes': ''
        }
    ]

    print(f"  Stories: {len(sample_stories)}")
    print(f"  Test cases: {len(sample_tests)}")

    # Run export
    print("\nStarting Notion export...")
    if not parent_id:
        print("(Will search for shared pages matching 'Requirements Toolkit Test')")
    print("(You may be prompted to confirm actions)")

    try:
        result = export_to_notion(
            sample_stories,
            sample_tests,
            project_name="Requirements Toolkit Test",
            prefix="RTT",
            parent_page_id=parent_id,
            auto_create=False,
            source_filename="test_data.xlsx"
        )

        print("\n" + "=" * 70)
        print("TEST RESULTS")
        print("=" * 70)
        print(f"  Success: {result['success']}")
        print(f"  Stories added: {result['stories_added']}")
        print(f"  Tests added: {result['tests_added']}")
        if result['page_url']:
            print(f"  Page URL: {result['page_url']}")
        if result['errors']:
            print(f"  Errors: {result['errors']}")

    except Exception as e:
        print(f"\nTest failed with error: {e}")
        raise
