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
