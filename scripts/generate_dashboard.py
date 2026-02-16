#!/usr/bin/env python3
"""
Generate Requirements Dashboard from Supabase
===============================================
PURPOSE: Generate a static HTML requirements dashboard from Supabase data
         and write it to docs/index.html for GitHub Pages hosting.

REPLACES: propel_mcp/server.py::generate_requirements_dashboard() which reads
          from SQLite. This script reads from Supabase instead.

USAGE:
    # Local generation (writes to docs/index.html)
    python3 scripts/generate_dashboard.py

    # Specify output path
    python3 scripts/generate_dashboard.py --output /path/to/output.html

    # Push to GitHub after generation
    python3 scripts/generate_dashboard.py --push

    # Use SQLite as source (fallback)
    python3 scripts/generate_dashboard.py --source sqlite

ENVIRONMENT:
    SUPABASE_URL        - Supabase project URL
    SUPABASE_ANON_KEY   - Supabase anon key (for read-only dashboard data)
"""

import os
import re
import sys
import json
import argparse
import subprocess
import importlib.util
from datetime import datetime
from pathlib import Path
from typing import Optional


# ---------------------------------------------------------------------------
# CONSTANTS
# ---------------------------------------------------------------------------

REQUIREMENTS_TOOLKIT_VERSION = "1.1.0"
DASHBOARD_TEMPLATE_VERSION = "1.0"

# Programs excluded from stakeholder dashboard
EXCLUDED_PROGRAMS = {"TEST2", "FRESH", "IMPORT", "P4ME"}

# User-friendly display names for program prefixes
PROGRAM_DISPLAY_NAMES = {
    "P4M": "Prevention4ME",
    "DIS": "Discover",
    "PLAT": "Platform",
    "ONB": "Onboarding",
}

# Category display info with icons and CSS classes
CATEGORY_INFO = {
    "REFERRAL": {"icon": "\U0001f4cb", "title": "Referral Workflow", "css": "referral"},
    "ANALYTICS": {"icon": "\U0001f4ca", "title": "Analytics", "css": "analytics"},
    "DASH": {"icon": "\U0001f5a5\ufe0f", "title": "Dashboard", "css": "dash"},
    "CONFIG": {"icon": "\u2699\ufe0f", "title": "Configuration", "css": "config"},
    "AUDIT": {"icon": "\U0001f512", "title": "Compliance (Part 11)", "css": "audit"},
    "RECORD": {"icon": "\U0001f512", "title": "Compliance (Part 11)", "css": "audit"},
    "ROLE": {"icon": "\U0001f464", "title": "Roles & Permissions", "css": "role"},
    "ADMIN": {"icon": "\u2699\ufe0f", "title": "Administration", "css": "config"},
    "EXPORT": {"icon": "\U0001f4e4", "title": "Export & Download", "css": "analytics"},
    "FORM": {"icon": "\U0001f4dd", "title": "Form Management", "css": "referral"},
    "GENE": {"icon": "\U0001f9ec", "title": "Genetic Testing", "css": "dash"},
    "SAVE": {"icon": "\U0001f4be", "title": "Save & Draft", "css": "config"},
    "STEP": {"icon": "\U0001f4cb", "title": "Workflow Steps", "css": "referral"},
    "UI": {"icon": "\U0001f3a8", "title": "User Interface", "css": "dash"},
    "RECRUIT": {"icon": "\U0001f465", "title": "Patient Recruitment", "css": "referral"},
    "RPT": {"icon": "\U0001f4d1", "title": "Reports", "css": "analytics"},
    "UNCATEGORIZED": {"icon": "\U0001f4c1", "title": "Other", "css": "other"},
}

# Preferred category display order
PREFERRED_CATEGORY_ORDER = [
    "REFERRAL", "ANALYTICS", "DASH", "CONFIG", "COMPLIANCE", "ROLE",
    "RECRUIT", "STEP", "FORM", "ADMIN", "GENE", "SAVE", "EXPORT", "UI",
    "RPT", "UNCATEGORIZED"
]


# ---------------------------------------------------------------------------
# HTML HELPERS
# ---------------------------------------------------------------------------

def escape_html(text: str) -> str:
    """Escape HTML special characters for safe embedding."""
    if not text:
        return ""
    return (text
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
        .replace("'", "&#39;"))


def get_display_priority(roadmap_target, db_priority):
    """
    Centralized priority display logic.
    Rules:
        1. No roadmap_target -> "Not Assigned"
        2. Has roadmap_target + has priority -> show actual priority
        3. Has roadmap_target + no priority -> default "Should Have"
    """
    if not roadmap_target or (isinstance(roadmap_target, str) and roadmap_target.strip() == ""):
        return ("Not Assigned", "not-assigned")
    if db_priority and (isinstance(db_priority, str) and db_priority.strip()):
        css_class = db_priority.lower().replace(" ", "-")
        return (db_priority, css_class)
    return ("Should Have", "should-have")


def format_short_date(date_str):
    """Format a date string to short M/D/YY form."""
    if not date_str:
        return None
    try:
        dt = datetime.strptime(str(date_str)[:10], '%Y-%m-%d')
        return dt.strftime('%-m/%-d/%y')
    except Exception:
        return str(date_str)[:8] if date_str else None


# ---------------------------------------------------------------------------
# DATA SOURCE: SUPABASE
# ---------------------------------------------------------------------------

def fetch_from_supabase(url: str, key: str) -> tuple:
    """
    Fetch stories and test counts from Supabase.

    RETURNS:
        (stories, test_counts) where:
            stories: list of dicts with story + program data
            test_counts: dict of story_id -> test_count
    """
    from supabase import create_client

    client = create_client(url, key)

    # Query stories with program info
    stories_resp = client.table("user_stories").select(
        "story_id, title, user_story, acceptance_criteria, "
        "status, priority, category, version, roadmap_target, "
        "draft_date, internal_review_date, client_review_date, "
        "approved_at, needs_discussion_date, uat_date, complete_date, "
        "programs(prefix, name)"
    ).execute()

    # Flatten the joined program data
    stories = []
    for row in stories_resp.data:
        program = row.get("programs") or {}
        prefix = program.get("prefix", "")
        if prefix in EXCLUDED_PROGRAMS:
            continue
        stories.append({
            "story_id": row["story_id"],
            "title": row.get("title", ""),
            "user_story": row.get("user_story", ""),
            "acceptance_criteria": row.get("acceptance_criteria", ""),
            "status": row.get("status", "Draft"),
            "priority": row.get("priority"),
            "category": row.get("category"),
            "version": row.get("version", 1),
            "roadmap_target": row.get("roadmap_target"),
            "draft_date": row.get("draft_date"),
            "internal_review_date": row.get("internal_review_date"),
            "client_review_date": row.get("client_review_date"),
            "approved_date": row.get("approved_at"),
            "needs_discussion_date": row.get("needs_discussion_date"),
            "uat_date": row.get("uat_date"),
            "complete_date": row.get("complete_date"),
            "prefix": prefix,
            "program_name": program.get("name", ""),
        })

    # Sort by prefix, category, story_id
    stories.sort(key=lambda s: (s["prefix"], s.get("category") or "", s["story_id"]))

    # Get test counts per story (exclude compliance tests)
    tests_resp = client.rpc("get_test_counts_by_story", {}).execute()
    if tests_resp.data:
        test_counts = {row["story_id"]: row["test_count"] for row in tests_resp.data}
    else:
        # Fallback: query directly
        tests_resp = client.table("uat_test_cases").select(
            "story_id"
        ).eq("is_compliance_test", False).execute()
        test_counts = {}
        for row in tests_resp.data:
            sid = row.get("story_id")
            if sid:
                test_counts[sid] = test_counts.get(sid, 0) + 1

    return stories, test_counts


# ---------------------------------------------------------------------------
# DATA SOURCE: SQLITE (fallback)
# ---------------------------------------------------------------------------

def fetch_from_sqlite(db_path: str = None) -> tuple:
    """Fetch stories and test counts from SQLite (fallback source)."""
    import sqlite3

    if db_path is None:
        db_path = str(Path.home() / "projects" / "data" / "client_product_database.db")

    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row

    cursor = conn.execute("""
        SELECT s.story_id, s.title, s.user_story, s.acceptance_criteria,
               s.status, s.priority, s.category, s.version,
               s.roadmap_target, s.draft_date, s.internal_review_date,
               s.client_review_date, s.approved_date, s.needs_discussion_date,
               s.uat_date, s.complete_date,
               p.prefix, p.name as program_name
        FROM user_stories s
        JOIN programs p ON s.program_id = p.program_id
        ORDER BY p.prefix, s.category, s.story_id
    """)

    stories = []
    for row in cursor.fetchall():
        row_dict = dict(row)
        if row_dict["prefix"] in EXCLUDED_PROGRAMS:
            continue
        stories.append(row_dict)

    cursor = conn.execute("""
        SELECT story_id, COUNT(*) as test_count
        FROM uat_test_cases
        WHERE is_compliance_test = FALSE OR is_compliance_test IS NULL
        GROUP BY story_id
    """)
    test_counts = {row["story_id"]: row["test_count"] for row in cursor.fetchall()}

    conn.close()
    return stories, test_counts


# ---------------------------------------------------------------------------
# HTML GENERATION
# ---------------------------------------------------------------------------

def try_load_template_function():
    """
    Try to import generate_full_html_template from propel_mcp/server.py.
    Returns the function if found, None otherwise.
    """
    server_path = Path.home() / "projects" / "propel_mcp" / "server.py"
    if not server_path.exists():
        return None

    try:
        # Read just the function source from the file to avoid importing
        # the entire 16000-line MCP server with all its dependencies
        source = server_path.read_text()

        # Find the function definition
        start_marker = "def generate_full_html_template("
        start_idx = source.find(start_marker)
        if start_idx == -1:
            return None

        # Find the end of the function (next def at same indent level or end of file)
        # The function returns a triple-quoted f-string ending with '''
        # Find the closing ''' after the template
        end_marker = "\ndef validate_dashboard_structure"
        end_idx = source.find(end_marker, start_idx)
        if end_idx == -1:
            end_idx = len(source)

        func_source = source[start_idx:end_idx]

        # Need the REQUIREMENTS_TOOLKIT_VERSION constant
        func_source = f"REQUIREMENTS_TOOLKIT_VERSION = '{REQUIREMENTS_TOOLKIT_VERSION}'\n\n" + func_source

        # Compile and execute
        code = compile(func_source, str(server_path), "exec")
        namespace = {}
        exec(code, namespace)

        return namespace.get("generate_full_html_template")
    except Exception as e:
        print(f"  Warning: Could not load template from propel_mcp: {e}")
        return None


def generate_html(stories: list, test_counts: dict) -> str:
    """
    Generate the complete HTML dashboard from story data.

    This mirrors the logic in propel_mcp/server.py::generate_requirements_dashboard()
    but works with pre-fetched data from any source.
    """
    if not stories:
        return "<html><body><h1>No stories found</h1></body></html>"

    today = datetime.now().strftime("%B %d, %Y")
    current_year = datetime.now().year
    next_year = current_year + 1
    beyond_year = next_year + 1

    total_stories = len(stories)
    total_tests = sum(test_counts.get(s["story_id"], 0) for s in stories)

    # Count by priority
    priority_counts = {"Must Have": 0, "Should Have": 0, "Could Have": 0, "Won't Have": 0, "Not Assigned": 0}
    for story in stories:
        p = story.get("priority")
        if not p or p == "":
            priority_counts["Not Assigned"] += 1
        elif p in priority_counts:
            priority_counts[p] += 1

    # Count by roadmap target
    roadmap_counts = {}
    for year in [current_year, next_year]:
        for q in range(1, 5):
            roadmap_counts[f"Q{q} {year}"] = 0
    roadmap_counts[f"{beyond_year}+"] = 0
    roadmap_counts["Backlog"] = 0
    roadmap_counts["Unscheduled"] = 0
    for story in stories:
        rt = story.get("roadmap_target")
        if not rt or rt == "":
            roadmap_counts["Unscheduled"] += 1
        elif rt in roadmap_counts:
            roadmap_counts[rt] += 1
        else:
            roadmap_counts["Unscheduled"] += 1

    # Count by program
    program_counts = {}
    program_test_counts = {}
    for story in stories:
        prefix = story["prefix"]
        if prefix not in program_counts:
            program_counts[prefix] = 0
            program_test_counts[prefix] = 0
        program_counts[prefix] += 1
        program_test_counts[prefix] += test_counts.get(story["story_id"], 0)

    # Group stories by category
    categories = {}
    for story in stories:
        cat = story.get("category") or "UNCATEGORIZED"
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(story)

    # Merge AUDIT and RECORD into COMPLIANCE
    if "AUDIT" in categories and "RECORD" in categories:
        categories["COMPLIANCE"] = categories.pop("AUDIT", []) + categories.pop("RECORD", [])
    elif "AUDIT" in categories:
        categories["COMPLIANCE"] = categories.pop("AUDIT")
    elif "RECORD" in categories:
        categories["COMPLIANCE"] = categories.pop("RECORD")

    # Build program summary cards HTML
    program_cards_html = ""
    for prefix, count in program_counts.items():
        display_name = PROGRAM_DISPLAY_NAMES.get(prefix, prefix)
        program_cards_html += f"""
            <div class="summary-card">
                <div class="summary-card-label">{display_name}</div>
                <div class="summary-card-value">{count}</div>
                <div class="summary-card-sub">{program_test_counts[prefix]} test cases</div>
            </div>
        """

    # Build program filter buttons
    program_filters_html = '<button class="filter-btn active" data-filter="all">All Programs</button>'
    for prefix, count in program_counts.items():
        display_name = PROGRAM_DISPLAY_NAMES.get(prefix, prefix)
        program_filters_html += f'<button class="filter-btn {prefix.lower()}" data-filter="{prefix.lower()}">{display_name} ({count})</button>'

    # Build category sections
    categories_html = ""
    category_order = [cat for cat in PREFERRED_CATEGORY_ORDER if cat in categories]
    for cat in sorted(categories.keys()):
        if cat not in category_order:
            if "UNCATEGORIZED" in category_order:
                idx = category_order.index("UNCATEGORIZED")
                category_order.insert(idx, cat)
            else:
                category_order.append(cat)

    for cat_key in category_order:
        if cat_key not in categories:
            continue

        cat_stories = categories[cat_key]
        info = CATEGORY_INFO.get(cat_key, CATEGORY_INFO["UNCATEGORIZED"])
        if cat_key == "COMPLIANCE":
            info = {"icon": "\U0001f512", "title": "Compliance (Part 11)", "css": "audit"}

        stories_html = ""
        for story in cat_stories:
            story_id = story["story_id"]
            title = story.get("title", "")
            user_story = story.get("user_story", "")
            acceptance_criteria = story.get("acceptance_criteria", "")
            status = story.get("status", "Draft")
            priority = story.get("priority")
            version = story.get("version", 1)
            prefix = story["prefix"]
            roadmap_target = story.get("roadmap_target")

            # Parse acceptance criteria
            ac_html = ""
            if acceptance_criteria:
                lines = acceptance_criteria.strip().split('\n')
                for line in lines:
                    line = line.strip()
                    if line and not line.isdigit():
                        line = re.sub(r'^\d+[\.\)]\s*', '', line)
                        if line:
                            ac_html += f"<li>{escape_html(line)}</li>"

            test_count = test_counts.get(story_id, 0)
            priority_display, priority_class = get_display_priority(roadmap_target, priority)

            # Roadmap badge
            roadmap_display = "Unscheduled"
            roadmap_class = "unscheduled"
            if roadmap_target:
                roadmap_display = roadmap_target.replace(" 2025", " '25").replace(" 2026", " '26").replace(" 2027", " '27")
                roadmap_class = roadmap_target.lower().replace(" ", "-").replace("+", "-plus")

            # Status timeline
            timeline_stages = [
                ("Draft", story.get("draft_date"), status == "Draft"),
                ("Internal Review", story.get("internal_review_date"), status == "Internal Review"),
                ("Client Review", story.get("client_review_date"), status == "Pending Client Review"),
                ("Approved", story.get("approved_date"), status == "Approved"),
                ("UAT", story.get("uat_date"), status == "UAT"),
                ("Complete", story.get("complete_date"), status == "Complete"),
            ]
            if story.get("needs_discussion_date"):
                timeline_stages.append(("Discussion", story["needs_discussion_date"], status == "Needs Discussion"))

            timeline_html = '<div class="status-timeline">'
            for i, (stage_name, stage_date, is_current) in enumerate(timeline_stages):
                formatted_date = format_short_date(stage_date)
                has_date = formatted_date is not None
                stage_class = "completed" if has_date else "pending"
                if is_current:
                    stage_class = "current"
                timeline_html += f'''
                    <div class="timeline-stage {stage_class}">
                        <div class="timeline-dot"></div>
                        <div class="timeline-label">{stage_name}</div>
                        <div class="timeline-date">{formatted_date if formatted_date else '-'}</div>
                    </div>
                '''
                if i < len(timeline_stages) - 1:
                    timeline_html += '<div class="timeline-connector"></div>'
            timeline_html += '</div>'

            # Filter data attributes
            roadmap_filter = roadmap_target.lower().replace(" ", "-").replace("+", "-plus") if roadmap_target else "unscheduled"
            status_filter = status.lower().replace(" ", "-") if status else "draft"

            if status == "UAT":
                status_badge_class = "badge-status-uat"
            elif status == "Complete":
                status_badge_class = "badge-status-complete"
            else:
                status_badge_class = "badge-status"

            stories_html += f"""
                <article class="story-card" data-program="{prefix.lower()}" data-priority="{priority_class}" data-roadmap="{roadmap_filter}" data-status="{status_filter}" data-search="{title.lower()} {user_story.lower() if user_story else ''}">
                    <div class="story-header" onclick="toggleStory(this)">
                        <div>
                            <span class="story-id {prefix.lower()}">{story_id}</span>
                            <h3 class="story-title">{escape_html(title)}</h3>
                            <div class="story-meta">
                                <span class="badge badge-{priority_class}">{priority_display}</span>
                                <span class="badge badge-roadmap badge-{roadmap_class}">{roadmap_display}</span>
                                <span class="badge {status_badge_class}">{status} v{version}</span>
                            </div>
                        </div>
                        <svg class="story-toggle" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </div>
                    <div class="story-body">
                        <div class="story-section">
                            <h4 class="story-section-title">Status Timeline</h4>
                            {timeline_html}
                        </div>
                        <div class="story-section">
                            <h4 class="story-section-title">User Story</h4>
                            <p class="user-story">{escape_html(user_story) if user_story else 'No user story defined.'}</p>
                        </div>
                        <div class="story-section">
                            <h4 class="story-section-title">Acceptance Criteria</h4>
                            <ol class="acceptance-criteria">
                                {ac_html if ac_html else '<li>No acceptance criteria defined.</li>'}
                            </ol>
                        </div>
                        <div class="test-count">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                            {test_count} test case{'s' if test_count != 1 else ''}
                        </div>
                    </div>
                </article>
            """

        categories_html += f"""
            <section class="category-section" data-category="{cat_key.lower()}">
                <div class="category-header">
                    <div class="category-icon {info['css']}">{info['icon']}</div>
                    <h2 class="category-title">{info['title']}</h2>
                    <span class="category-count">{len(cat_stories)} stor{'y' if len(cat_stories) == 1 else 'ies'}</span>
                </div>
                <div class="stories-grid">
                    {stories_html}
                </div>
            </section>
        """

    # Try to load the frozen template from propel_mcp
    template_fn = try_load_template_function()
    if template_fn:
        print("  Using template from propel_mcp/server.py")
        return template_fn(
            total_stories=total_stories,
            total_tests=total_tests,
            program_cards_html=program_cards_html,
            program_filters_html=program_filters_html,
            categories_html=categories_html,
            priority_counts=priority_counts,
            roadmap_counts=roadmap_counts,
            today=today,
        )

    # Fallback: use bundled template
    print("  Using bundled HTML template")
    return generate_bundled_template(
        total_stories=total_stories,
        total_tests=total_tests,
        program_cards_html=program_cards_html,
        program_filters_html=program_filters_html,
        categories_html=categories_html,
        priority_counts=priority_counts,
        roadmap_counts=roadmap_counts,
        today=today,
    )


def generate_bundled_template(
    total_stories, total_tests, program_cards_html, program_filters_html,
    categories_html, priority_counts, roadmap_counts, today
) -> str:
    """
    Bundled HTML template for use in GitHub Actions where propel_mcp is unavailable.
    This is a faithful reproduction of the frozen template v1.0 from propel_mcp/server.py.
    """
    current_year = datetime.now().year
    next_year = current_year + 1
    beyond_year = next_year + 1

    # Generate roadmap summary items
    roadmap_items_html = ""
    for year in [current_year, next_year]:
        year_short = str(year)[-2:]
        for q in range(1, 5):
            key = f"Q{q} {year}"
            label = f"Q{q} '{year_short}"
            count = roadmap_counts.get(key, 0)
            roadmap_items_html += f'''            <div class="roadmap-item">
                <div class="roadmap-item-label">{label}</div>
                <div class="roadmap-item-value">{count}</div>
            </div>\n'''
    beyond_count = roadmap_counts.get(f"{beyond_year}+", 0)
    roadmap_items_html += f'''            <div class="roadmap-item">
                <div class="roadmap-item-label">{beyond_year}+</div>
                <div class="roadmap-item-value">{beyond_count}</div>
            </div>\n'''
    backlog_count = roadmap_counts.get("Backlog", 0)
    unscheduled_count = roadmap_counts.get("Unscheduled", 0)
    roadmap_items_html += f'''            <div class="roadmap-item">
                <div class="roadmap-item-label">Backlog</div>
                <div class="roadmap-item-value">{backlog_count}</div>
            </div>
            <div class="roadmap-item">
                <div class="roadmap-item-label">Unscheduled</div>
                <div class="roadmap-item-value">{unscheduled_count}</div>
            </div>\n'''

    # Generate roadmap filter buttons
    roadmap_filters_html = ""
    for year in [current_year, next_year]:
        year_short = str(year)[-2:]
        for q in range(1, 5):
            data_value = f"q{q}-{year}"
            label = f"Q{q} '{year_short}"
            roadmap_filters_html += f'                    <button class="filter-btn" data-roadmap="{data_value}">{label}</button>\n'
    roadmap_filters_html += f'                    <button class="filter-btn" data-roadmap="{beyond_year}-plus">{beyond_year}+</button>\n'
    roadmap_filters_html += '                    <button class="filter-btn" data-roadmap="backlog">Backlog</button>\n'
    roadmap_filters_html += '                    <button class="filter-btn" data-roadmap="unscheduled">Unscheduled</button>'

    # The complete HTML template — matches propel_mcp/server.py generate_full_html_template v1.0
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Providence Health | GenomicsNow Requirements Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {{
            --providence-navy: #041E4F; --providence-green: #39892F; --providence-accent: #C2987F; --providence-light: #F5F5F5;
            --color-bg: #f8fafb; --color-surface: #ffffff; --color-border: #e2e8f0; --color-border-light: #f1f5f9;
            --color-text: #1e293b; --color-text-secondary: #64748b; --color-text-muted: #94a3b8;
            --color-primary: var(--providence-green); --color-primary-light: #dcfce7; --color-primary-dark: #2d6b25;
            --color-accent: var(--providence-accent); --color-accent-light: #fdf4ef;
            --color-must-have: #dc2626; --color-must-have-bg: #fee2e2;
            --color-should-have: var(--providence-green); --color-should-have-bg: #dcfce7;
            --color-could-have: #d97706; --color-could-have-bg: #fef3c7;
            --color-draft: #6366f1; --color-draft-bg: #e0e7ff;
            --color-p4m: var(--providence-green); --color-p4m-light: #dcfce7;
            --color-plat: #7c3aed; --color-plat-light: #ede9fe;
            --shadow-sm: 0 1px 2px rgba(0,0,0,0.04); --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -2px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.05), 0 4px 6px -4px rgba(0,0,0,0.05);
            --radius-sm: 6px; --radius-md: 10px; --radius-lg: 16px;
        }}
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif; background: var(--color-bg); color: var(--color-text); line-height: 1.6; font-size: 15px; }}
        .header {{ background: var(--providence-navy); color: white; padding: 2.5rem 2rem; position: relative; overflow: hidden; }}
        .header::before {{ content: ''; position: absolute; top: -50%; right: -10%; width: 500px; height: 500px; background: radial-gradient(circle, rgba(57,137,47,0.15) 0%, transparent 70%); border-radius: 50%; }}
        .header-content {{ max-width: 1400px; margin: 0 auto; position: relative; z-index: 1; }}
        .header-badge {{ display: inline-flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.12); padding: 0.4rem 0.9rem; border-radius: 100px; font-size: 0.8rem; font-weight: 500; margin-bottom: 0.75rem; }}
        .header h1 {{ font-size: 2rem; font-weight: 700; margin-bottom: 0.4rem; }}
        .header p {{ opacity: 0.85; font-size: 1rem; }}
        .header-meta {{ display: flex; gap: 2rem; margin-top: 1.25rem; flex-wrap: wrap; }}
        .header-meta-item {{ display: flex; flex-direction: column; }}
        .header-meta-label {{ font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.05em; opacity: 0.6; }}
        .header-meta-value {{ font-weight: 600; font-size: 0.95rem; }}
        .main {{ max-width: 1400px; margin: 0 auto; padding: 2rem; }}
        .summary-grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 1rem; margin-bottom: 2rem; }}
        .summary-card {{ background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 1rem; box-shadow: var(--shadow-sm); }}
        .summary-card-label {{ font-size: 0.75rem; color: var(--color-text-secondary); }}
        .summary-card-value {{ font-size: 1.5rem; font-weight: 700; color: var(--color-primary); }}
        .summary-card-sub {{ font-size: 0.7rem; color: var(--color-text-muted); }}
        .filter-row {{ display: flex; align-items: flex-start; gap: 0.75rem; margin-bottom: 0.75rem; }}
        .filter-row:last-child {{ margin-bottom: 0; }}
        .filter-row-label {{ font-size: 0.75rem; font-weight: 600; color: var(--color-text-secondary); min-width: 70px; padding-top: 0.5rem; text-transform: uppercase; letter-spacing: 0.03em; }}
        .filter-pills {{ display: flex; flex-wrap: wrap; gap: 0.5rem; flex: 1; }}
        .filter-btn {{ padding: 0.5rem 1rem; border: 1px solid var(--color-border); background: var(--color-surface); border-radius: 100px; font-family: inherit; font-size: 0.85rem; font-weight: 500; color: var(--color-text-secondary); cursor: pointer; transition: all 0.15s ease; }}
        .filter-btn:hover {{ border-color: var(--color-primary); color: var(--color-primary); }}
        .filter-btn.active {{ background: var(--color-primary); border-color: var(--color-primary); color: white; }}
        .filter-btn.p4m.active {{ background: var(--color-p4m); border-color: var(--color-p4m); }}
        .filter-btn.plat.active {{ background: var(--color-plat); border-color: var(--color-plat); }}
        .search-box input {{ width: 100%; padding: 0.5rem 1rem 0.5rem 2.5rem; border: 1px solid var(--color-border); border-radius: 100px; font-family: inherit; font-size: 0.85rem; }}
        .search-box input:focus {{ outline: none; border-color: var(--color-primary); }}
        .search-box {{ position: relative; }}
        .search-box svg {{ position: absolute; left: 0.85rem; top: 50%; transform: translateY(-50%); color: var(--color-text-muted); }}
        .category-section {{ margin-bottom: 2rem; }}
        .category-header {{ display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid var(--color-border); }}
        .category-icon {{ width: 32px; height: 32px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 0.9rem; }}
        .category-icon.analytics {{ background: #dbeafe; }} .category-icon.audit {{ background: #fce7f3; }} .category-icon.config {{ background: #fef3c7; }}
        .category-icon.dash {{ background: #d1fae5; }} .category-icon.referral {{ background: #ccfbf1; }} .category-icon.role {{ background: #fae8ff; }}
        .category-title {{ font-size: 1.1rem; font-weight: 600; }} .category-count {{ font-size: 0.8rem; color: var(--color-text-muted); margin-left: auto; }}
        .stories-grid {{ display: grid; gap: 1rem; }}
        .story-card {{ background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden; }}
        .story-card:hover {{ box-shadow: var(--shadow-md); }} .story-card.hidden {{ display: none; }}
        .story-header {{ padding: 1.25rem; display: flex; justify-content: space-between; align-items: flex-start; gap: 1rem; cursor: pointer; }}
        .story-header:hover {{ background: var(--color-bg); }}
        .story-id {{ font-family: 'JetBrains Mono', monospace; font-size: 0.75rem; font-weight: 500; padding: 0.2rem 0.5rem; border-radius: var(--radius-sm); margin-bottom: 0.4rem; display: inline-block; }}
        .story-id.p4m {{ background: var(--color-p4m-light); color: var(--color-p4m); }}
        .story-id.plat {{ background: var(--color-plat-light); color: var(--color-plat); }}
        .story-title {{ font-size: 1.05rem; font-weight: 600; margin-bottom: 0.25rem; }}
        .story-meta {{ display: flex; gap: 0.5rem; flex-wrap: wrap; }}
        .badge {{ font-size: 0.65rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.03em; padding: 0.25rem 0.5rem; border-radius: 100px; }}
        .badge-must-have {{ background: var(--color-must-have-bg); color: var(--color-must-have); }}
        .badge-should-have {{ background: var(--color-should-have-bg); color: var(--color-should-have); }}
        .badge-could-have {{ background: var(--color-could-have-bg); color: var(--color-could-have); }}
        .badge-not-assigned {{ background: #9CA3AF; color: white; }}
        .badge-status {{ background: var(--color-draft-bg); color: var(--color-draft); }}
        .badge-status-uat {{ background: #fef3c7; color: #d97706; }}
        .badge-status-complete {{ background: #d1fae5; color: #047857; }}
        .badge-roadmap {{ background: #e0f2fe; color: #0369a1; font-weight: 600; }}
        .badge-q1-2025 {{ background: #ccfbf1; color: #0d9488; }} .badge-q2-2025 {{ background: #cffafe; color: #0891b2; }}
        .badge-q3-2025 {{ background: #a5f3fc; color: #0e7490; }} .badge-q4-2025 {{ background: #99f6e4; color: #0f766e; }}
        .badge-q1-2026 {{ background: #dbeafe; color: #1e40af; }} .badge-q2-2026 {{ background: #c7d2fe; color: #4338ca; }}
        .badge-q3-2026 {{ background: #e0e7ff; color: #4f46e5; }} .badge-q4-2026 {{ background: #ede9fe; color: #6d28d9; }}
        .badge-2027-plus {{ background: #fae8ff; color: #a21caf; }}
        .badge-backlog {{ background: #f1f5f9; color: #64748b; }} .badge-unscheduled {{ background: #f1f5f9; color: #94a3b8; }}
        .story-toggle {{ color: var(--color-text-muted); transition: transform 0.2s; }}
        .story-card.open .story-toggle {{ transform: rotate(180deg); }}
        .story-body {{ display: none; padding: 0 1.25rem 1.25rem; border-top: 1px solid var(--color-border-light); }}
        .story-card.open .story-body {{ display: block; }}
        .story-section {{ margin-top: 1rem; }}
        .story-section-title {{ font-size: 0.7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--color-text-muted); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.4rem; }}
        .story-section-title::before {{ content: ''; width: 3px; height: 12px; background: var(--color-primary); border-radius: 2px; }}
        .user-story {{ font-size: 0.95rem; background: linear-gradient(135deg, var(--color-primary-light) 0%, #f0fdfa 100%); padding: 0.9rem 1rem; border-radius: var(--radius-md); border-left: 3px solid var(--color-primary); font-style: italic; }}
        .acceptance-criteria {{ list-style: none; counter-reset: criteria; }}
        .acceptance-criteria li {{ counter-increment: criteria; display: flex; gap: 0.6rem; padding: 0.5rem 0; border-bottom: 1px solid var(--color-border-light); font-size: 0.9rem; }}
        .acceptance-criteria li:last-child {{ border-bottom: none; }}
        .acceptance-criteria li::before {{ content: counter(criteria); min-width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; background: var(--color-accent-light); color: var(--color-accent); border-radius: 50%; font-size: 0.7rem; font-weight: 600; }}
        .test-count {{ font-size: 0.8rem; color: var(--color-text-secondary); background: var(--color-bg); padding: 0.5rem 0.75rem; border-radius: var(--radius-sm); margin-top: 1rem; display: flex; align-items: center; gap: 0.5rem; }}
        .status-timeline {{ display: flex; align-items: flex-start; gap: 0; padding: 1rem 0.5rem; background: var(--color-bg); border-radius: var(--radius-md); overflow-x: auto; }}
        .timeline-stage {{ display: flex; flex-direction: column; align-items: center; min-width: 70px; text-align: center; }}
        .timeline-dot {{ width: 12px; height: 12px; border-radius: 50%; background: var(--color-border); border: 2px solid var(--color-border); margin-bottom: 0.4rem; }}
        .timeline-stage.completed .timeline-dot {{ background: var(--color-primary); border-color: var(--color-primary); }}
        .timeline-stage.current .timeline-dot {{ background: #fff; border-color: var(--color-primary); box-shadow: 0 0 0 3px var(--color-primary-light); }}
        .timeline-label {{ font-size: 0.65rem; font-weight: 600; color: var(--color-text-muted); text-transform: uppercase; letter-spacing: 0.02em; }}
        .timeline-stage.completed .timeline-label, .timeline-stage.current .timeline-label {{ color: var(--color-text); }}
        .timeline-date {{ font-size: 0.7rem; color: var(--color-text-muted); font-family: 'JetBrains Mono', monospace; }}
        .timeline-stage.completed .timeline-date, .timeline-stage.current .timeline-date {{ color: var(--color-primary); font-weight: 500; }}
        .timeline-connector {{ flex: 1; height: 2px; background: var(--color-border); margin-top: 5px; min-width: 20px; }}
        .section-title {{ font-size: 13px; font-weight: 600; color: var(--color-text-secondary); margin-bottom: 0.5rem; }}
        .priority-planning-container {{ background: #f9fafb; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 1.25rem; margin-bottom: 1.5rem; }}
        .priority-planning-container .section-title {{ margin-top: 0; }}
        .priority-planning-container .summary-grid {{ margin-bottom: 1rem; }}
        .filters-container {{ background: #f9fafb; border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 1.25rem; margin-bottom: 1.5rem; }}
        .filters-container .section-title {{ margin-top: 0; margin-bottom: 1rem; }}
        .roadmap-summary {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(80px, 1fr)); gap: 0.5rem; margin-top: 1rem; margin-bottom: 1.75rem; padding: 0.75rem; background: var(--color-surface); border: 1px solid var(--color-border-light); border-radius: var(--radius-sm); }}
        .roadmap-item {{ text-align: center; padding: 0.5rem; }}
        .roadmap-item-label {{ font-size: 0.7rem; font-weight: 600; color: var(--color-text-secondary); }}
        .roadmap-item-value {{ font-size: 1.25rem; font-weight: 700; color: var(--color-text); }}
        .footer {{ text-align: center; padding: 2rem; color: var(--color-text-muted); font-size: 0.85rem; border-top: 1px solid var(--color-border); margin-top: 2rem; }}
        .footer a {{ color: var(--color-primary); text-decoration: none; }}
        @media (max-width: 768px) {{ .header {{ padding: 1.5rem 1rem; }} .header h1 {{ font-size: 1.5rem; }} .main {{ padding: 1rem; }} .summary-grid {{ grid-template-columns: repeat(2, 1fr); }} }}
        @media print {{ .story-body {{ display: block !important; }} .filters {{ display: none; }} }}
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                <img src="https://cdn.providence.org/asset/GtV28qX0x6P0DfEBf7sJ7w10/project/psjh/providence/socal/images/logos/providence-logo-svg/svg" alt="Providence Health" style="height: 40px;">
                <div class="header-badge">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                    Requirements Dashboard
                </div>
            </div>
            <h1>GenomicsNow Requirements</h1>
            <p>User stories and acceptance criteria for all programs.</p>
            <div class="header-meta">
                <div class="header-meta-item"><span class="header-meta-label">Total Stories</span><span class="header-meta-value">{total_stories}</span></div>
                <div class="header-meta-item"><span class="header-meta-label">Test Cases</span><span class="header-meta-value">{total_tests}</span></div>
                <div class="header-meta-item"><span class="header-meta-label">Last Updated</span><span class="header-meta-value">{today}</span></div>
                <div class="header-meta-item"><span class="header-meta-label">Source</span><span class="header-meta-value">Supabase</span></div>
            </div>
        </div>
    </header>
    <main class="main">
        <div class="section-title">Programs</div>
        <div class="summary-grid" style="margin-bottom: 1.5rem;">{program_cards_html}</div>
        <div class="priority-planning-container">
            <div class="section-title">Priority Planning</div>
            <div class="section-title" style="font-size: 11px; margin-top: 0.75rem;">Priorities</div>
            <div class="summary-grid">
                <div class="summary-card"><div class="summary-card-label">Must Have</div><div class="summary-card-value">{priority_counts.get("Must Have", 0)}</div><div class="summary-card-sub">Critical priority</div></div>
                <div class="summary-card"><div class="summary-card-label">Should Have</div><div class="summary-card-value">{priority_counts.get("Should Have", 0)}</div><div class="summary-card-sub">High priority</div></div>
                <div class="summary-card"><div class="summary-card-label">Could Have</div><div class="summary-card-value">{priority_counts.get("Could Have", 0)}</div><div class="summary-card-sub">Future scope</div></div>
            </div>
            <div class="section-title" style="font-size: 11px; margin-top: 0.75rem;">Roadmap ({current_year}-{next_year})</div>
            <div class="roadmap-summary" style="margin-top: 0.5rem; margin-bottom: 0;">{roadmap_items_html}</div>
        </div>
        <div class="filters-container">
            <div class="section-title">Filters</div>
            <div class="filter-row"><span class="filter-row-label">Programs</span><div class="filter-pills">{program_filters_html}</div></div>
            <div class="filter-row"><span class="filter-row-label">Priorities</span><div class="filter-pills"><button class="filter-btn active" data-priority="all">All Priorities</button><button class="filter-btn" data-priority="must-have">Must Have</button><button class="filter-btn" data-priority="should-have">Should Have</button><button class="filter-btn" data-priority="could-have">Could Have</button><button class="filter-btn" data-priority="not-assigned">Not Assigned</button></div></div>
            <div class="filter-row"><span class="filter-row-label">Schedule</span><div class="filter-pills"><button class="filter-btn active" data-roadmap="all">All</button>{roadmap_filters_html}</div></div>
            <div class="filter-row"><span class="filter-row-label">Status</span><div class="filter-pills"><button class="filter-btn active" data-status="all">All Statuses</button><button class="filter-btn" data-status="draft">Draft</button><button class="filter-btn" data-status="internal-review">Internal Review</button><button class="filter-btn" data-status="pending-client-review">Pending Client Review</button><button class="filter-btn" data-status="approved">Approved</button><button class="filter-btn" data-status="uat">UAT</button><button class="filter-btn" data-status="complete">Complete</button><label style="display:flex;align-items:center;gap:0.4rem;margin-left:1rem;cursor:pointer;"><input type="checkbox" id="hideCompleted" style="cursor:pointer;"><span style="font-size:0.85rem;color:var(--color-text-secondary);">Hide Completed</span></label></div></div>
            <div class="filter-row"><span class="filter-row-label">Search</span><div class="search-box" style="flex:1;max-width:none;"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.35-4.35"></path></svg><input type="text" placeholder="Search stories..." id="searchInput"></div></div>
        </div>
        {categories_html}
    </main>
    <footer class="footer">
        <p style="color: var(--providence-navy); font-weight: 600;">Providence Health | GenomicsNow</p>
        <p style="margin-top: 0.5rem;">Requirements Toolkit v{REQUIREMENTS_TOOLKIT_VERSION}</p>
        <p style="margin-top: 0.25rem; font-size: 0.75rem;">Generated {today} | Source: Supabase</p>
    </footer>
    <script>
        function toggleStory(header) {{ header.closest('.story-card').classList.toggle('open'); }}
        document.querySelectorAll('.filter-btn[data-filter]').forEach(btn => {{ btn.addEventListener('click', () => {{ document.querySelectorAll('.filter-btn[data-filter]').forEach(b => b.classList.remove('active')); btn.classList.add('active'); filterStories(); }}); }});
        document.querySelectorAll('.filter-btn[data-priority]').forEach(btn => {{ btn.addEventListener('click', () => {{ document.querySelectorAll('.filter-btn[data-priority]').forEach(b => b.classList.remove('active')); btn.classList.add('active'); filterStories(); }}); }});
        document.querySelectorAll('.filter-btn[data-roadmap]').forEach(btn => {{ btn.addEventListener('click', () => {{ document.querySelectorAll('.filter-btn[data-roadmap]').forEach(b => b.classList.remove('active')); btn.classList.add('active'); filterStories(); }}); }});
        document.querySelectorAll('.filter-btn[data-status]').forEach(btn => {{ btn.addEventListener('click', () => {{ document.querySelectorAll('.filter-btn[data-status]').forEach(b => b.classList.remove('active')); btn.classList.add('active'); filterStories(); }}); }});
        document.getElementById('searchInput').addEventListener('input', filterStories);
        document.getElementById('hideCompleted').addEventListener('change', filterStories);
        function filterStories() {{
            const programFilter = document.querySelector('.filter-btn[data-filter].active')?.dataset.filter || 'all';
            const priorityFilter = document.querySelector('.filter-btn[data-priority].active')?.dataset.priority || 'all';
            const roadmapFilter = document.querySelector('.filter-btn[data-roadmap].active')?.dataset.roadmap || 'all';
            const statusFilter = document.querySelector('.filter-btn[data-status].active')?.dataset.status || 'all';
            const hideCompleted = document.getElementById('hideCompleted').checked;
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            document.querySelectorAll('.story-card').forEach(card => {{
                const program = card.dataset.program;
                const priority = card.dataset.priority;
                const roadmap = card.dataset.roadmap;
                const status = card.dataset.status;
                const searchText = card.dataset.search + ' ' + card.querySelector('.story-title').textContent.toLowerCase();
                const matchesProgram = programFilter === 'all' || program === programFilter;
                const matchesPriority = priorityFilter === 'all' || priority === priorityFilter;
                const matchesRoadmap = roadmapFilter === 'all' || roadmap === roadmapFilter;
                const matchesStatus = statusFilter === 'all' || status === statusFilter;
                const matchesHideCompleted = !hideCompleted || status !== 'complete';
                const matchesSearch = !searchTerm || searchText.includes(searchTerm);
                card.classList.toggle('hidden', !(matchesProgram && matchesPriority && matchesRoadmap && matchesStatus && matchesHideCompleted && matchesSearch));
            }});
            document.querySelectorAll('.category-section').forEach(section => {{
                const visibleStories = section.querySelectorAll('.story-card:not(.hidden)').length;
                section.querySelector('.category-count').textContent = visibleStories + ' stor' + (visibleStories === 1 ? 'y' : 'ies');
                section.style.display = visibleStories === 0 ? 'none' : 'block';
            }});
        }}
    </script>
</body>
</html>'''


# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="Generate requirements dashboard from Supabase")
    parser.add_argument("--output", type=str, help="Output HTML path (default: docs/index.html)")
    parser.add_argument("--push", action="store_true", help="Git commit and push after generation")
    parser.add_argument("--source", choices=["supabase", "sqlite"], default="supabase",
                        help="Data source (default: supabase)")
    parser.add_argument("--db", type=str, help="SQLite database path (for --source sqlite)")
    args = parser.parse_args()

    # Determine paths
    repo_path = Path(__file__).resolve().parent.parent
    output_path = Path(args.output) if args.output else repo_path / "docs" / "index.html"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"Generating dashboard from {args.source}...")

    # Fetch data
    if args.source == "supabase":
        try:
            from dotenv import load_dotenv
            load_dotenv()
        except ImportError:
            pass

        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_ANON_KEY") or os.environ.get("SUPABASE_SERVICE_KEY")
        if not url or not key:
            print("ERROR: Set SUPABASE_URL and SUPABASE_ANON_KEY environment variables.")
            sys.exit(1)

        stories, test_counts = fetch_from_supabase(url, key)
    else:
        stories, test_counts = fetch_from_sqlite(args.db)

    if not stories:
        print("ERROR: No stories found.")
        sys.exit(1)

    print(f"  Found {len(stories)} stories, {sum(test_counts.values())} test cases")

    # Generate HTML
    html = generate_html(stories, test_counts)

    # Write file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)
    print(f"  Written to: {output_path}")

    # Push to GitHub
    if args.push:
        try:
            original_dir = os.getcwd()
            os.chdir(repo_path)
            subprocess.run(["git", "pull"], check=True, capture_output=True)
            subprocess.run(["git", "add", "docs/"], check=True, capture_output=True)
            total_stories = len(stories)
            total_tests = sum(test_counts.values())
            commit_msg = f"Update requirements dashboard - {total_stories} stories, {total_tests} tests [auto]"
            result = subprocess.run(
                ["git", "commit", "-m", commit_msg],
                capture_output=True, text=True
            )
            if result.returncode == 0:
                subprocess.run(["git", "push"], check=True, capture_output=True)
                print(f"  Pushed to GitHub")
            else:
                print(f"  No changes to commit")
            os.chdir(original_dir)
        except Exception as e:
            print(f"  Git push failed: {e}")

    print("Done.")


if __name__ == "__main__":
    main()
