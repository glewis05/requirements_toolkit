#!/usr/bin/env python3
# run.py
# ============================================================================
# Requirements Toolkit - Main Entry Point
# ============================================================================
#
# PURPOSE:
#     Orchestrates the full requirements processing pipeline:
#     1. Parse requirements from Excel file
#     2. Generate user stories
#     3. Generate UAT test cases
#     4. Export to GitHub markdown and/or Excel
#
# AVIATION ANALOGY:
#     This is like the Flight Management System (FMS) - it coordinates all
#     the subsystems (navigation, autopilot, performance) to execute the
#     flight plan. You input the route (requirements file), configure the
#     parameters (prefix, output format), and it orchestrates everything.
#
# R EQUIVALENT:
#     In R, this would be a main script that sources other files:
#     source("parsers/excel_parser.R")
#     source("generators/user_story_generator.R")
#     args <- commandArgs(trailingOnly = TRUE)
#     # ... process args and run pipeline ...
#
# USAGE:
#     python3 run.py "inputs/excel/requirements.xlsx" --prefix GRX --output both
#     python3 run.py "inputs/excel/client_reqs.xlsx" --prefix ACME --output markdown
#     python3 run.py "inputs/excel/features.xlsx" --sheet "Phase 1" --output excel
#
# ============================================================================

import sys
import os
import argparse
from datetime import datetime
from typing import Optional

# ============================================================================
# IMPORTS - Our toolkit modules
# ============================================================================
# WHY: We import from our package structure for clean organization
# R EQUIVALENT: Like source("parsers/excel_parser.R") in R

try:
    from parsers.excel_parser import ExcelParser
    from parsers.lucidchart_parser import LucidchartParser
    from parsers.word_parser import WordParser
    from generators.user_story_generator import UserStoryGenerator
    from generators.uat_generator import UATGenerator
    from generators.traceability_generator import generate_traceability_matrix
    from formatters.github_markdown import format_for_github
    from formatters.excel_formatter import export_to_excel
    # Compliance module - optional but recommended for regulated industries
    from compliance import (
        validate_part11, validate_hipaa, validate_soc2, validate_all,
        generate_part11_tests, generate_hipaa_tests, generate_soc2_tests,
        generate_all_compliance_tests
    )
    COMPLIANCE_AVAILABLE = True
except ImportError as e:
    # Check if it's just the compliance module missing (that's okay)
    if 'compliance' in str(e):
        COMPLIANCE_AVAILABLE = False
    else:
        print(f"ERROR: Failed to import required modules: {e}")
        print("Make sure you're running from the project root directory.")
        print("Expected structure:")
        print("  requirements_toolkit/")
        print("    ├── run.py")
        print("    ├── parsers/")
        print("    ├── generators/")
        print("    └── formatters/")
        sys.exit(1)


# ============================================================================
# CONSOLE OUTPUT HELPERS
# ============================================================================
# WHY: Consistent, colorful console output makes the tool user-friendly
# These functions provide visual structure to the output

def print_header(text: str):
    """Print a major section header."""
    print()
    print("=" * 70)
    print(f"  {text}")
    print("=" * 70)


def print_subheader(text: str):
    """Print a subsection header."""
    print()
    print(f"--- {text} ---")


def print_success(text: str):
    """Print a success message with checkmark."""
    print(f"  ✓ {text}")


def print_info(text: str):
    """Print an info message."""
    print(f"  → {text}")


def print_warning(text: str):
    """Print a warning message."""
    print(f"  ⚠ {text}")


def print_error(text: str):
    """Print an error message."""
    print(f"  ✗ ERROR: {text}")


def print_stat(label: str, value, indent: int = 2):
    """Print a statistic with label and value."""
    spaces = " " * indent
    print(f"{spaces}{label}: {value}")


# ============================================================================
# ARGUMENT PARSING
# ============================================================================

def parse_arguments() -> argparse.Namespace:
    """
    PURPOSE:
        Parse command-line arguments for the pipeline.

    R EQUIVALENT:
        # In R, you might use optparse or argparse packages:
        # library(optparse)
        # option_list <- list(
        #     make_option("--prefix", default = "REQ"),
        #     make_option("--output", default = "both")
        # )
        # args <- parse_args(OptionParser(option_list = option_list))

    RETURNS:
        argparse.Namespace: Parsed arguments

    WHY THIS APPROACH:
        argparse is Python's standard library for CLI argument parsing.
        It provides automatic help text, type validation, and default values.
    """
    parser = argparse.ArgumentParser(
        description="Requirements Toolkit - Transform messy requirements into user stories and UAT test cases",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Excel files
  python3 run.py "inputs/excel/requirements.xlsx"
  python3 run.py "inputs/excel/requirements.xlsx" --prefix GRX --output both
  python3 run.py "inputs/excel/client_reqs.xlsx" --prefix ACME --output markdown

  # Word documents
  python3 run.py "inputs/word/prd.docx" --prefix PRD --output both
  python3 run.py "inputs/word/requirements.docx" --prefix SPEC --output excel

  # Lucidchart exports
  python3 run.py "inputs/lucidchart/workflow.csv" --prefix LC --output both
  python3 run.py "inputs/lucidchart/diagram.svg" --prefix FLOW --output markdown

  # With compliance validation
  python3 run.py "requirements.xlsx" --prefix GRX --output both --compliance part11
  python3 run.py "requirements.xlsx" --prefix GRX --output both --compliance hipaa
  python3 run.py "requirements.xlsx" --prefix GRX --output both --compliance soc2
  python3 run.py "requirements.xlsx" --prefix GRX --output both --compliance all

Supported input formats:
  Excel:      .xlsx, .xls, .xlsm
  Word:       .docx (with tables and/or prose requirements)
  Lucidchart: .csv (CSV export), .svg (SVG export)

Output formats:
  markdown  - GitHub-flavored markdown for issues/wiki
  excel     - Formatted Excel workbook for UAT packages
  both      - Generate both formats (default)
        """
    )

    # Required positional argument: input file
    parser.add_argument(
        'input_file',
        type=str,
        help='Path to the requirements file (Excel, Word .docx, or Lucidchart .csv/.svg)'
    )

    # Optional arguments
    parser.add_argument(
        '--prefix',
        type=str,
        default='REQ',
        help='Test ID prefix, e.g., "GRX", "NCCN", "ACME" (default: REQ)'
    )

    parser.add_argument(
        '--output',
        type=str,
        choices=['markdown', 'excel', 'both'],
        default='both',
        help='Output format: markdown, excel, or both (default: both)'
    )

    parser.add_argument(
        '--sheet',
        type=str,
        default=None,
        help='Specific sheet name to parse (default: first sheet)'
    )

    parser.add_argument(
        '--output-dir',
        type=str,
        default='outputs',
        help='Base output directory (default: outputs/)'
    )

    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Show detailed processing information'
    )

    parser.add_argument(
        '--compliance',
        type=str,
        choices=['part11', 'hipaa', 'soc2', 'all', 'none'],
        default='none',
        help='Compliance framework to validate against: part11 (FDA 21 CFR Part 11), '
             'hipaa (HIPAA Security Rule), soc2 (SOC 2 TSC), all (all frameworks), '
             'or none (default: none)'
    )

    return parser.parse_args()


# ============================================================================
# FILE VALIDATION
# ============================================================================

def validate_input_file(filepath: str) -> bool:
    """
    PURPOSE:
        Validate that the input file exists and is a supported format.

    PARAMETERS:
        filepath (str): Path to the input file

    RETURNS:
        bool: True if valid, raises exception otherwise

    WHY THIS APPROACH:
        Early validation prevents confusing errors later in the pipeline.
        We check existence first, then format support.
    """
    # Check if file exists
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Input file not found: {filepath}")

    # Check if it's a file (not a directory)
    if not os.path.isfile(filepath):
        raise ValueError(f"Path is not a file: {filepath}")

    # Check file extension
    _, ext = os.path.splitext(filepath)
    # Supported formats: Excel, Word, and Lucidchart exports
    supported_extensions = ['.xlsx', '.xls', '.xlsm', '.docx', '.csv', '.svg']

    if ext.lower() not in supported_extensions:
        raise ValueError(
            f"Unsupported file format: {ext}\n"
            f"Supported formats: {', '.join(supported_extensions)}\n"
            f"  Excel: .xlsx, .xls, .xlsm\n"
            f"  Word: .docx\n"
            f"  Lucidchart: .csv, .svg"
        )

    return True


# ============================================================================
# MAIN PIPELINE
# ============================================================================

def run_pipeline(
    input_file: str,
    prefix: str = "REQ",
    output_format: str = "both",
    sheet_name: Optional[str] = None,
    output_dir: str = "outputs",
    verbose: bool = False,
    compliance: str = "none"
) -> dict:
    """
    PURPOSE:
        Execute the full requirements processing pipeline.

    R EQUIVALENT:
        # run_pipeline <- function(input_file, prefix = "REQ", output = "both") {
        #     # Parse
        #     requirements <- parse_excel(input_file)
        #     # Generate stories
        #     stories <- generate_user_stories(requirements)
        #     # Generate tests
        #     tests <- generate_uat_tests(stories, prefix)
        #     # Export
        #     if (output %in% c("both", "markdown")) export_markdown(stories, tests)
        #     if (output %in% c("both", "excel")) export_excel(stories, tests)
        # }

    PARAMETERS:
        input_file (str): Path to the input Excel file
        prefix (str): Test ID prefix (e.g., "GRX", "NCCN")
        output_format (str): "markdown", "excel", or "both"
        sheet_name (str, optional): Specific sheet to parse
        output_dir (str): Base output directory
        verbose (bool): Show detailed output

    RETURNS:
        dict: Results including counts and output file paths

    WHY THIS APPROACH:
        A single orchestrator function makes the pipeline easy to understand
        and modify. Each step is clearly separated with progress feedback.
    """
    results = {
        'success': False,
        'requirements_count': 0,
        'stories_count': 0,
        'test_cases_count': 0,
        'compliance_tests_count': 0,
        'compliance_reports': {},
        'traceability': None,  # RTM summary
        'flagged_items': 0,
        'output_files': [],
        'errors': []
    }

    # Extract source filename for documentation
    source_filename = os.path.basename(input_file)

    # ========================================================================
    # STEP 1: PARSE REQUIREMENTS
    # ========================================================================
    print_subheader("Step 1: Parsing Requirements")

    try:
        # Detect file type and use appropriate parser
        # WHY: Different file types need different parsing strategies
        _, ext = os.path.splitext(input_file)
        ext = ext.lower()

        if ext in ['.xlsx', '.xls', '.xlsm']:
            # Excel file → use ExcelParser
            print_info("Detected: Excel file")
            parser = ExcelParser(input_file)
        elif ext == '.docx':
            # Word document → use WordParser
            print_info("Detected: Word document (.docx)")
            parser = WordParser(input_file)
        elif ext in ['.csv', '.svg']:
            # Lucidchart export → use LucidchartParser
            print_info(f"Detected: Lucidchart export ({ext})")
            parser = LucidchartParser(input_file)
        else:
            raise ValueError(f"No parser available for {ext} files")

        # Parse the file
        requirements = parser.parse()

        if not requirements:
            print_warning("No requirements found in file")
            results['errors'].append("No requirements found")
            return results

        results['requirements_count'] = len(requirements)
        print_success(f"Parsed {len(requirements)} requirements")

        if verbose:
            # Show first few requirements
            print_info("Sample requirements:")
            for req in requirements[:3]:
                desc = req.get('description', req.get('raw_text', 'N/A'))
                if len(desc) > 60:
                    desc = desc[:57] + "..."
                print(f"      • {desc}")

    except Exception as e:
        print_error(f"Failed to parse file: {e}")
        results['errors'].append(f"Parse error: {e}")
        return results

    # ========================================================================
    # STEP 2: GENERATE USER STORIES
    # ========================================================================
    print_subheader("Step 2: Generating User Stories")

    try:
        # Pass prefix for new Story ID format: PREFIX-CATEGORY-SEQ
        story_generator = UserStoryGenerator(prefix=prefix)
        stories = story_generator.generate(requirements)

        if not stories:
            print_warning("No user stories generated")
            results['errors'].append("No stories generated")
            return results

        results['stories_count'] = len(stories)

        # Get stats for requirement type breakdown
        gen_stats = story_generator.get_stats()
        results['story_stats'] = gen_stats

        print_success(f"Generated {len(stories)} user stories")

        # Count stories by priority
        priority_counts = {}
        for story in stories:
            priority = story.get('priority', 'Medium')
            priority_counts[priority] = priority_counts.get(priority, 0) + 1

        if verbose:
            print_info("By priority:")
            for priority, count in sorted(priority_counts.items()):
                print(f"      • {priority}: {count}")

            # Show requirement type breakdown
            print_info("By requirement type:")
            if gen_stats.get('technical_features'):
                print(f"      • Technical Features: {gen_stats['technical_features']}")
            if gen_stats.get('workflow_changes'):
                print(f"      • Workflow Changes: {gen_stats['workflow_changes']}")
            if gen_stats.get('out_of_scope'):
                print(f"      • Out of Scope: {gen_stats['out_of_scope']}")
            if gen_stats.get('completed'):
                print(f"      • Completed: {gen_stats['completed']}")

        # Check for flagged items
        flagged = [s for s in stories if s.get('flags')]
        results['flagged_items'] = len(flagged)

        if flagged:
            print_warning(f"{len(flagged)} stories have quality flags")
            if verbose:
                for story in flagged[:3]:
                    flags = ', '.join(story.get('flags', []))
                    print(f"      • {story.get('title', 'Untitled')[:40]}: {flags}")

    except Exception as e:
        print_error(f"Failed to generate stories: {e}")
        results['errors'].append(f"Story generation error: {e}")
        return results

    # ========================================================================
    # STEP 3: GENERATE UAT TEST CASES
    # ========================================================================
    print_subheader("Step 3: Generating UAT Test Cases")

    try:
        uat_generator = UATGenerator(test_id_prefix=prefix)
        test_cases = uat_generator.generate(stories)

        if not test_cases:
            print_warning("No test cases generated")
            results['errors'].append("No test cases generated")
            return results

        results['test_cases_count'] = len(test_cases)
        print_success(f"Generated {len(test_cases)} test cases")

        # Get stats
        stats = uat_generator.get_stats()
        if verbose:
            print_info("By type:")
            by_type = stats.get('by_type', {})
            print(f"      • Happy Path: {by_type.get('happy_path', 0)}")
            print(f"      • Validation: {by_type.get('validation', 0)}")
            print(f"      • Negative: {by_type.get('negative', 0)}")
            print(f"      • Edge Cases: {by_type.get('edge_case', 0)}")
            # Show skipped non-technical items
            if stats.get('non_technical_skipped', 0) > 0:
                print(f"      • Skipped (non-technical): {stats['non_technical_skipped']}")

    except Exception as e:
        print_error(f"Failed to generate test cases: {e}")
        results['errors'].append(f"UAT generation error: {e}")
        return results

    # ========================================================================
    # STEP 3.5: COMPLIANCE VALIDATION (Optional)
    # ========================================================================
    compliance_tests = []

    if compliance != 'none':
        if not COMPLIANCE_AVAILABLE:
            print_warning("Compliance module not available. Skipping compliance validation.")
        else:
            print_subheader("Step 3.5: Compliance Validation")

            try:
                # Validate against selected framework(s)
                if compliance == 'all':
                    print_info("Validating against: Part 11, HIPAA, SOC 2")

                    # Part 11
                    p11_report = validate_part11(requirements, prefix)
                    results['compliance_reports']['part11'] = p11_report
                    print_success(f"Part 11: {p11_report['summary']['compliance_score']}% compliant, "
                                f"{p11_report['summary']['requirements_with_gaps']} gaps found")

                    # HIPAA
                    hipaa_report = validate_hipaa(requirements, prefix)
                    results['compliance_reports']['hipaa'] = hipaa_report
                    print_success(f"HIPAA: {hipaa_report['summary']['compliance_score']}% compliant, "
                                f"{hipaa_report['summary']['requirements_with_gaps']} gaps found")

                    # SOC 2
                    soc2_report = validate_soc2(requirements, prefix)
                    results['compliance_reports']['soc2'] = soc2_report
                    print_success(f"SOC 2: {soc2_report['summary']['compliance_score']}% compliant, "
                                f"{soc2_report['summary']['requirements_with_gaps']} gaps found")

                    # Generate compliance tests
                    all_compliance = generate_all_compliance_tests(requirements, prefix)
                    compliance_tests = all_compliance['combined']

                elif compliance == 'part11':
                    print_info("Validating against: FDA 21 CFR Part 11")
                    report = validate_part11(requirements, prefix)
                    results['compliance_reports']['part11'] = report
                    print_success(f"Compliance score: {report['summary']['compliance_score']}%")
                    print_info(f"Requirements with gaps: {report['summary']['requirements_with_gaps']}")
                    compliance_tests = generate_part11_tests(requirements, prefix)

                elif compliance == 'hipaa':
                    print_info("Validating against: HIPAA Security Rule")
                    report = validate_hipaa(requirements, prefix)
                    results['compliance_reports']['hipaa'] = report
                    print_success(f"Compliance score: {report['summary']['compliance_score']}%")
                    print_info(f"Requirements with gaps: {report['summary']['requirements_with_gaps']}")
                    compliance_tests = generate_hipaa_tests(requirements, prefix)

                elif compliance == 'soc2':
                    print_info("Validating against: SOC 2 Trust Services Criteria")
                    report = validate_soc2(requirements, prefix)
                    results['compliance_reports']['soc2'] = report
                    print_success(f"Compliance score: {report['summary']['compliance_score']}%")
                    print_info(f"Requirements with gaps: {report['summary']['requirements_with_gaps']}")
                    compliance_tests = generate_soc2_tests(requirements, prefix)

                # Add compliance tests to the main test list
                if compliance_tests:
                    results['compliance_tests_count'] = len(compliance_tests)
                    test_cases.extend(compliance_tests)
                    print_success(f"Generated {len(compliance_tests)} compliance test cases")
                    results['test_cases_count'] = len(test_cases)

                if verbose:
                    # Show gap breakdown
                    for framework, report in results['compliance_reports'].items():
                        print_info(f"{framework.upper()} gaps by category:")
                        for cat, count in report.get('gaps_by_category', {}).items():
                            print(f"        {cat}: {count}")

            except Exception as e:
                print_error(f"Compliance validation failed: {e}")
                results['errors'].append(f"Compliance error: {e}")
                # Continue without compliance - don't fail the whole pipeline

    # ========================================================================
    # STEP 4: GENERATE TRACEABILITY MATRIX
    # ========================================================================
    print_subheader("Step 4: Generating Traceability Matrix")

    try:
        traceability_matrix = generate_traceability_matrix(
            requirements=requirements,
            stories=stories,
            test_cases=test_cases
        )

        summary = traceability_matrix.get('summary', {})
        results['traceability'] = summary

        full_pct = summary.get('full_coverage_pct', 0)
        partial_pct = summary.get('partial_coverage_pct', 0)
        none_pct = summary.get('no_coverage_pct', 0)
        gap_count = summary.get('total_gaps', 0)

        print_success(f"Built traceability matrix")
        print_info(f"Coverage: {full_pct}% full, {partial_pct}% partial, {none_pct}% none")

        if gap_count > 0:
            print_warning(f"{gap_count} requirements have coverage gaps")

        if verbose:
            print_info("Coverage breakdown:")
            print(f"      • Full coverage: {summary.get('full_coverage_count', 0)} requirements")
            print(f"      • Partial coverage: {summary.get('partial_coverage_count', 0)} requirements")
            print(f"      • No coverage: {summary.get('no_coverage_count', 0)} requirements")

            # Show compliance test coverage
            compliance_coverage = summary.get('compliance_coverage', {})
            if any(c.get('tests', 0) > 0 for c in compliance_coverage.values()):
                print_info("Compliance test coverage:")
                for framework, stats in compliance_coverage.items():
                    tests = stats.get('tests', 0)
                    if tests > 0:
                        print(f"      • {framework}: {tests} tests")

    except Exception as e:
        print_error(f"Failed to generate traceability matrix: {e}")
        results['errors'].append(f"Traceability error: {e}")
        traceability_matrix = None
        # Continue without traceability - don't fail the whole pipeline

    # ========================================================================
    # STEP 5: EXPORT OUTPUT
    # ========================================================================
    print_subheader("Step 5: Exporting Output")

    # Create base filename from input
    base_name = os.path.splitext(source_filename)[0]
    timestamp = datetime.now().strftime("%Y%m%d_%H%M")

    # Ensure output directories exist
    github_dir = os.path.join(output_dir, 'github')
    excel_dir = os.path.join(output_dir, 'excel')
    os.makedirs(github_dir, exist_ok=True)
    os.makedirs(excel_dir, exist_ok=True)

    # Export to Markdown (no traceability matrix - use Excel for RTM)
    if output_format in ['markdown', 'both']:
        try:
            md_filename = f"{base_name}_{timestamp}.md"
            md_files = format_for_github(
                stories,
                test_cases,
                output_dir=github_dir,
                source_file=source_filename,
                mode='single',
                filename=md_filename
            )
            results['output_files'].extend(md_files)
            print_success(f"Created markdown: {md_files[0]}")

        except Exception as e:
            print_error(f"Failed to export markdown: {e}")
            results['errors'].append(f"Markdown export error: {e}")

    # Export to Excel
    if output_format in ['excel', 'both']:
        try:
            excel_filename = f"{base_name}_{timestamp}.xlsx"
            excel_path = export_to_excel(
                stories,
                test_cases,
                output_dir=excel_dir,
                source_file=source_filename,
                filename=excel_filename,
                traceability_matrix=traceability_matrix
            )
            results['output_files'].append(excel_path)
            print_success(f"Created Excel: {excel_path}")

        except Exception as e:
            print_error(f"Failed to export Excel: {e}")
            results['errors'].append(f"Excel export error: {e}")

    # ========================================================================
    # DONE
    # ========================================================================
    results['success'] = len(results['errors']) == 0

    return results


# ============================================================================
# MAIN ENTRY POINT
# ============================================================================

def main():
    """
    PURPOSE:
        Main entry point - parse arguments and run the pipeline.

    R EQUIVALENT:
        # In R, you'd have this at the end of the script:
        # if (interactive() == FALSE) {
        #     main()
        # }

    WHY THIS APPROACH:
        Separating main() allows the module to be imported without
        auto-executing, which is useful for testing.
    """
    # Print banner
    print_header("Requirements Toolkit")
    print("  Transform messy requirements into user stories & UAT test cases")

    # Parse command-line arguments
    args = parse_arguments()

    # Show configuration
    print_subheader("Configuration")
    print_stat("Input file", args.input_file)
    print_stat("Test ID prefix", args.prefix)
    print_stat("Output format", args.output)
    if args.sheet:
        print_stat("Sheet", args.sheet)
    print_stat("Output directory", args.output_dir)
    if args.compliance != 'none':
        compliance_names = {
            'part11': 'FDA 21 CFR Part 11',
            'hipaa': 'HIPAA Security Rule',
            'soc2': 'SOC 2 TSC',
            'all': 'Part 11 + HIPAA + SOC 2'
        }
        print_stat("Compliance", compliance_names.get(args.compliance, args.compliance))

    # Validate input file
    try:
        validate_input_file(args.input_file)
        print_success(f"Input file validated")
    except FileNotFoundError as e:
        print_error(str(e))
        print()
        print("Please check the file path and try again.")
        sys.exit(1)
    except ValueError as e:
        print_error(str(e))
        sys.exit(1)

    # Run the pipeline
    results = run_pipeline(
        input_file=args.input_file,
        prefix=args.prefix,
        output_format=args.output,
        sheet_name=args.sheet,
        output_dir=args.output_dir,
        verbose=args.verbose,
        compliance=args.compliance
    )

    # Print summary
    print_header("Summary")

    if results['success']:
        print_success("Pipeline completed successfully!")
        print()
        print_stat("Requirements parsed", results['requirements_count'])
        print_stat("User stories generated", results['stories_count'])
        print_stat("UAT test cases created", results['test_cases_count'])

        # Show compliance results
        if results['compliance_tests_count'] > 0:
            print_stat("Compliance test cases", results['compliance_tests_count'])

        if results['compliance_reports']:
            print()
            print("Compliance Summary:")
            for framework, report in results['compliance_reports'].items():
                score = report['summary']['compliance_score']
                gaps = report['summary']['requirements_with_gaps']
                print(f"    • {framework.upper()}: {score}% compliant ({gaps} requirements with gaps)")

        # Show traceability summary
        if results['traceability']:
            rtm = results['traceability']
            print()
            print("Traceability Summary:")
            print(f"    • Full coverage: {rtm.get('full_coverage_count', 0)} requirements ({rtm.get('full_coverage_pct', 0)}%)")
            print(f"    • Partial coverage: {rtm.get('partial_coverage_count', 0)} requirements ({rtm.get('partial_coverage_pct', 0)}%)")
            print(f"    • No coverage: {rtm.get('no_coverage_count', 0)} requirements ({rtm.get('no_coverage_pct', 0)}%)")
            if rtm.get('total_gaps', 0) > 0:
                print(f"    • {rtm.get('total_gaps', 0)} requirements have identified gaps")

        if results['flagged_items'] > 0:
            print()
            print_warning(f"{results['flagged_items']} items flagged for review")

        print()
        print("Output files:")
        for filepath in results['output_files']:
            print(f"    • {filepath}")

        print()
        print("Next steps:")
        print("    1. Review the generated user stories for accuracy")
        print("    2. Check the Traceability Matrix for coverage gaps")
        print("    3. Refine any flagged items that need attention")
        print("    4. Import to your project management tool or share with stakeholders")

    else:
        print_error("Pipeline completed with errors")
        print()
        for error in results['errors']:
            print(f"    • {error}")
        print()
        print("Please resolve the errors and try again.")
        sys.exit(1)

    print()


# ============================================================================
# SCRIPT EXECUTION
# ============================================================================
# WHY: This pattern allows the file to be both imported as a module
# and executed directly as a script.
# R EQUIVALENT: Like having main code inside if(!interactive()) { ... }

if __name__ == "__main__":
    main()
