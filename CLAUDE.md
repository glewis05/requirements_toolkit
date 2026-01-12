# Requirements Toolkit

## Project Purpose
This toolkit parses messy requirements documents (Excel, Visio, Lucidchart) and generates standardized user stories with UAT test cases, formatted for GitHub issues.

## Owner Context
- Solo developer (no separate front-end/back-end team)
- Familiar with R, learning Python — explain Python concepts with R comparisons where helpful
- Aviation background — aviation analogies work well for complex concepts
- Prefers detailed explanations with heavy inline comments

## Database Architecture

### Unified Database Design

All Propel Health toolkits share a **single unified database**:

| Location | Purpose |
|----------|---------|
| `~/projects/data/client_product_database.db` | Requirements, configurations, UAT, access management |

This toolkit accesses the database via **symlink**:
```
~/projects/requirements_toolkit/data/client_product_database.db → ~/projects/data/client_product_database.db
```

**Why unified?**
- Programs are the central entity connecting requirements AND configurations
- All programs have requirements (features, user stories)
- All programs have configurations (helpdesk info, settings)
- Some programs have clinics with clinic-specific configurations
- Single source of truth for audit trail

### Requirements Tables (this toolkit manages)
- `requirements` - Raw requirements from source documents
- `user_stories` - Generated user stories with acceptance criteria
- `uat_test_cases` - Test cases derived from stories (UAT toolkit extends)
- `traceability` - Requirements → Stories → Tests mapping
- `compliance_gaps` - Part 11/HIPAA/SOC 2 gaps

### Shared Tables
- `clients` - Client organizations (Propel Health, etc.)
- `programs` - All programs (P4M, Px4M, ONB, etc.) - shared with all toolkits
- `audit_history` - Unified audit trail for compliance

### Configuration Tables (configurations_toolkit manages)
- `clinics`, `locations` - Clinic hierarchy under programs
- `config_definitions`, `config_values` - Configuration settings
- `providers` - Healthcare providers at locations
- `users`, `user_access` - Access management

### MCP Server Integration
The `propel_mcp` server connects to the unified database for all operations.

## Code Standards

### Python Style
- Heavy inline comments explaining WHY, not just WHAT
- Every function needs a docstring with:
  - PURPOSE: What it does
  - R EQUIVALENT: Comparable R function/approach (when applicable)
  - PARAMETERS: Each param with type and example
  - RETURNS: What comes back, with example
  - WHY THIS APPROACH: Reasoning behind implementation choices
- Use type hints for function signatures
- Prefer explicit over clever — readability beats brevity

### File Organization
```
inputs/          → Drop files to process here
outputs/         → Generated files land here
  outputs/drafts/ → Draft Excel files for human review (--phase draft)
config/          → Program-specific settings (test ID prefixes, etc.)
parsers/         → Input file parsing modules
generators/      → User story, UAT, acceptance criteria generation
formatters/      → Output formatting (GitHub markdown, Notion, etc.)
templates/       → Standard output templates
database/        → SQLite database backend
  database/schema.sql    → Full schema (10 tables, 4 views)
  database/db_manager.py → ClientProductDatabase class
  database/queries.py    → Common query functions
data/            → Database access (symlink)
  data/client_product_database.db → Symlink to unified DB at ~/projects/data/
```

## Output Format

### User Story Template
```markdown
## [Feature Title]

**User Story:** As a [user role], I want [capability], so that [business value].

**Priority:** [Critical / High / Medium / Low]

**Description:**
[Context and clarifying details]

**Acceptance Criteria:**
- [ ] [Testable condition 1]
- [ ] [Testable condition 2]

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| XXX-001 | [Cat] | [Title] | [Pre-reqs] | 1. Step... | • Result... | Must Have | 5 min | [Notes] |

**Dependencies:** [Or "None"]

**Source:** [Origin of requirement]
```

## Acceptance Criteria vs UAT Test Cases

**IMPORTANT SEPARATION OF CONCERNS:**

### Acceptance Criteria (user_story_generator.py)
- Define **WHAT** success looks like
- High-level testable statements
- Success metrics
- **Owned by:** Product/Business
- **Generated from:** config/acceptance_patterns.yaml

Example:
```
ACCEPTANCE CRITERIA:
• Count of invited patients displays accurately
• Metrics are segmented by program/channel
• Data exportable for offline analysis

SUCCESS METRICS:
• Zero discrepancy between source and display
• Data refresh completes within 15 minutes
```

### UAT Test Cases (uat_generator.py)
- Define **HOW** to verify it works
- Step-by-step test procedures
- Gherkin scenarios for expected behavior
- **Owned by:** QA/Testers
- **Derived from:** Acceptance criteria

Example:
```
Test ID: PROP-RECRUIT-002
Title: Validate: Count of invited patients displays accurately
Test Steps:
  1. Navigate to the relevant feature
  2. Verify: Count of invited patients displays accurately
  3. Document actual behavior
  4. Compare to expected behavior
Expected Results:
  **Given** the feature is accessible
  **When** the validation is performed
  **Then** Count of invited patients displays accurately
```

**The UAT generator DERIVES test cases from acceptance criteria — it does not duplicate them.**

## Story ID Format

Story IDs use the format: `PREFIX-CATEGORY-SEQ`

Examples:
- `PROP-RECRUIT-001` — Recruitment analytics
- `PROP-MSG-002` — Messaging/notifications
- `PROP-DASH-001` — Dashboard/display
- `PROP-WF-001` — Workflow change (non-technical)

Categories are determined from:
1. Explicit 'Type' column in the requirement
2. Keyword matching against `config/requirement_templates.yaml`
3. Default to 'GEN' if no match

## Configuration Files

### config/acceptance_patterns.yaml
Defines HIGH-LEVEL acceptance criteria patterns for different requirement types:
- `dashboard_display` — Data visualization requirements
- `recruitment_analytics` — Patient recruitment, enrollment, consent
- `notification_tracking` — Email, SMS, reminders
- `data_entry` — Form input and validation
- `data_export` — Reports and exports
- `integration_sync` — API and cross-system integration
- `user_access` — Authentication and permissions
- `workflow_process` — Non-technical process changes

### config/requirement_templates.yaml
Maps requirement types to:
- `category_abbrev` — Used in Story IDs (e.g., RECRUIT, MSG, DASH)
- `typical_roles` — Default user roles for this type
- `acceptance_patterns` — Which patterns to use
- `keywords_to_detect` — How to auto-detect this type
- `is_technical` — False for workflow changes (skipped by UAT generator)

## Key Commands
- Parse Excel: Process requirements from Excel files
- Parse Diagram: Extract requirements from Visio/Lucidchart exports
- Generate Stories: Convert parsed requirements to user stories
- Generate UAT: Create UAT test cases from user stories

## Two-Phase Workflow (Human-in-the-Loop)

For projects requiring stakeholder review before UAT generation, use the two-phase workflow:

### Phase 1: Draft Generation
```bash
python3 run.py "requirements.xlsx" --prefix PROP --phase draft --output excel
```

**What happens:**
1. Parse requirements from input file
2. Generate user stories with acceptance criteria
3. Export to draft Excel for human review
4. **STOP** (UAT not generated yet)

**Output:** `outputs/drafts/PROP_draft_user_stories_YYYYMMDD_HHMM.xlsx`

**Draft Excel contains (14 columns):**
| Column | Purpose | Editable? |
|--------|---------|-----------|
| Story ID | Auto-generated | No (locked) |
| Title | Story title | Yes |
| User Story | As a... I want... so that... | Yes |
| Role | User role | Yes |
| Acceptance Criteria | Auto-generated from patterns | Yes |
| Success Metrics | Measurable outcomes | Yes |
| Priority | Critical/High/Medium/Low | Yes (dropdown) |
| Status | See status options below | Yes (dropdown) |
| Your Notes | Empty - for internal reviewer comments | Yes |
| Meeting Context | Empty - for decisions from meetings | Yes |
| Client Feedback | Empty - for client signoff comments | Yes |
| Is Technical | Yes/No | Yes (dropdown) |
| Source Requirement | Original text | No (locked) |
| Source Row | Traceability | No (locked) |

### Client Review Workflow
1. **Internal team** reviews and refines draft stories
2. Set status to **"Pending Client Review"** and send to client
3. **Client** adds feedback in "Client Feedback" column
4. **Client** changes status to "Approved" or "Needs Discussion"
5. Once approved, run `--phase final` to generate UAT

### Status Options
| Status | Color | Meaning |
|--------|-------|---------|
| Draft | Yellow | Not yet reviewed, needs internal attention |
| Pending Client Review | Blue | Sent to client, awaiting response |
| Approved | Green | Client approved, ready for UAT generation |
| Needs Discussion | Orange | Has questions or concerns to resolve |
| Out of Scope | Grey | Removed from scope, will be skipped |

### Phase 2: Final Generation
```bash
python3 run.py "outputs/drafts/PROP_draft_user_stories_YYYYMMDD_HHMM.xlsx" --prefix PROP --phase final --output excel
```

**What happens:**
1. Import refined user stories from the draft Excel
2. Generate UAT test cases from **your refined** acceptance criteria
3. Generate traceability matrix
4. Export final output

**Notes:**
- Stories with Status="Out of Scope" are skipped
- Stories with Status="Needs Discussion" or "Pending Client Review" are included but flagged
- Client feedback is captured and flows through to UAT generation context
- The UAT generator uses YOUR refined acceptance criteria, not auto-generated ones

### Full Pipeline (Default)
```bash
python3 run.py "requirements.xlsx" --prefix PROP --output excel
# OR
python3 run.py "requirements.xlsx" --prefix PROP --phase all --output excel
```

Use `--phase all` (or omit the flag) for the original behavior: full pipeline without human review step.

## SQLite Database Backend

The toolkit includes an optional SQLite database for persistent storage of all pipeline artifacts.

### Database Location
```
data/client_product_database.db
```

### Enabling Database Storage
Add `--save-to-db` to any run.py command:
```bash
# First run - creates client and program
python3 run.py "requirements.xlsx" --prefix PROP --phase draft \
    --save-to-db --client "Discover Health" --program "Propel Analytics"

# Subsequent runs - finds existing program by prefix
python3 run.py "requirements.xlsx" --prefix PROP --phase final --save-to-db

# Full pipeline with database
python3 run.py "requirements.xlsx" --prefix PROP --output excel \
    --compliance all --save-to-db --client "Acme Corp"
```

### Database Schema (10 Tables)
| Table | Purpose |
|-------|---------|
| `clients` | Top-level organizations |
| `programs` | Projects under each client (unique prefix: PROP, GRX, etc.) |
| `requirements` | Raw requirements from source files |
| `user_stories` | Stories with full lifecycle tracking (Draft → Approved) |
| `uat_test_cases` | Test cases with execution status (Pass/Fail/Blocked) |
| `traceability` | Req → Story → Test links with coverage status |
| `compliance_gaps` | Gap tracking by framework (Part11/HIPAA/SOC2) |
| `audit_history` | Complete change log for regulatory compliance |
| `story_reference` | Reference library of high-quality approved stories |
| `import_batches` | File import tracking |

### Database Views
- `v_program_summary` — Dashboard stats by program
- `v_story_workflow` — Story status with test counts
- `v_compliance_dashboard` — Gap counts by framework/severity
- `v_test_execution` — Test status counts by type

### Command Line Options
| Flag | Purpose |
|------|---------|
| `--save-to-db` | Enable database storage |
| `--client` | Client name (creates if not exists) |
| `--program` | Program name (creates if not exists under client) |
| `--from-db` | Load approved stories from database (for --phase final) |

### Programmatic Access
```python
from database import ClientProductDatabase, get_database
from database import queries

# Get database instance
db = get_database()

# Create client and program
client_id = db.create_client("Acme Corp")
program_id = db.create_program(client_id, "Analytics", "ACME")

# Save pipeline output
db.save_requirements(program_id, requirements, "source.xlsx")
db.save_user_stories(program_id, stories)
db.save_test_cases(program_id, test_cases)

# Query functions
summary = db.get_program_summary(program_id)
health = queries.get_program_health_score(db, program_id)
tree = queries.get_client_program_tree(db)
```

### Audit Trail (Regulatory Compliance)
All changes are logged to `audit_history` for FDA 21 CFR Part 11 compliance:
- Record type (client, program, story, test_case, etc.)
- Action (Created, Updated, Deleted, Status Changed, Approved)
- Old/new values
- Who made the change
- Timestamp
- Change reason (optional)

### Direct Story Import

Import refined user stories directly into the database without going through the parsing/generation pipeline.

**Use Cases:**
- Seed database with existing work from spreadsheets
- Migrate stories from another system
- Build reference library from historical approved stories
- Import manually refined stories outside the pipeline

**Command:**
```bash
# Basic import (stories marked as Approved)
python3 run.py "refined_stories.xlsx" --import-stories --prefix PROP \
    --client "Discover Health" --program "Propel Analytics"

# Import as Draft status
python3 run.py "stories.xlsx" --import-stories --prefix PROP \
    --client "Acme" --import-status Draft

# Add to reference library
python3 run.py "approved_stories.xlsx" --import-stories --prefix PROP \
    --client "Acme" --add-to-reference --verbose
```

**Flexible Column Mapping:**
The import handles various column naming conventions:
| Field | Accepted Column Names |
|-------|----------------------|
| story_id | Story ID, ID, Identifier |
| title | Title, Name, Summary, Feature |
| user_story | User Story, Story, Description |
| role | Role, Actor, User, Persona |
| acceptance_criteria | Acceptance Criteria, AC, Criteria |
| success_metrics | Success Metrics, Metrics, KPI |
| priority | Priority, Ranking, Importance |
| status | Status, State, Approval |
| is_technical | Is Technical, Technical, Tech |
| internal_notes | Internal Notes, Your Notes, Notes |
| client_feedback | Client Feedback, Feedback |

**Behavior:**
- Stories without IDs get auto-generated IDs: `PREFIX-CATEGORY-SEQ`
- Stories default to 'Approved' status (use `--import-status Draft` to override)
- Column matching is case-insensitive
- Missing optional columns are skipped gracefully
- Story IDs are globally unique - re-importing updates existing stories

**Import Flags:**
| Flag | Purpose |
|------|---------|
| `--import-stories` | Enable direct import mode |
| `--import-status` | Status for imported stories (default: Approved) |
| `--add-to-reference` | Add approved stories to reference library |

## Output Contracts (for Downstream Tools)

### JSON Export Structure (--output json)
Structured data format for downstream tools like UAT Package Builder:
```json
{
  "metadata": {
    "source_file": "string",
    "processed_date": "ISO date", 
    "prefix": "string"
  },
  "user_stories": [...],
  "uat_test_cases": [...],
  "flags": [...],
  "summary": {
    "total_stories": int,
    "total_test_cases": int,
    "flagged_items": int
  }
}
```

### Excel Export Structure
- Sheet: "Test Case Master" — UAT test cases in standard format
- Sheet: "User Stories" — Generated stories with acceptance criteria  
- Sheet: "Summary" — Counts and flagged items

### Markdown Export Structure
- Single file or per-story files
- GitHub-compatible formatting
- Summary section at top with counts and flags
```

## Do NOT
- Use overly clever one-liners without explanation
- Skip error handling
- Assume I know Python idioms — explain them
