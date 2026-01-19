# Requirements Toolkit

Modular Python toolkit for parsing requirements and generating user stories, UAT test cases, and compliance documentation.

## Overview

This toolkit:
- Parses messy requirements documents (Excel, Visio, Lucidchart, Word)
- Generates standardized user stories with acceptance criteria
- Creates UAT test cases derived from acceptance criteria
- Tracks traceability from requirements → stories → tests
- Identifies compliance gaps (FDA 21 CFR Part 11, HIPAA, SOC 2)

## Installation

```bash
# Clone the repository
git clone https://github.com/glewis05/requirements_toolkit.git
cd requirements_toolkit

# Install dependencies
pip install -r requirements.txt

# Set up database symlink (connects to unified Propel Health database)
ln -s ~/projects/data/client_product_database.db data/client_product_database.db
```

## Quick Start

### Full Pipeline (Parse → Stories → UAT)
```bash
python3 run.py "requirements.xlsx" --prefix PROP --output excel
```

### Two-Phase Workflow (Human Review)
```bash
# Phase 1: Generate draft stories for stakeholder review
python3 run.py "requirements.xlsx" --prefix PROP --phase draft --output excel

# Edit the draft Excel file, get approvals...

# Phase 2: Generate UAT from approved stories
python3 run.py "outputs/drafts/PROP_draft_user_stories_YYYYMMDD_HHMM.xlsx" --prefix PROP --phase final --output excel
```

### With Database Storage
```bash
python3 run.py "requirements.xlsx" --prefix PROP --output excel \
    --save-to-db --client "Discover Health" --program "Propel Analytics"
```

## Project Structure

```
requirements_toolkit/
├── run.py                  # CLI entry point
├── CLAUDE.md               # AI assistant context
├── parsers/                # Input file parsing
│   ├── excel_parser.py     # Parse Excel requirements
│   ├── word_parser.py      # Parse Word documents
│   └── lucidchart_parser.py # Parse Lucidchart diagrams
├── generators/             # Output generation
│   ├── user_story_generator.py  # Generate user stories
│   ├── uat_generator.py         # Generate UAT test cases
│   └── traceability_generator.py # Build traceability matrix
├── formatters/             # Output formatting
│   ├── excel_formatter.py  # Excel output
│   ├── github_markdown.py  # GitHub-flavored markdown
│   └── notion_formatter.py # Notion export
├── compliance/             # Compliance validation
│   ├── part11_validator.py # FDA 21 CFR Part 11
│   ├── hipaa_validator.py  # HIPAA
│   └── soc2_validator.py   # SOC 2
├── database/               # SQLite backend
│   ├── schema.sql          # Full schema
│   ├── db_manager.py       # Database operations
│   └── queries.py          # Common queries
├── config/                 # Configuration files
│   ├── acceptance_patterns.yaml  # Acceptance criteria patterns
│   └── requirement_templates.yaml # Requirement type mappings
├── templates/              # Output templates
├── inputs/                 # Drop files to process here
├── outputs/                # Generated files
│   └── drafts/             # Draft Excel for human review
└── data/                   # Database (symlink to unified DB)
```

## Output Format

### User Story Template
```markdown
## [Feature Title]

**User Story:** As a [user role], I want [capability], so that [business value].

**Priority:** [Critical / High / Medium / Low]

**Acceptance Criteria:**
- [ ] [Testable condition 1]
- [ ] [Testable condition 2]

**UAT Test Cases:**
| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results |
|---------|----------|-------|----------------|------------|------------------|
| XXX-001 | [Cat] | [Title] | [Pre-reqs] | 1. Step... | Result... |
```

## Story ID Format

Story IDs use the format: `PREFIX-CATEGORY-SEQ`

Examples:
- `PROP-RECRUIT-001` — Recruitment analytics
- `PROP-MSG-002` — Messaging/notifications
- `PROP-DASH-001` — Dashboard/display
- `PROP-WF-001` — Workflow change (non-technical)

## Database Architecture

Part of the unified Propel Health database ecosystem:

| Location | Purpose |
|----------|---------|
| `~/projects/data/client_product_database.db` | Shared database for all toolkits |

### Tables Managed by This Toolkit
- `requirements` - Raw requirements from source documents
- `user_stories` - Generated user stories with acceptance criteria
- `uat_test_cases` - Test cases derived from stories
- `traceability` - Requirements → Stories → Tests mapping
- `compliance_gaps` - Part 11/HIPAA/SOC 2 gaps

## CLI Options

| Flag | Description |
|------|-------------|
| `--prefix` | Story ID prefix (e.g., PROP, GRX) |
| `--phase` | `draft`, `final`, or `all` (default) |
| `--output` | Output format: `excel`, `markdown`, `json` |
| `--save-to-db` | Store results in SQLite database |
| `--client` | Client name (creates if not exists) |
| `--program` | Program name (creates if not exists) |
| `--compliance` | Enable compliance checks: `part11`, `hipaa`, `soc2`, or `all` |
| `--import-stories` | Direct import mode (bypass parsing) |
| `--verbose` | Show detailed output |

## Related Projects

- **[uat_toolkit](https://github.com/glewis05/uat_toolkit)** - Manages UAT execution cycles
- **[configurations_toolkit](https://github.com/glewis05/configurations_toolkit)** - Manages clinic configurations
- **[propel_mcp](https://github.com/glewis05/propel_mcp)** - MCP server connecting all toolkits

## License

Proprietary - Propel Health
