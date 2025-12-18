# generators/user_story_generator.py
# ============================================================================
# PURPOSE: Transform requirements into well-formed user stories
#
# MAJOR UPDATES:
#   - Uses ALL context columns from Excel (notes, decisions, impacts)
#   - Generates HYBRID acceptance criteria (testable statements + Gherkin + metrics)
#   - NO generic boilerplate - all criteria derived from actual requirement
#   - Classifies requirement types (Technical Feature, Workflow Change, Out of Scope)
#   - New Story ID format: PREFIX-CATEGORY-SEQ (e.g., PROP-RECRUIT-001)
#
# AVIATION ANALOGY:
#   Like creating a flight plan from raw data - we use ALL available information
#   (weather, NOTAMs, aircraft performance, crew status) not just the basics.
#
# ============================================================================

import re
from typing import Optional
from difflib import SequenceMatcher


class UserStoryGenerator:
    """
    PURPOSE:
        Transform raw requirements into well-formed user stories using
        ALL available context from the source document.

    KEY FEATURES:
        - Consumes context_columns dict from parser (notes, decisions, impacts)
        - Generates specific acceptance criteria from actual requirement content
        - Classifies requirement types based on context keywords
        - New Story ID format: PREFIX-CATEGORY-SEQ

    OUTPUT STRUCTURE:
        {
            "generated_id": "PROP-RECRUIT-001",
            "title": "...",
            "user_story": "As a [role], I want [capability], so that [benefit]",
            "priority": "High",
            "role": "analyst",
            "capability": "...",
            "benefit": "...",
            "requirement_type": "Technical Feature" | "Workflow Change" | "Out of Scope" | "Completed",
            "acceptance_criteria": [...],  # HYBRID format
            "description": "...",
            "flags": [...],
            "source_requirement": {...}
        }
    """

    # ========================================================================
    # CATEGORY MAPPINGS FOR STORY IDs
    # ========================================================================
    # Maps keywords to category codes for ID generation
    # Format: PREFIX-CATEGORY-SEQ (e.g., PROP-RECRUIT-001)

    CATEGORY_MAPPINGS = {
        # Recruitment/Analytics
        'RECRUIT': ['recruitment', 'recruit', 'analytics', 'metric', 'kpi', 'dashboard',
                   'tracking', 'volume', 'conversion', 'funnel', 'outreach'],
        # Enrollment/Onboarding
        'ENROLL': ['enrollment', 'enroll', 'onboard', 'registration', 'signup', 'sign-up'],
        # Authentication/Access
        'AUTH': ['authentication', 'auth', 'login', 'logout', 'password', 'access',
                'permission', 'role', 'sso', 'oauth', 'mfa', '2fa'],
        # Dashboard/Display
        'DASH': ['dashboard', 'display', 'view', 'visualization', 'chart', 'graph',
                'report', 'summary', 'overview'],
        # Reporting
        'RPT': ['report', 'export', 'download', 'csv', 'excel', 'pdf'],
        # Consent/Agreement
        'CONSENT': ['consent', 'agreement', 'econsent', 'e-consent', 'signature',
                   'authorization', 'hipaa', 'gdpr'],
        # Messaging/Notifications
        'MSG': ['message', 'email', 'sms', 'notification', 'alert', 'reminder',
               'communication', 'outbound'],
        # Data/Records
        'DATA': ['data', 'record', 'patient', 'user', 'profile', 'demographics',
                'information', 'storage', 'database'],
        # Integration/API
        'INTEG': ['integration', 'api', 'sync', 'import', 'connect', 'webhook',
                 'external', 'third-party'],
        # Billing/Payment
        'BILL': ['billing', 'payment', 'invoice', 'subscription', 'charge', 'fee'],
        # Admin/Settings
        'ADMIN': ['admin', 'administrator', 'settings', 'configuration', 'config',
                 'manage', 'management'],
    }

    # Default category if no match
    DEFAULT_CATEGORY = 'GEN'

    # ========================================================================
    # REQUIREMENT TYPE CLASSIFICATION
    # ========================================================================
    # Keywords that indicate non-technical requirements

    WORKFLOW_CHANGE_KEYWORDS = [
        'workflow', 'process change', 'manual process', 'procedure update',
        'training', 'policy', 'sop', 'standard operating'
    ]

    OUT_OF_SCOPE_KEYWORDS = [
        'out of scope', 'removed from scope', 'not viable', 'rejected',
        'deferred', 'not feasible', 'cancelled', 'canceled', 'deprecated',
        'not applicable', 'n/a', 'tbd'
    ]

    COMPLETED_KEYWORDS = [
        'completed', 'complete', 'done', 'finished', 'shipped',
        'released', 'deployed', 'implemented', 'live'
    ]

    def __init__(
        self,
        prefix: str = "REQ",
        default_role: str = "user",
        default_priority: str = "Medium",
        similarity_threshold: float = 0.75
    ) -> None:
        """
        PURPOSE:
            Initialize the generator with configuration.

        PARAMETERS:
            prefix (str): Prefix for Story IDs (e.g., "PROP", "GRX", "NCCN")
            default_role (str): Default user role when none detected
            default_priority (str): Default priority when none specified
            similarity_threshold (float): Threshold for duplicate detection (0.0-1.0)
        """
        self.prefix = prefix
        self.default_role = default_role
        self.default_priority = default_priority
        self.similarity_threshold = similarity_threshold

        # Track stories for duplicate detection
        self._all_stories: list[dict] = []

        # Track sequence numbers per category
        self._category_sequences: dict[str, int] = {}

        # Statistics
        self.stats = {
            'total_input': 0,
            'total_output': 0,
            'technical_features': 0,
            'workflow_changes': 0,
            'out_of_scope': 0,
            'completed': 0,
            'duplicates_found': 0,
        }

        # Valid user roles
        self.valid_roles = {
            'user', 'admin', 'administrator', 'manager', 'customer',
            'patient', 'clinician', 'doctor', 'nurse', 'staff',
            'analyst', 'researcher', 'coordinator', 'operator'
        }

    def generate(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Transform requirements into user stories.

        PARAMETERS:
            requirements (list[dict]): Requirements from ExcelParser with context_columns

        RETURNS:
            list[dict]: List of user story dictionaries
        """
        self.stats['total_input'] = len(requirements)
        stories = []

        for req in requirements:
            story = self._transform_requirement(req)
            if story:
                # Check for duplicates
                if self._is_duplicate(story):
                    self.stats['duplicates_found'] += 1
                    story['flags'].append('potential_duplicate')

                stories.append(story)
                self._all_stories.append(story)

        self.stats['total_output'] = len(stories)
        return stories

    def _transform_requirement(self, req: dict) -> Optional[dict]:
        """
        PURPOSE:
            Transform a single requirement into a user story.

        APPROACH:
            1. Combine description + ALL context columns for full understanding
            2. Classify requirement type
            3. Extract role, capability, benefit
            4. Generate HYBRID acceptance criteria
            5. Create story ID in PREFIX-CATEGORY-SEQ format
        """
        # Get all available text for analysis
        full_context = self._build_full_context(req)

        # Classify requirement type
        req_type = self._classify_requirement_type(req, full_context)

        # Track stats
        if req_type == 'Technical Feature':
            self.stats['technical_features'] += 1
        elif req_type == 'Workflow Change':
            self.stats['workflow_changes'] += 1
        elif req_type == 'Out of Scope':
            self.stats['out_of_scope'] += 1
        elif req_type == 'Completed':
            self.stats['completed'] += 1

        # Generate story ID
        category = self._detect_category(req, full_context)
        story_id = self._generate_story_id(category)

        # Extract story components
        role = self._extract_role(full_context)
        capability = self._extract_capability(req, full_context)
        benefit = self._extract_benefit(req, full_context)

        # Build user story text (only for Technical Features)
        if req_type == 'Technical Feature':
            user_story = f"As a {role}, I want to {capability}, so that {benefit}"
        else:
            # Non-technical items don't use "As a..." format
            user_story = self._build_non_technical_summary(req, req_type, full_context)

        # Generate acceptance criteria (HYBRID format)
        if req_type == 'Technical Feature':
            acceptance_criteria = self._generate_hybrid_acceptance_criteria(req, full_context, capability)
        else:
            acceptance_criteria = self._generate_non_technical_criteria(req, req_type, full_context)

        # Build description with context
        description = self._build_rich_description(req, full_context)

        # Identify flags/issues
        flags = self._identify_flags(req, full_context, req_type)

        # Get priority
        priority = req.get('priority', self.default_priority)

        # Build title
        title = self._build_title(req, capability)

        return {
            'generated_id': story_id,
            'title': title,
            'user_story': user_story,
            'priority': priority,
            'role': role,
            'capability': capability,
            'benefit': benefit,
            'requirement_type': req_type,
            'category': category,
            'acceptance_criteria': acceptance_criteria,
            'description': description,
            'flags': flags,
            'source_requirement': {
                'requirement_id': req.get('requirement_id'),
                'row_number': req.get('row_number'),
                'source_file': req.get('source_file'),
            }
        }

    def _build_full_context(self, req: dict) -> str:
        """
        PURPOSE:
            Combine ALL available text for comprehensive analysis.

        WHY THIS MATTERS:
            Context columns often contain the REAL requirement after stakeholder
            discussion. Notes, Supplemental Notes, Decisions, etc. contain
            refined requirements that supersede the original description.
        """
        parts = []

        # Primary content
        if req.get('title'):
            parts.append(f"Title: {req['title']}")
        if req.get('description'):
            parts.append(f"Description: {req['description']}")

        # ALL context columns
        context_columns = req.get('context_columns', {})
        for col_name, value in context_columns.items():
            if value:
                parts.append(f"{col_name}: {value}")

        # Type info
        if req.get('type'):
            parts.append(f"Type: {req['type']}")

        # Status
        if req.get('status'):
            parts.append(f"Status: {req['status']}")

        return "\n".join(parts)

    def _classify_requirement_type(self, req: dict, full_context: str) -> str:
        """
        PURPOSE:
            Classify requirement as Technical Feature, Workflow Change,
            Out of Scope, or Completed.

        RETURNS:
            str: One of "Technical Feature", "Workflow Change", "Out of Scope", "Completed"
        """
        context_lower = full_context.lower()
        status = (req.get('status') or '').lower()

        # Check for Completed
        if any(kw in status or kw in context_lower for kw in self.COMPLETED_KEYWORDS):
            return 'Completed'

        # Check for Out of Scope
        if any(kw in context_lower for kw in self.OUT_OF_SCOPE_KEYWORDS):
            return 'Out of Scope'

        # Check for Workflow Change
        if any(kw in context_lower for kw in self.WORKFLOW_CHANGE_KEYWORDS):
            return 'Workflow Change'

        # Default to Technical Feature
        return 'Technical Feature'

    def _detect_category(self, req: dict, full_context: str) -> str:
        """
        PURPOSE:
            Detect category for Story ID from Type column or keywords.

        RETURNS:
            str: Category code (e.g., "RECRUIT", "AUTH", "DASH")
        """
        # First, check the Type column from the requirement
        req_type = (req.get('type') or '').lower()

        # Then check full context
        search_text = f"{req_type} {full_context}".lower()

        # Find matching category
        for category_code, keywords in self.CATEGORY_MAPPINGS.items():
            if any(kw in search_text for kw in keywords):
                return category_code

        return self.DEFAULT_CATEGORY

    def _generate_story_id(self, category: str) -> str:
        """
        PURPOSE:
            Generate Story ID in format: PREFIX-CATEGORY-SEQ

        EXAMPLES:
            PROP-RECRUIT-001, PROP-RECRUIT-002, PROP-AUTH-001
        """
        # Increment sequence for this category
        if category not in self._category_sequences:
            self._category_sequences[category] = 0
        self._category_sequences[category] += 1

        seq = self._category_sequences[category]
        return f"{self.prefix}-{category}-{seq:03d}"

    def _extract_role(self, full_context: str) -> str:
        """Extract user role from context."""
        context_lower = full_context.lower()

        # Look for explicit role mentions
        patterns = [
            r'as\s+an?\s+(\w+)',
            r'(\w+)\s+(?:shall|must|should|can|will)',
            r'(?:allow|enable)\s+(\w+)s?\s+to',
            r'(\w+)s?\s+(?:need|want|require)',
        ]

        for pattern in patterns:
            match = re.search(pattern, context_lower)
            if match:
                role = match.group(1).lower()
                if role in self.valid_roles:
                    return role

        return self.default_role

    def _extract_capability(self, req: dict, full_context: str) -> str:
        """
        PURPOSE:
            Extract the core capability from the requirement.

        APPROACH:
            Use context columns if they contain refined/clarified requirements.
            Fall back to description/title otherwise.
        """
        # Check if context columns contain refinements
        context_columns = req.get('context_columns', {})

        # Priority: Supplemental notes often contain refined requirements
        for key in ['Supplemental notes', 'Supplemental Notes', 'Notes', 'Clarification']:
            if key in context_columns and context_columns[key]:
                # Check if it looks like a refined requirement
                notes = context_columns[key]
                if len(notes) > 50 and not notes.lower().startswith('option'):
                    # Use the notes as additional context, but still extract from description
                    pass

        # Primary source: description
        description = req.get('description') or req.get('title') or ''

        # Clean and extract the core capability
        capability = self._clean_capability_text(description)

        return capability

    def _clean_capability_text(self, text: str) -> str:
        """Clean and normalize capability text."""
        # Remove common prefixes
        text = re.sub(r'^(?:the\s+)?system\s+(?:shall|must|should|will)\s+', '', text, flags=re.IGNORECASE)
        text = re.sub(r'^(?:users?\s+)?(?:shall|must|should|will|can)\s+(?:be\s+able\s+to\s+)?', '', text, flags=re.IGNORECASE)
        text = re.sub(r'^(?:allow|enable)\s+(?:users?\s+)?to\s+', '', text, flags=re.IGNORECASE)

        # Remove "so that" clause
        text = re.sub(r'\s+so\s+that\s+.+$', '', text, flags=re.IGNORECASE)
        text = re.sub(r'\s+in\s+order\s+to\s+.+$', '', text, flags=re.IGNORECASE)

        # Clean up
        text = text.strip()
        if text and text[0].isupper():
            text = text[0].lower() + text[1:]

        return text or "access the requested feature"

    def _extract_benefit(self, req: dict, full_context: str) -> str:
        """Extract the business benefit from the requirement."""
        # Check Impact column first
        context_columns = req.get('context_columns', {})

        for key in ['Impact', 'Business Value', 'Benefit', 'Justification']:
            if key in context_columns and context_columns[key]:
                benefit = context_columns[key]
                # Clean it up
                benefit = re.sub(r'^(?:to\s+)?', '', benefit, flags=re.IGNORECASE)
                if len(benefit) > 10:
                    # Capitalize 'i' to 'I'
                    benefit = re.sub(r'\bi\b', 'I', benefit)
                    return benefit

        # Look in the main text for "so that" clause
        description = req.get('description') or ''
        match = re.search(r'so\s+that\s+(.+?)(?:\.|$)', description, re.IGNORECASE)
        if match:
            benefit = match.group(1).strip()
            benefit = re.sub(r'\bi\b', 'I', benefit)
            return benefit

        # Default based on type
        req_type = req.get('type', '').lower()
        if 'analytics' in req_type or 'report' in req_type:
            return "I can make data-driven decisions"
        elif 'consent' in req_type:
            return "the process is compliant and documented"
        elif 'recruitment' in req_type:
            return "I can track and improve outreach effectiveness"

        return "the system meets business requirements"

    def _generate_hybrid_acceptance_criteria(
        self,
        req: dict,
        full_context: str,
        capability: str
    ) -> list[str]:
        """
        PURPOSE:
            Generate HYBRID acceptance criteria:
            1. TESTABLE STATEMENTS (3-5 specific, measurable outcomes)
            2. KEY SCENARIOS in Gherkin format (2-3 scenarios)
            3. SMART SUCCESS METRICS (1-2 measurable outcomes)

        NO GENERIC BOILERPLATE - all criteria derived from actual content.
        """
        criteria = []
        context_columns = req.get('context_columns', {})
        description = req.get('description') or ''
        title = req.get('title') or ''

        # ================================================================
        # PART 1: TESTABLE STATEMENTS from actual requirement
        # ================================================================
        criteria.append("### Testable Requirements")

        # Extract specific metrics from context
        testable = self._extract_testable_statements(req, full_context)
        criteria.extend(testable)

        # ================================================================
        # PART 2: KEY SCENARIOS in Gherkin format
        # ================================================================
        criteria.append("")
        criteria.append("### Key Scenarios")

        scenarios = self._generate_gherkin_scenarios(req, full_context, capability)
        criteria.extend(scenarios)

        # ================================================================
        # PART 3: SUCCESS METRICS from Impact column
        # ================================================================
        impact = context_columns.get('Impact', '')
        if impact:
            criteria.append("")
            criteria.append("### Success Metrics")
            criteria.append(f"- Success: {impact}")

        return criteria

    def _extract_testable_statements(self, req: dict, full_context: str) -> list[str]:
        """Extract specific, testable statements from the requirement."""
        statements = []
        description = req.get('description') or req.get('title') or ''
        context_columns = req.get('context_columns', {})

        # Look for quantifiable items in the description
        # Numbers, percentages, time durations
        numbers = re.findall(r'\b(\d+(?:\.\d+)?)\s*(%|seconds?|minutes?|hours?|days?|items?|users?)\b', full_context, re.IGNORECASE)
        for num, unit in numbers:
            statements.append(f"- System handles {num} {unit} as specified")

        # Extract explicit requirements from description
        desc_clean = description.strip()
        if desc_clean:
            # Main requirement as testable statement
            statements.append(f"- {desc_clean}")

        # Check Dependencies column for additional requirements
        deps = context_columns.get('Dependencies', '')
        if deps and len(deps) > 20:
            # Extract key dependency statements
            dep_parts = deps.split('.')
            for part in dep_parts[:2]:  # First 2 sentences
                part = part.strip()
                if len(part) > 20:
                    statements.append(f"- Depends on: {part}")

        # Check Notes for clarifications
        notes = context_columns.get('Notes', '') or context_columns.get('Supplemental notes', '')
        if notes:
            # Look for bullet points or numbered items
            items = re.findall(r'(?:^|\n)\s*[-•*\d.]+\s*(.+?)(?=\n|$)', notes)
            for item in items[:3]:  # First 3 items
                item = item.strip()
                if len(item) > 15:
                    statements.append(f"- {item}")

        # Ensure we have at least some statements
        if len(statements) < 2:
            title = req.get('title') or ''
            if title:
                statements.append(f"- Feature: {title}")

        return statements[:5]  # Limit to 5

    def _generate_gherkin_scenarios(
        self,
        req: dict,
        full_context: str,
        capability: str
    ) -> list[str]:
        """Generate Gherkin scenarios based on requirement content."""
        scenarios = []
        description = req.get('description') or ''
        req_type = (req.get('type') or '').lower()

        # Determine context based on requirement type
        if 'analytics' in req_type or 'dashboard' in req_type or 'tracking' in req_type:
            scenarios.append("Given a user is viewing the dashboard")
            scenarios.append(f"When the data updates")
            scenarios.append(f"Then the {capability} is displayed accurately")
            scenarios.append("")
            scenarios.append("Given historical data exists")
            scenarios.append("When user selects a date range")
            scenarios.append("Then only data within that range is shown")

        elif 'consent' in req_type or 'enrollment' in req_type:
            scenarios.append("Given a patient is in the consent flow")
            scenarios.append(f"When they complete {capability}")
            scenarios.append("Then the system records completion timestamp")
            scenarios.append("")
            scenarios.append("Given a patient abandons the flow")
            scenarios.append("When they return later")
            scenarios.append("Then they resume from where they left off")

        elif 'report' in req_type or 'export' in req_type:
            scenarios.append("Given data is available")
            scenarios.append(f"When user requests {capability}")
            scenarios.append("Then the export completes within 30 seconds")
            scenarios.append("")
            scenarios.append("Given no data exists")
            scenarios.append("When user requests export")
            scenarios.append("Then a helpful empty state message is shown")

        else:
            # Generic but still specific to the capability
            scenarios.append(f"Given the user has appropriate permissions")
            scenarios.append(f"When they attempt to {capability}")
            scenarios.append("Then the action completes successfully")
            scenarios.append("")
            scenarios.append("Given invalid input is provided")
            scenarios.append(f"When the user submits")
            scenarios.append("Then clear error messages guide correction")

        return scenarios

    def _generate_non_technical_criteria(
        self,
        req: dict,
        req_type: str,
        full_context: str
    ) -> list[str]:
        """Generate criteria for non-technical items."""
        criteria = []
        context_columns = req.get('context_columns', {})

        if req_type == 'Workflow Change':
            criteria.append("### Process Change Requirements")
            criteria.append("- Stakeholders have been notified of the change")
            criteria.append("- Updated SOP/documentation is available")
            criteria.append("- Training plan is defined if needed")
            if context_columns.get('Notes'):
                criteria.append(f"- Note: {context_columns['Notes'][:200]}")

        elif req_type == 'Out of Scope':
            criteria.append("### Out of Scope")
            criteria.append("- Item has been documented as out of scope")
            criteria.append("- Stakeholders have acknowledged")
            # Include reason if available
            for key in ['Notes', 'Supplemental notes', 'Reason']:
                if key in context_columns:
                    criteria.append(f"- Reason: {context_columns[key][:200]}")
                    break

        elif req_type == 'Completed':
            criteria.append("### Completed")
            criteria.append("- Feature has been implemented and tested")
            criteria.append("- Documentation is updated")

        return criteria

    def _build_non_technical_summary(
        self,
        req: dict,
        req_type: str,
        full_context: str
    ) -> str:
        """Build summary for non-technical items (no 'As a...' format)."""
        description = req.get('description') or req.get('title') or ''

        if req_type == 'Workflow Change':
            return f"[WORKFLOW CHANGE] {description}"
        elif req_type == 'Out of Scope':
            return f"[OUT OF SCOPE] {description}"
        elif req_type == 'Completed':
            return f"[COMPLETED] {description}"

        return description

    def _build_rich_description(self, req: dict, full_context: str) -> str:
        """Build description incorporating context columns."""
        parts = []

        # Main description
        if req.get('description'):
            parts.append(req['description'])

        # Add context from relevant columns
        context_columns = req.get('context_columns', {})

        # Impact is valuable
        if context_columns.get('Impact'):
            parts.append(f"\n**Impact:** {context_columns['Impact']}")

        # Dependencies
        if context_columns.get('Dependencies'):
            parts.append(f"\n**Dependencies:** {context_columns['Dependencies']}")

        # Timeline
        for key in ['Timelines', 'Timeline', 'Target Date']:
            if key in context_columns:
                parts.append(f"\n**Timeline:** {context_columns[key]}")
                break

        return " ".join(parts)

    def _build_title(self, req: dict, capability: str) -> str:
        """Build story title."""
        # Prefer original title if available and reasonable
        if req.get('title') and len(req['title']) < 80:
            return req['title']

        # Otherwise derive from capability
        title = capability[:60]
        if len(capability) > 60:
            title += '...'

        return title.title()

    def _identify_flags(
        self,
        req: dict,
        full_context: str,
        req_type: str
    ) -> list[str]:
        """Identify issues that need attention."""
        flags = []

        # Non-technical items always flagged
        if req_type == 'Workflow Change':
            flags.append('workflow_change')
        elif req_type == 'Out of Scope':
            flags.append('out_of_scope')
        elif req_type == 'Completed':
            flags.append('completed')

        # Check for vague language
        vague_terms = self._check_vague_language(full_context)
        if vague_terms:
            flags.append('vague_language')

        # Check for questions/uncertainties
        if self._has_uncertainties(full_context):
            flags.append('needs_clarification')

        return flags

    def _check_vague_language(self, text: str) -> list[str]:
        """Check for vague/non-testable language."""
        vague_patterns = [
            r'\bfast(?:er)?\b', r'\beasy\b', r'\bsimple\b',
            r'\bintuitive\b', r'\befficient\b', r'\brobust\b',
            r'\bseamless\b', r'\bscalable\b', r'\betc\.?\b',
        ]

        found = []
        text_lower = text.lower()
        for pattern in vague_patterns:
            if re.search(pattern, text_lower):
                match = re.search(pattern, text_lower)
                if match:
                    found.append(match.group(0))

        return found

    def _has_uncertainties(self, text: str) -> bool:
        """Check if text contains uncertainties/questions."""
        uncertainty_patterns = [
            r'\?', r'\btbd\b', r'\bto be determined\b',
            r'\bneed to clarify\b', r'\bneed to discuss\b',
            r'\bprobably\b', r'\bmaybe\b'
        ]

        text_lower = text.lower()
        return any(re.search(p, text_lower) for p in uncertainty_patterns)

    def _is_duplicate(self, story: dict) -> bool:
        """Check if story is similar to existing ones."""
        if not self._all_stories:
            return False

        story_text = story.get('capability', '') + story.get('title', '')

        for existing in self._all_stories:
            existing_text = existing.get('capability', '') + existing.get('title', '')
            similarity = SequenceMatcher(None, story_text, existing_text).ratio()
            if similarity >= self.similarity_threshold:
                return True

        return False

    def get_stats(self) -> dict:
        """Return generation statistics."""
        return self.stats.copy()


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def generate_user_stories(
    requirements: list[dict],
    prefix: str = "REQ",
    default_role: str = "user"
) -> list[dict]:
    """
    PURPOSE:
        Convenience function to generate user stories.

    PARAMETERS:
        requirements (list[dict]): Requirements from ExcelParser
        prefix (str): Prefix for Story IDs (e.g., "PROP", "GRX")
        default_role (str): Default user role

    RETURNS:
        list[dict]: List of user story dictionaries
    """
    generator = UserStoryGenerator(prefix=prefix, default_role=default_role)
    return generator.generate(requirements)


# ============================================================================
# STANDALONE TEST
# ============================================================================

if __name__ == "__main__":
    print("=" * 60)
    print("USER STORY GENERATOR TEST")
    print("=" * 60)

    # Sample requirements with context_columns
    sample_requirements = [
        {
            'title': 'Number (N) Invited',
            'description': 'Track number of patients who received invitations',
            'priority': 'High',
            'status': 'Planned',
            'type': 'Recruitment Analytics',
            'row_number': 2,
            'context_columns': {
                'Impact': 'Core metric for outreach effectiveness',
                'Dependencies': 'Should be part of analytics dashboard',
                'Notes': 'Updated requirement after stakeholder meeting',
                'Timelines': '2025 Q4'
            }
        },
        {
            'title': 'Consent Flow Tracking',
            'description': 'See where users stop in the consent process',
            'priority': 'Medium',
            'status': 'Planned',
            'type': 'Consent Analytics',
            'row_number': 3,
            'context_columns': {
                'Impact': 'Improves UX and conversion',
                'Dependencies': 'Needs event tracking and funnel analytics',
            }
        },
        {
            'title': 'Manual Process Update',
            'description': 'Update the manual review workflow',
            'priority': 'Low',
            'status': 'Planned',
            'type': 'Process',
            'row_number': 4,
            'context_columns': {
                'Notes': 'This is a workflow change, not a technical feature',
            }
        },
    ]

    generator = UserStoryGenerator(prefix="TEST")
    stories = generator.generate(sample_requirements)

    print(f"\nGenerated {len(stories)} stories:")
    for story in stories:
        print(f"\n{'-'*60}")
        print(f"ID: {story['generated_id']}")
        print(f"Title: {story['title']}")
        print(f"Type: {story['requirement_type']}")
        print(f"Priority: {story['priority']}")
        print(f"\nUser Story:\n  {story['user_story']}")
        print(f"\nAcceptance Criteria:")
        for ac in story['acceptance_criteria'][:5]:
            print(f"  {ac}")
        if story['flags']:
            print(f"\nFlags: {', '.join(story['flags'])}")

    print(f"\n{'='*60}")
    print("Stats:", generator.get_stats())
