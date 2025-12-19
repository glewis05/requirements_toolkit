# database/queries.py
# ============================================================================
# CLIENT PRODUCT DATABASE - Common Queries
# ============================================================================
# Purpose: Pre-built queries for common operations and reporting.
#          These functions provide higher-level access to the database
#          for dashboards, reports, and data analysis.
#
# USAGE:
#     from database.db_manager import get_database
#     from database.queries import get_client_program_tree
#
#     db = get_database()
#     tree = get_client_program_tree(db)
#
# ============================================================================

from typing import Optional, Dict, List, Any
from datetime import datetime, timedelta


def get_client_program_tree(db) -> List[Dict]:
    """
    PURPOSE:
        Get hierarchical view: Clients → Programs → Story counts.
        Useful for dashboard navigation and overview.

    RETURNS:
        List of clients, each with nested programs list:
        [
            {
                "client_id": "...",
                "name": "Discover Health",
                "programs": [
                    {
                        "program_id": "...",
                        "name": "Propel Analytics",
                        "prefix": "PROP",
                        "story_count": 15,
                        "approved_count": 10,
                        "test_count": 45
                    }
                ]
            }
        ]
    """
    conn = db.get_connection()

    # Get all active clients
    clients_cursor = conn.execute("""
        SELECT client_id, name, description, status
        FROM clients
        WHERE status = 'Active'
        ORDER BY name
    """)

    result = []
    for client_row in clients_cursor.fetchall():
        client = dict(client_row)

        # Get programs for this client
        programs_cursor = conn.execute("""
            SELECT
                p.program_id,
                p.name,
                p.prefix,
                p.status,
                COUNT(DISTINCT s.story_id) as story_count,
                COUNT(DISTINCT CASE WHEN s.status = 'Approved' THEN s.story_id END) as approved_count,
                COUNT(DISTINCT t.test_id) as test_count
            FROM programs p
            LEFT JOIN user_stories s ON p.program_id = s.program_id
            LEFT JOIN uat_test_cases t ON p.program_id = t.program_id
            WHERE p.client_id = ?
            GROUP BY p.program_id
            ORDER BY p.name
        """, (client['client_id'],))

        client['programs'] = [dict(row) for row in programs_cursor.fetchall()]
        result.append(client)

    return result


def get_stories_pending_client_review(
    db,
    client_id: Optional[str] = None
) -> List[Dict]:
    """
    PURPOSE:
        Get all stories awaiting client feedback across programs.
        Useful for client review dashboard.

    PARAMETERS:
        db: Database instance
        client_id: Optional - filter by client

    RETURNS:
        List of stories with program and client info
    """
    conn = db.get_connection()

    query = """
        SELECT
            s.*,
            p.name as program_name,
            p.prefix,
            c.name as client_name
        FROM user_stories s
        JOIN programs p ON s.program_id = p.program_id
        JOIN clients c ON p.client_id = c.client_id
        WHERE s.status = 'Pending Client Review'
    """
    params = []

    if client_id:
        query += " AND c.client_id = ?"
        params.append(client_id)

    query += " ORDER BY s.updated_date DESC"

    cursor = conn.execute(query, params)
    return [dict(row) for row in cursor.fetchall()]


def get_approval_pipeline(db, program_id: str) -> Dict:
    """
    PURPOSE:
        Kanban-style view of story statuses for a program.
        Shows how many stories are in each workflow stage.

    RETURNS:
        {
            "Draft": [story1, story2, ...],
            "Internal Review": [...],
            "Pending Client Review": [...],
            "Approved": [...],
            "Needs Discussion": [...],
            "Out of Scope": [...]
        }
    """
    conn = db.get_connection()

    statuses = [
        'Draft',
        'Internal Review',
        'Pending Client Review',
        'Approved',
        'Needs Discussion',
        'Out of Scope'
    ]

    pipeline = {status: [] for status in statuses}

    cursor = conn.execute("""
        SELECT story_id, title, priority, category, status, updated_date
        FROM user_stories
        WHERE program_id = ?
        ORDER BY priority DESC, updated_date DESC
    """, (program_id,))

    for row in cursor.fetchall():
        story = dict(row)
        status = story['status']
        if status in pipeline:
            pipeline[status].append(story)
        else:
            # Handle unknown status
            pipeline['Draft'].append(story)

    return pipeline


def get_test_execution_summary(db, program_id: str) -> Dict:
    """
    PURPOSE:
        Test case execution summary for a program.
        Shows pass/fail rates and coverage.

    RETURNS:
        {
            "total": 120,
            "by_status": {
                "Not Run": 50,
                "Pass": 60,
                "Fail": 5,
                "Blocked": 3,
                "Skipped": 2
            },
            "by_type": {
                "happy_path": {"total": 30, "Pass": 25, "Fail": 2, ...},
                "negative": {...},
                "validation": {...},
                "edge_case": {...}
            },
            "pass_rate": 92.3,
            "execution_rate": 58.3
        }
    """
    conn = db.get_connection()

    summary = {
        'total': 0,
        'by_status': {},
        'by_type': {},
        'pass_rate': 0,
        'execution_rate': 0
    }

    # Overall by status
    cursor = conn.execute("""
        SELECT test_status, COUNT(*) as count
        FROM uat_test_cases
        WHERE program_id = ?
        GROUP BY test_status
    """, (program_id,))

    executed = 0
    passed = 0
    for row in cursor.fetchall():
        summary['by_status'][row['test_status']] = row['count']
        summary['total'] += row['count']
        if row['test_status'] in ['Pass', 'Fail', 'Blocked']:
            executed += row['count']
        if row['test_status'] == 'Pass':
            passed = row['count']

    # By test type
    cursor = conn.execute("""
        SELECT test_type, test_status, COUNT(*) as count
        FROM uat_test_cases
        WHERE program_id = ?
        GROUP BY test_type, test_status
    """, (program_id,))

    for row in cursor.fetchall():
        test_type = row['test_type'] or 'unknown'
        if test_type not in summary['by_type']:
            summary['by_type'][test_type] = {'total': 0}

        summary['by_type'][test_type][row['test_status']] = row['count']
        summary['by_type'][test_type]['total'] += row['count']

    # Calculate rates
    if executed > 0:
        summary['pass_rate'] = round(100 * passed / executed, 1)
    if summary['total'] > 0:
        summary['execution_rate'] = round(100 * executed / summary['total'], 1)

    return summary


def get_compliance_dashboard(db, program_id: str) -> Dict:
    """
    PURPOSE:
        Compliance gaps dashboard for a program.
        Shows gaps by framework with severity breakdown.

    RETURNS:
        {
            "total_open": 15,
            "by_framework": {
                "Part11": {"Critical": 2, "High": 3, "Medium": 5, ...},
                "HIPAA": {...},
                "SOC2": {...}
            },
            "recent_closures": [...],
            "overdue": [...]
        }
    """
    conn = db.get_connection()

    dashboard = {
        'total_open': 0,
        'by_framework': {},
        'recent_closures': [],
        'overdue': []
    }

    # By framework and severity (open gaps only)
    cursor = conn.execute("""
        SELECT framework, severity, COUNT(*) as count
        FROM compliance_gaps
        WHERE program_id = ? AND status NOT IN ('Closed', 'Accepted')
        GROUP BY framework, severity
    """, (program_id,))

    for row in cursor.fetchall():
        framework = row['framework']
        if framework not in dashboard['by_framework']:
            dashboard['by_framework'][framework] = {}

        dashboard['by_framework'][framework][row['severity']] = row['count']
        dashboard['total_open'] += row['count']

    # Recent closures (last 30 days)
    cursor = conn.execute("""
        SELECT gap_id, framework, gap_description, closed_date
        FROM compliance_gaps
        WHERE program_id = ? AND status = 'Closed'
        AND closed_date >= date('now', '-30 days')
        ORDER BY closed_date DESC
        LIMIT 10
    """, (program_id,))
    dashboard['recent_closures'] = [dict(row) for row in cursor.fetchall()]

    # Overdue gaps
    cursor = conn.execute("""
        SELECT gap_id, framework, gap_description, due_date, severity, owner
        FROM compliance_gaps
        WHERE program_id = ?
        AND status NOT IN ('Closed', 'Accepted')
        AND due_date < date('now')
        ORDER BY due_date
    """, (program_id,))
    dashboard['overdue'] = [dict(row) for row in cursor.fetchall()]

    return dashboard


def search_stories_global(db, keyword: str) -> List[Dict]:
    """
    PURPOSE:
        Search stories across all clients/programs by keyword.
        Searches title, user_story, and acceptance_criteria.

    PARAMETERS:
        keyword: Search term

    RETURNS:
        List of matching stories with program and client info
    """
    conn = db.get_connection()

    search_term = f"%{keyword}%"

    cursor = conn.execute("""
        SELECT
            s.story_id,
            s.title,
            s.user_story,
            s.status,
            s.priority,
            s.category,
            p.name as program_name,
            p.prefix,
            c.name as client_name
        FROM user_stories s
        JOIN programs p ON s.program_id = p.program_id
        JOIN clients c ON p.client_id = c.client_id
        WHERE s.title LIKE ?
           OR s.user_story LIKE ?
           OR s.acceptance_criteria LIKE ?
        ORDER BY s.updated_date DESC
        LIMIT 50
    """, (search_term, search_term, search_term))

    return [dict(row) for row in cursor.fetchall()]


def find_similar_stories(
    db,
    title: str,
    description: str,
    limit: int = 5
) -> List[Dict]:
    """
    PURPOSE:
        Find potentially similar stories for duplicate detection.
        Uses simple word matching (could be enhanced with ML).

    PARAMETERS:
        title: New story title
        description: New story description
        limit: Max results to return

    RETURNS:
        List of potentially similar stories with similarity score
    """
    conn = db.get_connection()

    # Extract keywords (simple approach - split and filter)
    words = set()
    for text in [title, description]:
        if text:
            words.update(word.lower() for word in text.split()
                        if len(word) > 3)

    if not words:
        return []

    # Build query with OR conditions for each keyword
    conditions = []
    params = []
    for word in list(words)[:10]:  # Limit keywords
        conditions.append("(s.title LIKE ? OR s.user_story LIKE ?)")
        params.extend([f"%{word}%", f"%{word}%"])

    query = f"""
        SELECT
            s.story_id,
            s.title,
            s.user_story,
            s.status,
            p.prefix,
            p.name as program_name
        FROM user_stories s
        JOIN programs p ON s.program_id = p.program_id
        WHERE {' OR '.join(conditions)}
        LIMIT {limit * 2}
    """

    cursor = conn.execute(query, params)
    results = []

    for row in cursor.fetchall():
        story = dict(row)
        # Calculate simple similarity score
        story_words = set()
        for text in [story['title'], story['user_story']]:
            if text:
                story_words.update(word.lower() for word in text.split()
                                  if len(word) > 3)

        overlap = len(words & story_words)
        if overlap > 0:
            story['similarity_score'] = overlap / max(len(words), 1)
            results.append(story)

    # Sort by similarity and limit
    results.sort(key=lambda x: x['similarity_score'], reverse=True)
    return results[:limit]


def get_program_health_score(db, program_id: str) -> Dict:
    """
    PURPOSE:
        Calculate overall program health score (0-100).
        Based on story approval rate, test pass rate, and compliance gaps.

    RETURNS:
        {
            "score": 78,
            "grade": "B",
            "components": {
                "story_approval": {"score": 85, "weight": 0.3},
                "test_pass_rate": {"score": 92, "weight": 0.4},
                "compliance": {"score": 50, "weight": 0.3}
            },
            "recommendations": [...]
        }
    """
    conn = db.get_connection()

    health = {
        'score': 0,
        'grade': 'F',
        'components': {},
        'recommendations': []
    }

    # Story approval rate (weight: 0.3)
    cursor = conn.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(CASE WHEN status = 'Approved' THEN 1 END) as approved
        FROM user_stories
        WHERE program_id = ?
    """, (program_id,))
    row = cursor.fetchone()
    if row['total'] > 0:
        story_score = round(100 * row['approved'] / row['total'])
        if story_score < 50:
            health['recommendations'].append(
                f"Only {story_score}% of stories are approved. "
                "Review and approve pending stories."
            )
    else:
        story_score = 0
        health['recommendations'].append("No user stories found. Generate stories from requirements.")

    health['components']['story_approval'] = {'score': story_score, 'weight': 0.3}

    # Test pass rate (weight: 0.4)
    cursor = conn.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(CASE WHEN test_status = 'Pass' THEN 1 END) as passed,
            COUNT(CASE WHEN test_status IN ('Pass', 'Fail', 'Blocked') THEN 1 END) as executed
        FROM uat_test_cases
        WHERE program_id = ?
    """, (program_id,))
    row = cursor.fetchone()
    if row['executed'] > 0:
        test_score = round(100 * row['passed'] / row['executed'])
        if test_score < 80:
            health['recommendations'].append(
                f"Test pass rate is {test_score}%. "
                "Investigate and fix failing tests."
            )
    elif row['total'] > 0:
        test_score = 50  # Tests exist but not executed
        health['recommendations'].append(
            f"{row['total']} test cases not yet executed. "
            "Run test suite."
        )
    else:
        test_score = 0
        health['recommendations'].append("No test cases found. Generate UAT tests.")

    health['components']['test_pass_rate'] = {'score': test_score, 'weight': 0.4}

    # Compliance (weight: 0.3)
    cursor = conn.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(CASE WHEN severity = 'Critical' THEN 1 END) as critical,
            COUNT(CASE WHEN severity = 'High' THEN 1 END) as high
        FROM compliance_gaps
        WHERE program_id = ? AND status NOT IN ('Closed', 'Accepted')
    """, (program_id,))
    row = cursor.fetchone()
    if row['total'] == 0:
        compliance_score = 100
    else:
        # Deduct for open gaps
        compliance_score = max(0, 100 - (row['critical'] * 20) - (row['high'] * 10) - (row['total'] * 2))
        if row['critical'] > 0:
            health['recommendations'].append(
                f"{row['critical']} critical compliance gaps open. "
                "Address immediately."
            )
        elif row['high'] > 0:
            health['recommendations'].append(
                f"{row['high']} high-severity compliance gaps. "
                "Plan remediation."
            )

    health['components']['compliance'] = {'score': compliance_score, 'weight': 0.3}

    # Calculate weighted score
    total_score = sum(
        comp['score'] * comp['weight']
        for comp in health['components'].values()
    )
    health['score'] = round(total_score)

    # Assign grade
    if health['score'] >= 90:
        health['grade'] = 'A'
    elif health['score'] >= 80:
        health['grade'] = 'B'
    elif health['score'] >= 70:
        health['grade'] = 'C'
    elif health['score'] >= 60:
        health['grade'] = 'D'
    else:
        health['grade'] = 'F'

    return health


def get_recent_activity(db, days: int = 7) -> List[Dict]:
    """
    PURPOSE:
        Get recent changes across all programs.
        Useful for activity feed / dashboard.

    PARAMETERS:
        days: Number of days to look back

    RETURNS:
        List of recent audit entries with context
    """
    conn = db.get_connection()

    cursor = conn.execute("""
        SELECT
            a.*,
            CASE
                WHEN a.record_type = 'user_story' THEN s.title
                WHEN a.record_type = 'test_case' THEN t.title
                WHEN a.record_type = 'program' THEN p.name
                WHEN a.record_type = 'client' THEN c.name
                ELSE a.record_id
            END as record_name
        FROM audit_history a
        LEFT JOIN user_stories s ON a.record_type = 'user_story' AND a.record_id = s.story_id
        LEFT JOIN uat_test_cases t ON a.record_type = 'test_case' AND a.record_id = t.test_id
        LEFT JOIN programs p ON a.record_type = 'program' AND a.record_id = p.program_id
        LEFT JOIN clients c ON a.record_type = 'client' AND a.record_id = c.client_id
        WHERE a.changed_date >= date('now', ?)
        ORDER BY a.changed_date DESC
        LIMIT 100
    """, (f"-{days} days",))

    return [dict(row) for row in cursor.fetchall()]


def export_audit_report(
    db,
    program_id: str,
    start_date: str,
    end_date: str
) -> Dict:
    """
    PURPOSE:
        Export comprehensive audit trail for compliance review.
        Includes all changes to stories, tests, and compliance gaps.

    PARAMETERS:
        program_id: Program to audit
        start_date: Start date (YYYY-MM-DD)
        end_date: End date (YYYY-MM-DD)

    RETURNS:
        {
            "program": {...},
            "date_range": {"start": ..., "end": ...},
            "summary": {"total_changes": ..., "by_type": {...}},
            "audit_entries": [...]
        }
    """
    conn = db.get_connection()

    report = {
        'program': db.get_program(program_id),
        'date_range': {'start': start_date, 'end': end_date},
        'summary': {'total_changes': 0, 'by_type': {}, 'by_action': {}},
        'audit_entries': []
    }

    # Get all related record IDs
    story_ids = [s['story_id'] for s in db.get_stories(program_id)]
    test_ids = [t['test_id'] for t in db.get_test_cases(program_id=program_id)]

    # Query audit history
    placeholders = ','.join(['?' for _ in story_ids + test_ids])
    all_ids = story_ids + test_ids + [program_id]

    query = f"""
        SELECT *
        FROM audit_history
        WHERE record_id IN ({placeholders}, ?)
        AND changed_date BETWEEN ? AND ?
        ORDER BY changed_date DESC
    """

    cursor = conn.execute(query, all_ids + [start_date, end_date])

    for row in cursor.fetchall():
        entry = dict(row)
        report['audit_entries'].append(entry)
        report['summary']['total_changes'] += 1

        # Count by type
        rec_type = entry['record_type']
        report['summary']['by_type'][rec_type] = \
            report['summary']['by_type'].get(rec_type, 0) + 1

        # Count by action
        action = entry['action']
        report['summary']['by_action'][action] = \
            report['summary']['by_action'].get(action, 0) + 1

    return report


def get_stories_by_reviewer(db, reviewer: str) -> List[Dict]:
    """
    PURPOSE:
        Get all stories that a specific person has modified.
        Useful for tracking individual contributions.

    PARAMETERS:
        reviewer: Name of the reviewer (from audit history)

    RETURNS:
        List of stories with change summary
    """
    conn = db.get_connection()

    cursor = conn.execute("""
        SELECT DISTINCT
            s.story_id,
            s.title,
            s.status,
            s.priority,
            p.prefix,
            p.name as program_name,
            COUNT(a.audit_id) as change_count,
            MAX(a.changed_date) as last_change
        FROM audit_history a
        JOIN user_stories s ON a.record_id = s.story_id
        JOIN programs p ON s.program_id = p.program_id
        WHERE a.record_type = 'user_story'
        AND a.changed_by = ?
        GROUP BY s.story_id
        ORDER BY last_change DESC
    """, (reviewer,))

    return [dict(row) for row in cursor.fetchall()]


def get_orphan_requirements(db, program_id: str) -> List[Dict]:
    """
    PURPOSE:
        Find requirements without corresponding user stories.
        Useful for identifying coverage gaps.

    RETURNS:
        List of requirements without stories
    """
    conn = db.get_connection()

    cursor = conn.execute("""
        SELECT r.*
        FROM requirements r
        LEFT JOIN user_stories s ON r.requirement_id = s.requirement_id
        WHERE r.program_id = ?
        AND s.story_id IS NULL
        ORDER BY r.source_row
    """, (program_id,))

    return [dict(row) for row in cursor.fetchall()]


def get_stories_without_tests(db, program_id: str) -> List[Dict]:
    """
    PURPOSE:
        Find approved stories without test cases.
        Useful for identifying testing gaps.

    RETURNS:
        List of stories without tests
    """
    conn = db.get_connection()

    cursor = conn.execute("""
        SELECT s.*
        FROM user_stories s
        LEFT JOIN uat_test_cases t ON s.story_id = t.story_id
        WHERE s.program_id = ?
        AND s.status = 'Approved'
        AND s.is_technical = 1
        AND t.test_id IS NULL
        ORDER BY s.story_id
    """, (program_id,))

    return [dict(row) for row in cursor.fetchall()]


# ============================================================================
# MODULE EXPORTS
# ============================================================================

__all__ = [
    'get_client_program_tree',
    'get_stories_pending_client_review',
    'get_approval_pipeline',
    'get_test_execution_summary',
    'get_compliance_dashboard',
    'search_stories_global',
    'find_similar_stories',
    'get_program_health_score',
    'get_recent_activity',
    'export_audit_report',
    'get_stories_by_reviewer',
    'get_orphan_requirements',
    'get_stories_without_tests',
]
