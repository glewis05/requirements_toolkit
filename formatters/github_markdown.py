# formatters/github_markdown.py
# ============================================================================
# GitHub Markdown Formatter
# ============================================================================
#
# PURPOSE:
#     Takes user stories and UAT test cases from the generators and formats
#     them into clean, GitHub-ready markdown. Supports bulk output (single
#     file with all stories) or individual files (one per story) for direct
#     GitHub issue creation.
#
# AVIATION ANALOGY:
#     Like formatting a flight plan for different audiences. The same route
#     data might be formatted differently for ATC, dispatch, or crew briefing.
#     This module is the "dispatch formatter" — taking raw data and making it
#     consumable for the GitHub "dispatch system."
#
# R EQUIVALENT:
#     In R, you might use rmarkdown or knitr to format output. This is similar
#     but specifically tailored for GitHub-flavored markdown with tables,
#     checkboxes, and proper escaping.
#
# USAGE:
#     # Quick function call:
#     from formatters.github_markdown import format_for_github
#     output_files = format_for_github(stories, test_cases, mode='single')
#
#     # Or use the class for more control:
#     from formatters.github_markdown import GitHubMarkdownFormatter
#     formatter = GitHubMarkdownFormatter(output_dir='outputs/github')
#     formatter.format(stories, test_cases, mode='separate')
#
# ============================================================================

import os
import re
from datetime import datetime
from typing import Optional, Literal


class GitHubMarkdownFormatter:
    """
    PURPOSE:
        Format user stories and UAT test cases into GitHub-ready markdown.
        Supports multiple output modes for different use cases.

    R EQUIVALENT:
        # In R, you might do something like:
        # format_markdown <- function(stories, tests, mode = "single") {
        #     if (mode == "single") {
        #         write_single_file(stories, tests)
        #     } else {
        #         lapply(stories, write_story_file)
        #     }
        # }

    ATTRIBUTES:
        output_dir (str): Directory where output files are saved
        source_file (str): Name of source file (for documentation)
        generated_date (str): Timestamp for the output

    WHY THIS CLASS:
        Encapsulating formatting in a class allows:
        1. Consistent configuration across multiple format() calls
        2. Stateful tracking of what's been output
        3. Easier testing and extension
    """

    def __init__(
        self,
        output_dir: str = "outputs/github",
        source_file: Optional[str] = None
    ):
        """
        PURPOSE:
            Initialize the formatter with output configuration.

        R EQUIVALENT:
            # In R, you'd set these as function parameters:
            # formatter <- list(
            #     output_dir = "outputs/github",
            #     source_file = NULL
            # )

        PARAMETERS:
            output_dir (str): Directory to save output files.
                Default: "outputs/github"
                Will be created if it doesn't exist.

            source_file (str, optional): Name of the source file being processed.
                Used in documentation headers. If None, shows "Unknown".

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            Separating configuration from execution makes the formatter
            reusable. You configure once and can call format() multiple
            times with different data.
        """
        # Store output directory path
        # WHY: All output files go here, keeping outputs organized
        self.output_dir = output_dir

        # Store source file name for documentation
        # WHY: Traceability — knowing where data came from
        self.source_file = source_file or "Unknown"

        # Generate timestamp once for consistency
        # WHY: All outputs from this session have same timestamp
        self.generated_date = datetime.now().strftime("%Y-%m-%d %H:%M")

        # Ensure output directory exists
        # WHY: Avoid errors when writing files
        # R EQUIVALENT: dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
        os.makedirs(self.output_dir, exist_ok=True)

        # Track statistics for summary
        self.stats = {
            'stories_formatted': 0,
            'tests_formatted': 0,
            'files_created': 0,
            'flagged_items': 0
        }

    def format(
        self,
        user_stories: list[dict],
        test_cases: list[dict],
        mode: Literal['single', 'separate'] = 'single',
        filename: str = "user_stories.md"
    ) -> list[str]:
        """
        PURPOSE:
            Main entry point — format stories and tests to markdown files.

        R EQUIVALENT:
            # format_output <- function(stories, tests, mode = "single", filename = "output.md") {
            #     if (mode == "single") {
            #         write_all_to_file(stories, tests, filename)
            #     } else {
            #         lapply(stories, function(s) write_story_file(s, tests))
            #     }
            # }

        PARAMETERS:
            user_stories (list[dict]): List of user story dicts from UserStoryGenerator.
                Each should have: title, user_story, priority, acceptance_criteria, etc.

            test_cases (list[dict]): List of test case dicts from UATGenerator.
                Each should have: test_id, title, test_steps, expected_results, etc.

            mode (str): Output mode - 'single' or 'separate'.
                - 'single': All stories in one file (default)
                - 'separate': One file per story

            filename (str): Base filename for output (used in 'single' mode).
                Default: "user_stories.md"
                In 'separate' mode, filenames are derived from story IDs.

        RETURNS:
            list[str]: List of paths to created files

        WHY THIS APPROACH:
            Two modes serve different workflows:
            - 'single': Good for review, bulk paste into wiki
            - 'separate': Good for creating individual GitHub issues
        """
        created_files = []

        if mode == 'single':
            # All stories in one file
            filepath = self._format_single_file(
                user_stories, test_cases, filename
            )
            created_files.append(filepath)

        elif mode == 'separate':
            # One file per story
            for story in user_stories:
                # Get tests for this story
                story_tests = self._get_tests_for_story(story, test_cases)

                # Generate filename from story ID
                story_id = story.get('generated_id', 'unknown')
                safe_id = self._sanitize_filename(story_id)
                story_filename = f"{safe_id}.md"

                filepath = self._format_story_file(
                    story, story_tests, story_filename
                )
                created_files.append(filepath)

        self.stats['files_created'] = len(created_files)
        return created_files

    def _format_single_file(
        self,
        user_stories: list[dict],
        test_cases: list[dict],
        filename: str
    ) -> str:
        """
        PURPOSE:
            Format all stories into a single markdown file.

        PARAMETERS:
            user_stories (list[dict]): All user stories
            test_cases (list[dict]): All test cases
            filename (str): Output filename

        RETURNS:
            str: Path to created file

        WHY THIS APPROACH:
            Single file is ideal for:
            - Full project documentation
            - Pasting into wiki pages
            - Review before creating individual issues
        """
        lines = []

        # ================================================================
        # DOCUMENT HEADER
        # ================================================================
        lines.append("# User Stories & UAT Test Cases")
        lines.append("")
        lines.append(f"**Generated:** {self.generated_date}")
        lines.append(f"**Source:** {self.source_file}")
        lines.append("")

        # ================================================================
        # SUMMARY SECTION
        # ================================================================
        summary = self._generate_summary(user_stories, test_cases)
        lines.extend(summary)
        lines.append("")

        # ================================================================
        # TABLE OF CONTENTS
        # ================================================================
        lines.append("## Table of Contents")
        lines.append("")
        for i, story in enumerate(user_stories, 1):
            title = story.get('title', 'Untitled')
            # Create anchor link (GitHub auto-generates anchors from headers)
            anchor = self._create_anchor(title)
            lines.append(f"{i}. [{title}](#{anchor})")
        lines.append("")
        lines.append("---")
        lines.append("")

        # ================================================================
        # INDIVIDUAL STORIES
        # ================================================================
        for story in user_stories:
            story_tests = self._get_tests_for_story(story, test_cases)
            story_md = self._format_story(story, story_tests)
            lines.extend(story_md)
            lines.append("")

        # Join and write
        content = "\n".join(lines)
        filepath = os.path.join(self.output_dir, filename)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        return filepath

    def _format_story_file(
        self,
        story: dict,
        test_cases: list[dict],
        filename: str
    ) -> str:
        """
        PURPOSE:
            Format a single story to its own markdown file.

        PARAMETERS:
            story (dict): The user story
            test_cases (list[dict]): Test cases for this story
            filename (str): Output filename

        RETURNS:
            str: Path to created file

        WHY THIS APPROACH:
            Individual files can be directly used as GitHub issue content.
            Copy-paste ready for issue creation.
        """
        lines = []

        # Format the story (no document header needed for individual issues)
        story_md = self._format_story(story, test_cases, include_header=True)
        lines.extend(story_md)

        # Join and write
        content = "\n".join(lines)
        filepath = os.path.join(self.output_dir, filename)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

        self.stats['stories_formatted'] += 1
        return filepath

    def _format_story(
        self,
        story: dict,
        test_cases: list[dict],
        include_header: bool = True
    ) -> list[str]:
        """
        PURPOSE:
            Format a single user story with its test cases to markdown lines.
            This is the core formatting logic matching CLAUDE.md template.

        R EQUIVALENT:
            # format_single_story <- function(story, tests) {
            #     c(
            #         paste("##", story$title),
            #         "",
            #         paste("**User Story:**", story$user_story),
            #         # ... etc
            #     )
            # }

        PARAMETERS:
            story (dict): The user story dictionary
            test_cases (list[dict]): Test cases for this story
            include_header (bool): Whether to include ## header (True for separate files)

        RETURNS:
            list[str]: Lines of markdown

        WHY THIS APPROACH:
            Following the exact template from CLAUDE.md ensures consistent,
            predictable output that matches project standards.
        """
        lines = []

        # ================================================================
        # TITLE (## Header)
        # ================================================================
        title = story.get('title', 'Untitled Story')
        if include_header:
            lines.append(f"## {self._escape_markdown(title)}")
            lines.append("")

        # ================================================================
        # USER STORY
        # ================================================================
        user_story = story.get('user_story', 'No user story defined')
        lines.append(f"**User Story:** {self._escape_markdown(user_story)}")
        lines.append("")

        # ================================================================
        # PRIORITY
        # ================================================================
        priority = story.get('priority', 'Medium')
        # Add visual indicator for priority
        priority_icon = {
            'Critical': '🔴',
            'High': '🟠',
            'Medium': '🟡',
            'Low': '🟢'
        }.get(priority, '')
        lines.append(f"**Priority:** {priority_icon} {priority}")
        lines.append("")

        # ================================================================
        # DESCRIPTION
        # ================================================================
        description = story.get('description', '')
        notes = story.get('source_requirement', {}).get('notes', '')

        if description or notes:
            lines.append("**Description:**")
            if description:
                lines.append(self._escape_markdown(description))
            if notes:
                lines.append(f"*Notes: {self._escape_markdown(notes)}*")
            lines.append("")

        # ================================================================
        # ACCEPTANCE CRITERIA (with checkboxes)
        # ================================================================
        lines.append("**Acceptance Criteria:**")
        acceptance_criteria = story.get('acceptance_criteria', [])

        if acceptance_criteria:
            for criterion in acceptance_criteria:
                # Clean up the criterion text
                clean = self._clean_criterion(criterion)
                lines.append(f"- [ ] {clean}")
        else:
            lines.append("- [ ] *No acceptance criteria defined*")
        lines.append("")

        # ================================================================
        # UAT TEST CASES TABLE
        # ================================================================
        if test_cases:
            lines.append("**UAT Test Cases:**")
            lines.append("")

            # Table header
            lines.append("| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |")
            lines.append("|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|")

            # Table rows
            for tc in test_cases:
                row = self._format_test_case_row(tc)
                lines.append(row)

            lines.append("")

            # Detailed test case expansion (collapsible)
            lines.append("<details>")
            lines.append("<summary><strong>Detailed Test Steps (click to expand)</strong></summary>")
            lines.append("")

            for tc in test_cases:
                detailed = self._format_test_case_detailed(tc)
                lines.extend(detailed)

            lines.append("</details>")
            lines.append("")

        # ================================================================
        # QUALITY FLAGS (if any)
        # ================================================================
        flags = story.get('flags', [])
        if flags:
            lines.append("**Quality Flags:**")
            for flag in flags:
                flag_description = self._describe_flag(flag)
                lines.append(f"- ⚠️ {flag_description}")
            lines.append("")
            self.stats['flagged_items'] += 1

        # ================================================================
        # DEPENDENCIES
        # ================================================================
        dependencies = story.get('dependencies', [])
        if dependencies:
            lines.append(f"**Dependencies:** {', '.join(dependencies)}")
        else:
            lines.append("**Dependencies:** None")
        lines.append("")

        # ================================================================
        # SOURCE
        # ================================================================
        source_req = story.get('source_requirement', {})
        row_num = source_req.get('row_number', 'N/A')
        lines.append(f"**Source:** {self.source_file}, Row {row_num}")
        lines.append("")

        # ================================================================
        # SEPARATOR
        # ================================================================
        lines.append("---")

        self.stats['stories_formatted'] += 1
        self.stats['tests_formatted'] += len(test_cases)

        return lines

    def _format_test_case_row(self, tc: dict) -> str:
        """
        PURPOSE:
            Format a test case as a markdown table row.

        PARAMETERS:
            tc (dict): The test case dictionary

        RETURNS:
            str: A markdown table row

        WHY THIS APPROACH:
            Tables provide quick scanning. Full details go in collapsible
            section below for those who need them.
        """
        # Extract and truncate fields for table display
        test_id = tc.get('test_id', 'N/A')
        category = tc.get('category', 'General')
        title = self._truncate(tc.get('title', 'Untitled'), 40)
        moscow = tc.get('moscow', 'Should Have')
        est_time = tc.get('est_time', '5 min')
        notes = self._truncate(tc.get('notes', ''), 30)

        # Format prerequisites as compact list
        prereqs = tc.get('prerequisites', [])
        prereqs_str = self._format_cell_list(prereqs, max_items=2)

        # Format steps as compact list
        steps = tc.get('test_steps', [])
        steps_str = self._format_cell_list(steps, max_items=2)

        # Format expected results as compact list
        expected = tc.get('expected_results', [])
        expected_str = self._format_cell_list(expected, max_items=2)

        # Build the row (escape pipes in content)
        row = (
            f"| {test_id} "
            f"| {self._escape_pipe(category)} "
            f"| {self._escape_pipe(title)} "
            f"| {prereqs_str} "
            f"| {steps_str} "
            f"| {expected_str} "
            f"| {moscow} "
            f"| {est_time} "
            f"| {self._escape_pipe(notes)} |"
        )

        return row

    def _format_test_case_detailed(self, tc: dict) -> list[str]:
        """
        PURPOSE:
            Format a test case with full details for the collapsible section.

        PARAMETERS:
            tc (dict): The test case dictionary

        RETURNS:
            list[str]: Lines of detailed markdown

        WHY THIS APPROACH:
            Full details are needed for actual test execution, but would
            make the main document too long. Collapsible sections are ideal.
        """
        lines = []

        test_id = tc.get('test_id', 'N/A')
        title = tc.get('title', 'Untitled')
        test_type = tc.get('test_type', 'unknown')

        # Header with type badge
        type_badge = {
            'happy_path': '✅ Happy Path',
            'negative': '❌ Negative',
            'edge_case': '🔶 Edge Case',
            'boundary': '📏 Boundary'
        }.get(test_type, test_type)

        lines.append(f"### {test_id}: {title}")
        lines.append(f"*{type_badge}*")
        lines.append("")

        # Prerequisites
        prereqs = tc.get('prerequisites', [])
        if prereqs:
            lines.append("**Pre-Requisites:**")
            for prereq in prereqs:
                lines.append(f"- {prereq}")
            lines.append("")

        # Test Steps
        steps = tc.get('test_steps', [])
        if steps:
            lines.append("**Test Steps:**")
            for step in steps:
                # Steps are already numbered, just add them
                lines.append(step)
            lines.append("")

        # Expected Results
        expected = tc.get('expected_results', [])
        if expected:
            lines.append("**Expected Results:**")
            for result in expected:
                # Results may have bullet prefix already
                if not result.strip().startswith('•'):
                    result = f"• {result}"
                lines.append(result)
            lines.append("")

        # Notes
        notes = tc.get('notes', '')
        if notes:
            lines.append(f"**Notes:** {notes}")
            lines.append("")

        return lines

    def _generate_summary(
        self,
        user_stories: list[dict],
        test_cases: list[dict]
    ) -> list[str]:
        """
        PURPOSE:
            Generate a summary section for the document header.

        PARAMETERS:
            user_stories (list[dict]): All user stories
            test_cases (list[dict]): All test cases

        RETURNS:
            list[str]: Lines of summary markdown

        WHY THIS APPROACH:
            Summary gives readers a quick overview before diving into
            details. Priority breakdown helps with planning.
        """
        lines = []

        lines.append("## Summary")
        lines.append("")

        # ================================================================
        # COUNTS
        # ================================================================
        lines.append("### Overview")
        lines.append("")
        lines.append(f"- **Total User Stories:** {len(user_stories)}")
        lines.append(f"- **Total UAT Test Cases:** {len(test_cases)}")
        lines.append("")

        # ================================================================
        # PRIORITY BREAKDOWN
        # ================================================================
        priority_counts = {'Critical': 0, 'High': 0, 'Medium': 0, 'Low': 0}
        for story in user_stories:
            priority = story.get('priority', 'Medium')
            if priority in priority_counts:
                priority_counts[priority] += 1

        lines.append("### By Priority")
        lines.append("")
        lines.append("| Priority | Count |")
        lines.append("|----------|-------|")
        lines.append(f"| 🔴 Critical | {priority_counts['Critical']} |")
        lines.append(f"| 🟠 High | {priority_counts['High']} |")
        lines.append(f"| 🟡 Medium | {priority_counts['Medium']} |")
        lines.append(f"| 🟢 Low | {priority_counts['Low']} |")
        lines.append("")

        # ================================================================
        # TEST TYPE BREAKDOWN
        # ================================================================
        test_type_counts = {
            'happy_path': 0,
            'negative': 0,
            'edge_case': 0,
            'boundary': 0
        }
        for tc in test_cases:
            test_type = tc.get('test_type', 'unknown')
            if test_type in test_type_counts:
                test_type_counts[test_type] += 1

        lines.append("### Test Coverage")
        lines.append("")
        lines.append("| Test Type | Count |")
        lines.append("|-----------|-------|")
        lines.append(f"| ✅ Happy Path | {test_type_counts['happy_path']} |")
        lines.append(f"| ❌ Negative | {test_type_counts['negative']} |")
        lines.append(f"| 🔶 Edge Case | {test_type_counts['edge_case']} |")
        lines.append(f"| 📏 Boundary | {test_type_counts['boundary']} |")
        lines.append("")

        # ================================================================
        # FLAGGED ITEMS (requiring attention)
        # ================================================================
        flagged_stories = [s for s in user_stories if s.get('flags')]
        if flagged_stories:
            lines.append("### ⚠️ Items Requiring Attention")
            lines.append("")
            for story in flagged_stories:
                title = story.get('title', 'Untitled')
                flags = story.get('flags', [])
                flag_str = ', '.join([self._describe_flag(f) for f in flags])
                lines.append(f"- **{title}**: {flag_str}")
            lines.append("")

        lines.append("---")

        return lines

    def _get_tests_for_story(
        self,
        story: dict,
        all_tests: list[dict]
    ) -> list[dict]:
        """
        PURPOSE:
            Get all test cases that belong to a specific story.

        PARAMETERS:
            story (dict): The user story
            all_tests (list[dict]): All test cases

        RETURNS:
            list[dict]: Test cases for this story

        WHY THIS APPROACH:
            Tests are linked to stories via source_story_id. This lets
            us filter efficiently.
        """
        story_id = story.get('generated_id', '')
        return [tc for tc in all_tests if tc.get('source_story_id') == story_id]

    # ====================================================================
    # HELPER METHODS
    # ====================================================================

    def _escape_markdown(self, text: str) -> str:
        """
        PURPOSE:
            Escape special markdown characters in text.

        PARAMETERS:
            text (str): Raw text

        RETURNS:
            str: Text with markdown characters escaped

        WHY THIS APPROACH:
            Prevents accidental formatting. Characters like * _ ` can
            cause unintended bold/italic/code formatting.
        """
        if not text:
            return ""

        # Characters that have special meaning in markdown
        # WHY: These can cause formatting issues if not escaped
        # We're selective — some like | are handled separately for tables
        escape_chars = ['\\', '`', '*', '_', '{', '}', '[', ']', '(', ')', '#', '+', '-', '.', '!']

        result = text
        for char in escape_chars:
            # Only escape if it might cause formatting issues
            # Don't escape - at start of lines (list items)
            # Don't escape # at start of lines (headers)
            if char in ['#', '-']:
                continue
            result = result.replace(char, f'\\{char}')

        return result

    def _escape_pipe(self, text: str) -> str:
        """
        PURPOSE:
            Escape pipe characters for markdown tables.

        PARAMETERS:
            text (str): Raw text

        RETURNS:
            str: Text with pipes escaped

        WHY THIS APPROACH:
            Pipes are table column delimiters. Unescaped pipes in content
            would break table structure.
        """
        if not text:
            return ""
        return text.replace('|', '\\|')

    def _truncate(self, text: str, max_length: int) -> str:
        """
        PURPOSE:
            Truncate text to max length with ellipsis.

        PARAMETERS:
            text (str): Text to truncate
            max_length (int): Maximum length

        RETURNS:
            str: Truncated text

        WHY THIS APPROACH:
            Table cells need to stay reasonable width. Full content
            goes in the detailed section.
        """
        if not text:
            return ""
        if len(text) <= max_length:
            return text
        return text[:max_length - 3] + "..."

    def _format_cell_list(
        self,
        items: list[str],
        max_items: int = 2
    ) -> str:
        """
        PURPOSE:
            Format a list for display in a table cell.

        PARAMETERS:
            items (list[str]): List items
            max_items (int): Maximum items to show

        RETURNS:
            str: Formatted string with <br> separators

        WHY THIS APPROACH:
            Table cells can contain line breaks using <br> in GitHub markdown.
            This keeps cells compact while showing key info.
        """
        if not items:
            return "N/A"

        # Clean items and limit display
        clean_items = []
        for item in items[:max_items]:
            # Remove numbering from steps (1. 2. etc)
            clean = re.sub(r'^\d+\.\s*', '', str(item))
            # Truncate long items
            clean = self._truncate(clean, 50)
            # Escape pipes
            clean = self._escape_pipe(clean)
            clean_items.append(clean)

        result = "<br>".join(clean_items)

        # Add indicator if more items exist
        if len(items) > max_items:
            result += f"<br>*...({len(items)} total)*"

        return result

    def _clean_criterion(self, criterion: str) -> str:
        """
        PURPOSE:
            Clean up an acceptance criterion for checkbox format.

        PARAMETERS:
            criterion (str): Raw criterion text

        RETURNS:
            str: Cleaned text

        WHY THIS APPROACH:
            Criteria may have bullet prefixes or extra whitespace.
            Clean formatting makes the output consistent.
        """
        # Remove bullet prefixes
        clean = criterion.strip()
        if clean.startswith('•'):
            clean = clean[1:].strip()
        if clean.startswith('-'):
            clean = clean[1:].strip()
        if clean.startswith('*'):
            clean = clean[1:].strip()

        # Capitalize first letter if not already
        if clean and clean[0].islower():
            clean = clean[0].upper() + clean[1:]

        return clean

    def _describe_flag(self, flag: str) -> str:
        """
        PURPOSE:
            Convert a flag code to a human-readable description.

        PARAMETERS:
            flag (str): Flag code (e.g., 'priority_inferred')

        RETURNS:
            str: Human-readable description

        WHY THIS APPROACH:
            Flags are stored as codes for efficiency, but users need
            to understand what they mean.
        """
        flag_descriptions = {
            'priority_inferred': 'Priority was auto-assigned (review recommended)',
            'vague_requirement': 'Source requirement may be too vague',
            'compound_split': 'Split from a compound requirement',
            'missing_benefit': 'No clear benefit/value statement',
            'passive_voice': 'Converted from passive voice',
            'duplicate_candidate': 'May be a duplicate of another story',
            'role_inferred': 'User role was auto-assigned'
        }

        return flag_descriptions.get(flag, flag.replace('_', ' ').title())

    def _create_anchor(self, title: str) -> str:
        """
        PURPOSE:
            Create a GitHub-compatible anchor link from a title.

        PARAMETERS:
            title (str): The header title

        RETURNS:
            str: Anchor string (lowercase, hyphens)

        WHY THIS APPROACH:
            GitHub auto-generates anchors from headers. This replicates
            that logic so our TOC links work correctly.
        """
        # GitHub anchor rules:
        # - Lowercase everything
        # - Remove special characters except hyphens and spaces
        # - Replace spaces with hyphens
        # - Remove consecutive hyphens
        anchor = title.lower()
        anchor = re.sub(r'[^\w\s-]', '', anchor)
        anchor = re.sub(r'\s+', '-', anchor)
        anchor = re.sub(r'-+', '-', anchor)
        anchor = anchor.strip('-')

        return anchor

    def _sanitize_filename(self, name: str) -> str:
        """
        PURPOSE:
            Create a safe filename from a story ID or title.

        PARAMETERS:
            name (str): The raw name

        RETURNS:
            str: Safe filename (no special chars)

        WHY THIS APPROACH:
            Filenames can't contain certain characters on various OS.
            We sanitize to ensure cross-platform compatibility.
        """
        # Remove or replace unsafe characters
        safe = re.sub(r'[<>:"/\\|?*]', '', name)
        safe = re.sub(r'\s+', '_', safe)
        return safe

    def get_stats(self) -> dict:
        """
        PURPOSE:
            Return formatting statistics.

        RETURNS:
            dict: Statistics dictionary

        WHY THIS APPROACH:
            Statistics help track what was done and can be used
            for logging or reporting.
        """
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================
# This function provides a quick way to format without creating a class instance.
# Usage: from formatters.github_markdown import format_for_github
# ============================================================================

def format_for_github(
    user_stories: list[dict],
    test_cases: list[dict],
    output_dir: str = "outputs/github",
    source_file: Optional[str] = None,
    mode: Literal['single', 'separate'] = 'single',
    filename: str = "user_stories.md"
) -> list[str]:
    """
    PURPOSE:
        Convenience function to format user stories and tests to GitHub markdown.
        Creates a formatter, runs it, and returns the list of created files.

    R EQUIVALENT:
        # In R, this would be the main function users call:
        # format_for_github <- function(stories, tests, output_dir = "outputs/github",
        #                               source_file = NULL, mode = "single") {
        #     formatter <- create_formatter(output_dir, source_file)
        #     format_output(formatter, stories, tests, mode)
        # }

    PARAMETERS:
        user_stories (list[dict]): User story dicts from UserStoryGenerator
        test_cases (list[dict]): Test case dicts from UATGenerator
        output_dir (str): Where to save output files. Default: "outputs/github"
        source_file (str): Name of source file for documentation. Default: None
        mode (str): 'single' for one file, 'separate' for one per story
        filename (str): Output filename (for 'single' mode). Default: "user_stories.md"

    RETURNS:
        list[str]: Paths to created files

    EXAMPLE:
        from formatters.github_markdown import format_for_github

        files = format_for_github(
            stories,
            test_cases,
            source_file="requirements.xlsx",
            mode='single'
        )
        print(f"Created: {files}")
    """
    formatter = GitHubMarkdownFormatter(
        output_dir=output_dir,
        source_file=source_file
    )

    return formatter.format(
        user_stories=user_stories,
        test_cases=test_cases,
        mode=mode,
        filename=filename
    )


# ============================================================================
# STANDALONE TEST
# ============================================================================
# Run this file directly to test with sample data:
#     python formatters/github_markdown.py
# ============================================================================

if __name__ == "__main__":
    # Sample data for testing
    sample_stories = [
        {
            'generated_id': 'US-001',
            'title': 'User login with email and password',
            'user_story': 'As a user, I want to login with my email and password, so that I can access my account securely.',
            'priority': 'High',
            'description': 'Standard email/password authentication flow.',
            'role': 'user',
            'capability': 'login with my email and password',
            'benefit': 'I can access my account securely',
            'acceptance_criteria': [
                'Given valid credentials, user is logged in successfully',
                'Given invalid credentials, error message is displayed',
                'Session expires after 30 minutes of inactivity'
            ],
            'flags': [],
            'source_requirement': {
                'row_number': 5,
                'notes': 'SSO to be added in phase 2'
            }
        },
        {
            'generated_id': 'US-002',
            'title': 'Export dashboard data to Excel',
            'user_story': 'As an analyst, I want to export dashboard data to Excel, so that I can perform offline analysis.',
            'priority': 'Medium',
            'description': '',
            'role': 'analyst',
            'capability': 'export dashboard data to Excel',
            'benefit': 'I can perform offline analysis',
            'acceptance_criteria': [
                'Export button visible on dashboard',
                'Excel file downloads within 10 seconds',
                'All visible data included in export'
            ],
            'flags': ['priority_inferred'],
            'source_requirement': {
                'row_number': 12
            }
        }
    ]

    sample_tests = [
        {
            'test_id': 'TEST-AUTH-001',
            'source_story_id': 'US-001',
            'category': 'Authentication',
            'title': 'Verify successful login with valid credentials',
            'test_type': 'happy_path',
            'prerequisites': ['Valid test user exists', 'User is not logged in'],
            'test_steps': ['1. Navigate to login page', '2. Enter valid email', '3. Enter valid password', '4. Click Login'],
            'expected_results': ['• User is redirected to dashboard', '• Welcome message displayed'],
            'moscow': 'Must Have',
            'est_time': '5 min',
            'notes': 'Test on Chrome, Firefox, Safari'
        },
        {
            'test_id': 'TEST-AUTH-002',
            'source_story_id': 'US-001',
            'category': 'Authentication',
            'title': 'Verify login fails with invalid password',
            'test_type': 'negative',
            'prerequisites': ['Valid test user exists'],
            'test_steps': ['1. Navigate to login page', '2. Enter valid email', '3. Enter wrong password', '4. Click Login'],
            'expected_results': ['• Error message displayed', '• User remains on login page'],
            'moscow': 'Must Have',
            'est_time': '3 min',
            'notes': ''
        },
        {
            'test_id': 'TEST-RPT-001',
            'source_story_id': 'US-002',
            'category': 'Reporting',
            'title': 'Verify Excel export downloads successfully',
            'test_type': 'happy_path',
            'prerequisites': ['User is logged in', 'Dashboard has data'],
            'test_steps': ['1. Navigate to dashboard', '2. Click Export button', '3. Wait for download'],
            'expected_results': ['• Excel file downloads', '• File opens correctly', '• Data matches dashboard'],
            'moscow': 'Should Have',
            'est_time': '5 min',
            'notes': 'Check file size is reasonable'
        }
    ]

    print("=" * 70)
    print("GITHUB MARKDOWN FORMATTER TEST")
    print("=" * 70)
    print()

    # Test single file mode
    files = format_for_github(
        sample_stories,
        sample_tests,
        source_file="test_requirements.xlsx",
        mode='single',
        filename='test_output_single.md'
    )
    print(f"Single mode - Created: {files}")

    # Test separate file mode
    files = format_for_github(
        sample_stories,
        sample_tests,
        source_file="test_requirements.xlsx",
        mode='separate'
    )
    print(f"Separate mode - Created: {files}")

    # Show a preview of the single file
    print()
    print("=" * 70)
    print("PREVIEW (first 50 lines of single file):")
    print("=" * 70)
    with open("outputs/github/test_output_single.md", 'r') as f:
        lines = f.readlines()[:50]
        for line in lines:
            print(line.rstrip())
