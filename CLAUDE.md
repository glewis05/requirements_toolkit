# Requirements Toolkit

## Project Purpose
This toolkit parses messy requirements documents (Excel, Visio, Lucidchart) and generates standardized user stories with UAT test cases, formatted for GitHub issues.

## Owner Context
- Solo developer (no separate front-end/back-end team)
- Familiar with R, learning Python — explain Python concepts with R comparisons where helpful
- Aviation background — aviation analogies work well for complex concepts
- Prefers detailed explanations with heavy inline comments

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
config/          → Program-specific settings (test ID prefixes, etc.)
parsers/         → Input file parsing modules
generators/      → User story, UAT, acceptance criteria generation
formatters/      → Output formatting (GitHub markdown, Notion, etc.)
templates/       → Standard output templates
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
