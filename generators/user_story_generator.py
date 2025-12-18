# generators/user_story_generator.py
# ============================================================================
# PURPOSE: Transform raw requirements into well-formed user stories
#
# Think of this module as the "requirements refinery" — it takes crude,
# inconsistent requirement text and refines it into standardized user stories
# that follow INVEST criteria and include proper acceptance criteria.
#
# INVEST Criteria (what makes a good user story):
#   I - Independent: Can be developed without depending on other stories
#   N - Negotiable: Details can be discussed, not a rigid contract
#   V - Valuable: Delivers value to the user/business
#   E - Estimable: Team can estimate the effort required
#   S - Small: Can be completed in one sprint
#   T - Testable: Has clear acceptance criteria
#
# This is like going from raw flight data to a proper flight plan —
# we take messy inputs and produce something that can actually be executed.
# ============================================================================

import re
from typing import Optional
from difflib import SequenceMatcher

# We'll use this for generating unique IDs when originals are missing
import hashlib


class UserStoryGenerator:
    """
    PURPOSE:
        Transforms raw requirement dictionaries (from ExcelParser) into
        well-formed user stories with acceptance criteria, following
        INVEST principles and handling messy real-world data.

    R EQUIVALENT:
        Like a dplyr pipeline that transforms and enriches data:
        requirements %>%
            split_compound() %>%
            transform_to_story() %>%
            add_acceptance_criteria() %>%
            flag_issues() %>%
            detect_duplicates()

    WHY A CLASS:
        We need to maintain state across transformations:
        - Track all stories for duplicate detection
        - Maintain configuration settings
        - Keep statistics on transformations performed

    USAGE:
        generator = UserStoryGenerator()
        stories = generator.generate(requirements_list)
        # stories is now a list of well-formed user story dicts
    """

    def __init__(
        self,
        default_role: str = "user",
        default_priority: str = "Medium",
        similarity_threshold: float = 0.75
    ) -> None:
        """
        PURPOSE:
            Initialize the generator with configuration settings.

        R EQUIVALENT:
            Like setting up function parameters with defaults:
            generate_stories <- function(reqs, default_role = "user", ...)

        PARAMETERS:
            default_role (str): The user role to use when none can be inferred
                               Example: "user", "administrator", "customer"

            default_priority (str): Priority to assign when none is found
                                   Example: "Medium"

            similarity_threshold (float): How similar two requirements must be
                                         to be flagged as potential duplicates.
                                         0.0 = nothing matches, 1.0 = exact match
                                         0.75 is a good balance (75% similar)

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            Configurable defaults let the generator adapt to different projects.
            A healthcare app might default to "clinician" role, while a
            consumer app defaults to "user".
        """
        self.default_role = default_role
        self.default_priority = default_priority
        self.similarity_threshold = similarity_threshold

        # Track all generated stories for duplicate detection
        # We compare new stories against this list
        self._all_stories: list[dict] = []

        # Statistics tracking — helpful for reporting
        self.stats = {
            'total_input': 0,
            'total_output': 0,
            'compound_split': 0,
            'vague_flagged': 0,
            'duplicates_found': 0,
            'priority_inferred': 0,
        }

        # ====================================================================
        # PATTERNS FOR REQUIREMENT ANALYSIS
        # ====================================================================

        # Patterns that indicate compound requirements (multiple things in one)
        # These suggest we should split the requirement into multiple stories
        self.compound_indicators = [
            r',\s*and\s+',           # "do X, and Y"
            r'\s+and\s+',            # "do X and Y"
            r';\s*',                  # "do X; do Y"
            r'\.\s+[A-Z]',           # "Do X. Do Y" (sentence break)
            r',\s*(?=\w+\s+(?:shall|must|should|can|will))',  # "X shall, Y shall"
        ]

        # Phrases that suggest vague/non-testable requirements
        # These need human clarification before becoming proper stories
        self.vague_indicators = [
            r'\bfast(?:er)?\b',           # "make it fast" - how fast?
            r'\bslow(?:er)?\b',           # "not slow"
            r'\beasy\b',                  # "easy to use" - subjective
            r'\bsimple\b',                # "simple interface"
            r'\buser[- ]?friendly\b',     # vague UX term
            r'\bintuitive\b',             # vague UX term
            r'\befficient(?:ly)?\b',      # how efficient?
            r'\bimprove[ds]?\b',          # improve how much?
            r'\bbetter\b',                # better than what?
            r'\bnice\b',                  # "nice to have"
            r'\bgood\b',                  # "good performance"
            r'\bquick(?:ly)?\b',          # how quick?
            r'\bseamless(?:ly)?\b',       # vague integration term
            r'\brobust\b',                # vague quality term
            r'\bscalable\b',              # without metrics
            r'\bsecure\b',                # without specifics
            r'\betc\.?\b',                # trailing "etc" = incomplete
            r'\band\s+(?:more|others?)\b', # "and more" = incomplete
            r'\bas\s+needed\b',           # undefined scope
            r'\bas\s+appropriate\b',      # undefined criteria
        ]

        # Words that indicate questions or uncertainties (not real requirements)
        self.question_indicators = [
            r'^\s*\?+',                   # starts with ?
            r'\?\s*$',                    # ends with ?
            r'^what\s+about\b',           # "what about X?"
            r'^how\s+(?:do|should|will)', # "how do we..."
            r'^should\s+we\b',            # "should we..."
            r'^do\s+we\s+need\b',         # "do we need..."
            r'^todo\b',                   # todo item
            r'^tbd\b',                    # to be determined
            r'^tbdetermined\b',
            r'need\s+to\s+discuss',       # discussion item
            r'need\s+to\s+clarify',
            r'out\s+of\s+scope',          # scoping note
            r'probably\s+not',            # uncertainty
        ]

        # Patterns to extract user role from requirement text
        # "As a manager, I want..." -> role = "manager"
        self.role_patterns = [
            r'as\s+an?\s+(\w+)',                    # "as a user" / "as an admin"
            r'(\w+)\s+(?:shall|must|should|can)',  # "admin shall be able"
            r'(?:allow|enable)\s+(\w+)s?\s+to',    # "allow users to"
            r'(\w+)s?\s+(?:need|want|require)',    # "users need to"
        ]

        # Common role keywords to validate extracted roles
        self.valid_roles = {
            'user', 'users', 'admin', 'administrator', 'manager', 'customer',
            'client', 'member', 'guest', 'visitor', 'owner', 'operator',
            'analyst', 'developer', 'tester', 'reviewer', 'approver',
            'patient', 'clinician', 'doctor', 'nurse', 'staff', 'employee',
            'system', 'service', 'application', 'api',
        }

    def generate(self, requirements: list[dict]) -> list[dict]:
        """
        PURPOSE:
            Main entry point. Takes a list of raw requirements and transforms
            them into well-formed user stories.

        R EQUIVALENT:
            Like the main pipeline function:
            generate <- function(requirements) {
                requirements %>%
                    purrr::map(transform_one) %>%
                    purrr::flatten() %>%  # because one req might become many
                    detect_duplicates()
            }

        PARAMETERS:
            requirements (list[dict]): List of requirement dicts from ExcelParser
                                      Each should have at least 'raw_text' or
                                      'description' and 'row_number'

        RETURNS:
            list[dict]: List of user story dictionaries, each with:
                - title: Short title for the story
                - user_story: "As a [role], I want [X], so that [Y]"
                - priority: Critical/High/Medium/Low
                - description: Additional context
                - acceptance_criteria: List of testable conditions
                - source_requirement: Original requirement for traceability
                - flags: List of issues (vague, needs_clarification, etc.)
                - generated_id: Unique ID for this story

        WHY THIS APPROACH:
            Process requirements one at a time to allow compound splitting
            (one requirement can become multiple stories). Then do a second
            pass for duplicate detection (needs all stories to compare).
        """
        self.stats['total_input'] = len(requirements)
        self._all_stories = []

        # ================================================================
        # PHASE 1: Transform each requirement into one or more stories
        # ================================================================
        for req in requirements:
            # Skip empty or non-requirement entries
            if self._should_skip(req):
                continue

            # Transform this requirement (might produce multiple stories)
            stories = self._transform_requirement(req)

            # Add each generated story to our collection
            for story in stories:
                self._all_stories.append(story)

        # ================================================================
        # PHASE 2: Detect duplicates across all stories
        # ================================================================
        self._detect_duplicates()

        self.stats['total_output'] = len(self._all_stories)
        return self._all_stories

    def _should_skip(self, req: dict) -> bool:
        """
        PURPOSE:
            Determine if a requirement should be skipped (not a real requirement).

        R EQUIVALENT:
            Like a filter predicate:
            should_skip <- function(req) {
                is_question(req) | is_section_header(req) | is_empty(req)
            }

        PARAMETERS:
            req (dict): A requirement dictionary

        RETURNS:
            bool: True if this should be skipped, False to process it

        WHY THIS APPROACH:
            We filter out non-requirements early to avoid creating junk stories.
            Questions, section headers, and notes aren't real requirements.
        """
        # Get the main text content
        text = req.get('description') or req.get('raw_text') or ''
        text = text.strip()

        # Skip if empty or too short
        if len(text) < 5:
            return True

        # Skip if it looks like a section header (ALL CAPS, ends with colon)
        if text.isupper() and len(text.split()) <= 5:
            return True
        if text.endswith(':') and len(text.split()) <= 5:
            return True

        # Skip if it looks like a question or discussion item
        text_lower = text.lower()
        for pattern in self.question_indicators:
            if re.search(pattern, text_lower):
                return True

        # Skip if it's just a parenthetical note
        if text.startswith('(') and text.endswith(')'):
            return True

        return False

    def _transform_requirement(self, req: dict) -> list[dict]:
        """
        PURPOSE:
            Transform a single requirement into one or more user stories.
            Handles compound requirements by splitting them.

        R EQUIVALENT:
            Like a function that might return multiple rows:
            transform_one <- function(req) {
                if (is_compound(req)) split_and_transform(req)
                else list(transform_simple(req))
            }

        PARAMETERS:
            req (dict): A single requirement dictionary

        RETURNS:
            list[dict]: One or more user story dictionaries

        WHY THIS APPROACH:
            Compound requirements (X, Y, and Z) should become separate stories
            so each can be estimated, prioritized, and tracked independently.
            This follows the INVEST principle of keeping stories small and focused.
        """
        text = req.get('description') or req.get('raw_text') or ''

        # Check if this is a compound requirement that should be split
        if self._is_compound_requirement(text):
            sub_requirements = self._split_compound_requirement(text)
            self.stats['compound_split'] += len(sub_requirements) - 1

            # Transform each sub-requirement into a story
            stories = []
            for i, sub_text in enumerate(sub_requirements):
                # Create a modified requirement dict for each sub-part
                sub_req = req.copy()
                sub_req['raw_text'] = sub_text
                sub_req['description'] = sub_text
                sub_req['_split_index'] = i + 1
                sub_req['_split_total'] = len(sub_requirements)

                story = self._create_user_story(sub_req)
                stories.append(story)

            return stories
        else:
            # Single requirement -> single story
            return [self._create_user_story(req)]

    def _is_compound_requirement(self, text: str) -> bool:
        """
        PURPOSE:
            Detect if a requirement contains multiple distinct requirements
            that should be split into separate user stories.

        R EQUIVALENT:
            is_compound <- function(text) {
                any(str_detect(text, compound_patterns))
            }

        PARAMETERS:
            text (str): The requirement text to analyze

        RETURNS:
            bool: True if this appears to be a compound requirement

        WHY THIS APPROACH:
            Compound requirements violate INVEST — they're not small, not
            easily estimable, and harder to test. We split them for better
            agile practices.

            However, we need to be careful not to over-split. "Upload and
            process files" might be one logical action, while "upload files,
            delete files, and share files" is clearly three separate features.
        """
        # Don't try to split very short text
        if len(text) < 30:
            return False

        # Count how many action verbs appear in the text
        # Multiple verbs often indicate multiple requirements
        action_verbs = [
            'create', 'read', 'update', 'delete', 'view', 'edit', 'add',
            'remove', 'upload', 'download', 'export', 'import', 'send',
            'receive', 'login', 'logout', 'register', 'submit', 'approve',
            'reject', 'search', 'filter', 'sort', 'generate', 'display'
        ]

        text_lower = text.lower()
        verb_count = sum(1 for verb in action_verbs if verb in text_lower)

        # If we have 3+ distinct action verbs, likely compound
        if verb_count >= 3:
            return True

        # Check for explicit compound patterns
        for pattern in self.compound_indicators:
            if re.search(pattern, text, re.IGNORECASE):
                # Additional check: make sure there's substantial content
                # after the split point (not just "and more" or "etc.")
                parts = re.split(pattern, text, flags=re.IGNORECASE)
                substantial_parts = [p for p in parts if len(p.strip()) > 10]
                if len(substantial_parts) >= 2:
                    return True

        return False

    def _split_compound_requirement(self, text: str) -> list[str]:
        """
        PURPOSE:
            Split a compound requirement into individual requirement statements.

        R EQUIVALENT:
            Like str_split() with cleanup:
            split_compound <- function(text) {
                parts <- str_split(text, pattern)[[1]]
                parts %>% str_trim() %>% keep(~ nchar(.) > 10)
            }

        PARAMETERS:
            text (str): The compound requirement text

        RETURNS:
            list[str]: List of individual requirement statements

        WHY THIS APPROACH:
            We try multiple split strategies IN ORDER OF RELIABILITY:
            1. Sentence boundaries (most reliable - explicit separation)
            2. Semicolons (explicit separation)
            3. Comma-separated action lists (with verb reconstruction)
            4. "and" between clauses (only when both sides have verbs)

            The order matters! We avoid splitting "PDF and Excel" by trying
            sentence boundaries first and only splitting on "and" when both
            sides are complete clauses with verbs.
        """
        # ================================================================
        # Strategy 1: Split on SENTENCE BOUNDARIES (most reliable)
        # ================================================================
        # "Reports must be exportable. Reports should include charts."
        # This is the cleanest split — each sentence is a complete thought.
        parts = re.split(r'\.\s+(?=[A-Z])', text)
        if len(parts) >= 2:
            # Add periods back to parts (except last which keeps its own punctuation)
            parts_with_periods = [p.strip() + '.' if not p.strip().endswith('.') else p.strip()
                                  for p in parts[:-1]]
            parts_with_periods.append(parts[-1].strip())
            valid_parts = self._validate_split_parts(parts_with_periods, text, require_verb=True)
            if valid_parts:
                return valid_parts

        # ================================================================
        # Strategy 2: Split on SEMICOLONS (explicit compound marker)
        # ================================================================
        # "Login via email; login via SSO; login via phone"
        parts = re.split(r';\s*', text)
        if len(parts) >= 2:
            valid_parts = self._validate_split_parts(parts, text, require_verb=True)
            if valid_parts:
                return valid_parts

        # ================================================================
        # Strategy 3: Split COMMA-SEPARATED ACTION LISTS
        # ================================================================
        # "User can view their profile, edit their profile, upload a picture"
        # Look for pattern: "can/shall/must [verb] X, [verb] Y, [verb] Z"
        # We reconstruct each part with the subject + modal verb prefix.
        list_pattern = r'(?:can|shall|must|should|will)\s+(.+)'
        match = re.search(list_pattern, text, re.IGNORECASE)
        if match:
            action_list = match.group(1)
            # Split on commas (but not ", and" which we handle separately)
            parts = re.split(r',\s*(?!and\b)', action_list)
            # Also handle trailing ", and X"
            if parts:
                last_part = parts[-1]
                if ' and ' in last_part.lower():
                    # Split "X and Y" at the end
                    and_parts = re.split(r'\s+and\s+', last_part, flags=re.IGNORECASE)
                    parts = parts[:-1] + and_parts

            if len(parts) >= 2:
                # Reconstruct each part with the modal verb context
                prefix_match = re.match(r'^(.+?(?:can|shall|must|should|will))\s+',
                                       text, re.IGNORECASE)
                if prefix_match:
                    prefix = prefix_match.group(1)
                    reconstructed = [f"{prefix} {part.strip()}" for part in parts
                                    if len(part.strip()) > 3]
                    if len(reconstructed) >= 2:
                        return reconstructed

        # ================================================================
        # Strategy 4: Split on "AND" BETWEEN CLAUSES (careful!)
        # ================================================================
        # Only split on " and " when BOTH sides contain a verb.
        # This avoids splitting "PDF and Excel" or "charts and graphs".
        # "Users can login and users can logout" -> split
        # "Export to PDF and Excel" -> DON'T split

        # Check if there's an " and " that connects two verb phrases
        and_match = re.search(r'(.+)\s+and\s+(.+)', text, re.IGNORECASE)
        if and_match:
            left_part = and_match.group(1).strip()
            right_part = and_match.group(2).strip()

            # Only split if BOTH parts have a verb (are complete clauses)
            if self._has_verb(left_part) and self._has_verb(right_part):
                valid_parts = self._validate_split_parts([left_part, right_part], text, require_verb=True)
                if valid_parts:
                    return valid_parts

        # ================================================================
        # Fallback: return original as single item
        # ================================================================
        return [text]

    def _has_verb(self, text: str) -> bool:
        """
        PURPOSE:
            Check if text contains a verb (indicating it's a complete clause).

        R EQUIVALENT:
            has_verb <- function(text) {
                any(str_detect(text, verb_patterns))
            }

        PARAMETERS:
            text (str): Text to check

        RETURNS:
            bool: True if text appears to contain a verb

        WHY THIS APPROACH:
            We use this to validate split parts — a sentence fragment without
            a verb (like "PDF and Excel") shouldn't be treated as a separate
            requirement. This prevents over-splitting on noun lists.
        """
        text_lower = text.lower()

        # Common requirement verbs (including modal patterns)
        verb_patterns = [
            r'\b(?:shall|must|should|can|will|may)\b',  # Modal verbs
            r'\b(?:is|are|was|were|be|been|being)\b',   # Be verbs
            r'\b(?:have|has|had)\b',                     # Have verbs
            r'\b(?:do|does|did)\b',                      # Do verbs
            # Action verbs common in requirements
            r'\b(?:create|read|update|delete|view|edit|add|remove)\b',
            r'\b(?:upload|download|export|import|send|receive)\b',
            r'\b(?:login|logout|register|submit|approve|reject)\b',
            r'\b(?:search|filter|sort|generate|display|show)\b',
            r'\b(?:allow|enable|support|provide|include|require)\b',
            r'\b(?:integrate|connect|sync|notify|alert)\b',
            r'\b(?:validate|verify|check|confirm|ensure)\b',
            r'\bable\s+to\b',  # "be able to"
        ]

        for pattern in verb_patterns:
            if re.search(pattern, text_lower):
                return True

        return False

    def _validate_split_parts(
        self,
        parts: list[str],
        original: str,
        require_verb: bool = False
    ) -> Optional[list[str]]:
        """
        PURPOSE:
            Validate that split parts are meaningful requirements, not fragments.

        R EQUIVALENT:
            Like filtering to keep valid elements:
            validate <- function(parts, require_verb = FALSE) {
                valid <- keep(parts, ~ nchar(.) > 10)
                if (require_verb) valid <- keep(valid, has_verb)
                if (length(valid) >= 2) valid else NULL
            }

        PARAMETERS:
            parts (list[str]): The candidate split parts
            original (str): The original text (for context)
            require_verb (bool): If True, each part must contain a verb
                                to be considered valid. This prevents
                                "PDF and Excel" from being split.

        RETURNS:
            Optional[list[str]]: Cleaned parts if valid, None if split was bad

        WHY THIS APPROACH:
            Bad splits produce fragments like "and delete records" that don't
            make sense standalone. We validate that each part could be a
            meaningful requirement on its own.
        """
        cleaned = []
        for part in parts:
            part = part.strip()

            # Skip very short fragments
            if len(part) < 10:
                continue

            # Skip if it's just "and X" or "or X" (orphaned conjunction)
            if re.match(r'^(?:and|or)\s+\w+$', part, re.IGNORECASE):
                continue

            # Skip trailing fragments like "etc." or "and more"
            if re.match(r'^(?:etc|and\s+more|and\s+others?)\.?$', part, re.IGNORECASE):
                continue

            # If require_verb is True, skip parts without a verb
            # This prevents splitting noun lists like "PDF and Excel"
            if require_verb and not self._has_verb(part):
                continue

            cleaned.append(part)

        # Need at least 2 valid parts for a meaningful split
        if len(cleaned) >= 2:
            return cleaned

        return None

    def _create_user_story(self, req: dict) -> dict:
        """
        PURPOSE:
            Create a complete user story dictionary from a requirement.
            This is the core transformation logic.

        R EQUIVALENT:
            Like creating a structured list with all story components:
            create_story <- function(req) {
                list(
                    title = generate_title(req),
                    user_story = format_user_story(req),
                    acceptance_criteria = generate_criteria(req),
                    ...
                )
            }

        PARAMETERS:
            req (dict): A requirement dictionary (possibly split from compound)

        RETURNS:
            dict: A complete user story dictionary

        WHY THIS APPROACH:
            We extract or generate each component of a proper user story:
            - Title for quick reference
            - User story format for clarity
            - Acceptance criteria for testability
            - Metadata for traceability and triage
        """
        text = req.get('description') or req.get('raw_text') or ''
        flags = []

        # ================================================================
        # Extract or infer the user role
        # ================================================================
        role = self._extract_role(text)
        if not role:
            role = self.default_role
            # Don't flag this — it's very common

        # ================================================================
        # Extract the capability (what the user wants to do)
        # ================================================================
        capability = self._extract_capability(text)

        # ================================================================
        # Extract or generate the benefit (why they want it)
        # ================================================================
        benefit = self._extract_benefit(text)

        # ================================================================
        # Generate the title
        # ================================================================
        title = self._generate_title(text, req)

        # ================================================================
        # Format the user story
        # ================================================================
        user_story = f"As a {role}, I want to {capability}, so that {benefit}."

        # ================================================================
        # Generate acceptance criteria
        # ================================================================
        acceptance_criteria = self._generate_acceptance_criteria(text, capability)

        # ================================================================
        # Determine priority
        # ================================================================
        priority = req.get('priority')
        if not priority:
            priority = self.default_priority
            self.stats['priority_inferred'] += 1
            flags.append('priority_inferred')

        # ================================================================
        # Check for vague/non-testable language
        # ================================================================
        vague_issues = self._check_for_vague_language(text)
        if vague_issues:
            flags.append('vague')
            flags.extend([f'vague_term:{term}' for term in vague_issues])
            self.stats['vague_flagged'] += 1

        # ================================================================
        # Build description with additional context
        # ================================================================
        description = self._build_description(req, flags)

        # ================================================================
        # Generate a unique ID for this story
        # ================================================================
        generated_id = self._generate_story_id(req, text)

        # ================================================================
        # Build the complete story dictionary
        # ================================================================
        story = {
            'title': title,
            'user_story': user_story,
            'priority': priority,
            'description': description,
            'acceptance_criteria': acceptance_criteria,
            'source_requirement': {
                'original_text': req.get('description') or req.get('raw_text'),
                'row_number': req.get('row_number'),
                'requirement_id': req.get('requirement_id'),
                'source_file': req.get('source_file'),
            },
            'flags': flags,
            'generated_id': generated_id,

            # Additional metadata
            'role': role,
            'capability': capability,
            'benefit': benefit,
            'category': req.get('category'),
            'status': req.get('status'),
            'timeline': req.get('timeline'),
        }

        return story

    def _extract_role(self, text: str) -> Optional[str]:
        """
        PURPOSE:
            Extract the user role from requirement text.
            "As a manager, I want..." -> "manager"

        R EQUIVALENT:
            Like str_extract with validation:
            extract_role <- function(text) {
                role <- str_extract(text, "as an? (\\w+)")
                if (role %in% valid_roles) role else NULL
            }

        PARAMETERS:
            text (str): The requirement text

        RETURNS:
            Optional[str]: The extracted role, or None if not found

        WHY THIS APPROACH:
            User stories need a clear "who" — the user role defines whose
            perspective the story is written from. We try to extract it
            from the text, falling back to a default if not found.
        """
        text_lower = text.lower()

        for pattern in self.role_patterns:
            match = re.search(pattern, text_lower)
            if match:
                potential_role = match.group(1).strip()

                # Validate it looks like a real role
                if potential_role in self.valid_roles:
                    return potential_role

                # Check for plural forms
                if potential_role.rstrip('s') in self.valid_roles:
                    return potential_role.rstrip('s')

        return None

    def _extract_capability(self, text: str) -> str:
        """
        PURPOSE:
            Extract what the user wants to be able to do.
            This becomes the "I want to [X]" part of the user story.

        R EQUIVALENT:
            Like extracting and cleaning the main action:
            extract_capability <- function(text) {
                # Remove the "As a X," prefix if present
                # Convert passive to active voice
                # Extract the main verb phrase
            }

        PARAMETERS:
            text (str): The requirement text

        RETURNS:
            str: The capability statement (cleaned and normalized)

        WHY THIS APPROACH:
            The capability is the core of what needs to be built. We try to
            extract it cleanly, removing boilerplate and normalizing the
            language to fit the "I want to [X]" format.

            Key transformations:
            - "The system shall allow X" → "X" (remove system-focused prefix)
            - "Users must be able to X" → "X" (remove user-focused prefix)
            - "X shall be sent" → "receive X" (passive to active)
            - "Dashboard should display X" → "see X on the dashboard" (reframe)
            - "Slack notifications" → "receive Slack notifications" (add verb)
        """
        capability = text.strip()

        # ================================================================
        # STEP 1: Remove common requirement prefixes
        # ================================================================
        # These patterns strip boilerplate from requirement text to get the
        # core capability. We handle many variations:
        # - "As a user, I want to X" → "X"
        # - "The system shall X" → "X"
        # - "System needs to X" → "X"
        # - "Users must be able to X" → "X"
        # - "Patients should be able to X" → "X"

        # Remove "As a [role], I want to" prefix
        capability = re.sub(
            r'^as\s+an?\s+\w+,?\s*(?:i\s+)?(?:want|need|should\s+be\s+able)\s+to\s*',
            '', capability, flags=re.IGNORECASE
        )

        # Remove "The system shall/must/should/will/needs to" type prefixes
        # Added "needs to" and "has to" patterns
        capability = re.sub(
            r'^(?:the\s+)?(?:system|application|software|platform|app)\s+'
            r'(?:shall|must|should|will|needs?\s+to|has\s+to)\s+',
            '', capability, flags=re.IGNORECASE
        )

        # Remove "[Role] shall/must/should/can/will be able to" type prefixes
        # Expanded to include: users, admins, patients, customers, clients,
        # members, staff, clinicians, managers, etc.
        capability = re.sub(
            r'^(?:users?|admins?|administrators?|patients?|customers?|clients?|'
            r'members?|staff|employees?|clinicians?|managers?|operators?)\s+'
            r'(?:shall|must|should|can|will|needs?\s+to|has\s+to)\s+'
            r'(?:be\s+able\s+to\s+)?',
            '', capability, flags=re.IGNORECASE
        )

        # Remove standalone "shall/must/should/needs to" at start
        # Catches: "Must validate...", "Should support...", "Needs to handle..."
        capability = re.sub(
            r'^(?:shall|must|should|needs?\s+to|has\s+to)\s+',
            '', capability, flags=re.IGNORECASE
        )

        # ================================================================
        # STEP 2: Handle passive voice constructions
        # ================================================================
        # "X shall be sent/displayed/generated" → "receive/view/generate X"

        # Map passive verbs to active equivalents
        # Includes both regular (-ed) and irregular past participles
        passive_to_active = {
            # Irregular past participles (don't end in -ed)
            'sent': 'receive',
            'shown': 'view',
            'made': 'create',
            'done': 'do',
            'built': 'build',
            'set': 'configure',
            'run': 'run',
            'given': 'provide',
            'taken': 'take',
            'written': 'write',
            'found': 'find',
            # Regular past participles (-ed)
            'displayed': 'view',
            'generated': 'generate',
            'created': 'create',
            'exported': 'export',
            'imported': 'import',
            'updated': 'update',
            'deleted': 'delete',
            'removed': 'remove',
            'added': 'add',
            'notified': 'receive notification',
            'alerted': 'receive alert',
            'saved': 'save',
            'loaded': 'load',
            'enabled': 'enable',
            'allowed': 'have',
            'supported': 'have',
            'provided': 'receive',
            'included': 'have',
            'required': 'have',
            'integrated': 'integrate',
            'connected': 'connect',
        }

        # Build regex pattern that matches any of the known past participles
        past_participles = '|'.join(passive_to_active.keys())

        # Pattern: "[Subject] shall/must/should be [past_participle] [rest]"
        passive_match = re.match(
            rf'^(.+?)\s+(?:shall|must|should|will|can)\s+be\s+({past_participles})\b\s*(.*)',
            capability, flags=re.IGNORECASE
        )
        if passive_match:
            subject = passive_match.group(1).strip()
            past_participle = passive_match.group(2).lower()
            rest = passive_match.group(3).strip()

            active_verb = passive_to_active.get(past_participle)
            if active_verb:
                # Reconstruct: "receive [subject] [rest]"
                capability = f"{active_verb} {subject}"
                if rest:
                    capability += f" {rest}"

        # Also handle "X must/shall be [adjective]able" patterns
        # "Reports must be exportable" → "export reports"
        able_match = re.match(
            r'^(.+?)\s+(?:shall|must|should|will|can)\s+be\s+(\w+)able\b\s*(.*)',
            capability, flags=re.IGNORECASE
        )
        if able_match:
            subject = able_match.group(1).strip()
            verb_root = able_match.group(2).lower()
            rest = able_match.group(3).strip()
            # "exportable" → "export", "downloadable" → "download"
            capability = f"{verb_root} {subject}"
            if rest:
                capability += f" {rest}"

        # ================================================================
        # STEP 3: Handle "[Subject] should/shall [verb]" patterns
        # ================================================================
        # "Dashboard should display X" → "view X on the dashboard"
        # "System should generate X" → "generate X"

        subject_verb_match = re.match(
            r'^(\w+)\s+(?:shall|must|should|will)\s+(\w+)\s+(.*)',
            capability, flags=re.IGNORECASE
        )
        if subject_verb_match:
            subject = subject_verb_match.group(1).lower()
            verb = subject_verb_match.group(2).lower()
            obj = subject_verb_match.group(3).strip()

            # UI elements as subjects → reframe to user perspective
            ui_subjects = ['dashboard', 'page', 'screen', 'form', 'report', 'system']
            if subject in ui_subjects:
                if verb in ['display', 'show', 'present']:
                    capability = f"view {obj} on the {subject}"
                elif verb in ['generate', 'create', 'produce']:
                    capability = f"generate {obj}"
                elif verb in ['allow', 'enable', 'let', 'permit']:
                    capability = obj  # "allow X" → just "X"
                else:
                    capability = f"{verb} {obj}"

        # ================================================================
        # STEP 3.5: Handle "allow [users/them] to [verb]" patterns
        # ================================================================
        # "allow users to login" → "login"
        allow_match = re.match(
            r'^(?:allow|enable|let|permit)\s+(?:users?|them|me|the\s+user)\s+to\s+(.+)',
            capability, flags=re.IGNORECASE
        )
        if allow_match:
            capability = allow_match.group(1).strip()

        # ================================================================
        # STEP 4: Handle noun phrases without verbs (add default verb)
        # ================================================================
        # "Slack notifications for critical alerts" → "receive Slack notifications..."

        # Check if capability starts with a verb (is already action-oriented)
        # This list should be comprehensive to avoid incorrectly prepending "have"
        action_verbs = [
            # CRUD operations
            'view', 'see', 'create', 'add', 'edit', 'update', 'delete', 'remove',
            'read', 'write', 'insert', 'modify', 'change',
            # Search/filter
            'search', 'find', 'filter', 'sort', 'query', 'browse', 'lookup',
            # Data movement
            'export', 'import', 'download', 'upload', 'send', 'receive', 'transfer',
            'load', 'save', 'store', 'retrieve', 'fetch', 'sync', 'backup',
            # Auth
            'login', 'logout', 'register', 'authenticate', 'authorize', 'sign',
            # Workflow
            'submit', 'approve', 'reject', 'review', 'assign', 'complete', 'finish',
            'cancel', 'confirm', 'verify', 'validate', 'check', 'process',
            # Display
            'generate', 'display', 'show', 'render', 'present', 'list', 'print',
            # System
            'allow', 'enable', 'disable', 'support', 'provide', 'require', 'ensure',
            'integrate', 'connect', 'link', 'attach', 'associate',
            'notify', 'alert', 'remind', 'warn', 'inform',
            'access', 'manage', 'control', 'handle', 'maintain',
            'configure', 'customize', 'setup', 'set', 'get', 'apply',
            # General
            'have', 'use', 'make', 'take', 'give', 'keep', 'hold',
            'reset', 'clear', 'refresh', 'reload',
            'select', 'choose', 'pick', 'specify', 'define',
            'enter', 'input', 'type', 'fill', 'capture',
            'click', 'press', 'tap', 'drag', 'drop',
            'open', 'close', 'expand', 'collapse', 'toggle',
            'start', 'stop', 'pause', 'resume', 'restart',
            'run', 'execute', 'perform', 'invoke', 'trigger', 'initiate',
            'copy', 'paste', 'cut', 'move', 'duplicate', 'clone',
            'track', 'monitor', 'log', 'record', 'audit', 'measure',
            'schedule', 'book', 'reserve', 'plan',
            'pay', 'charge', 'bill', 'refund', 'purchase', 'order',
        ]

        first_word = capability.split()[0].lower() if capability.split() else ''

        # Check if first word is a verb
        # Also handle hyphenated compound verbs like "self-register", "auto-generate"
        # by checking if the part after the hyphen is a verb
        has_verb = first_word in action_verbs
        if not has_verb and '-' in first_word:
            # Check the part after the hyphen (e.g., "register" in "self-register")
            verb_part = first_word.split('-')[-1]
            has_verb = verb_part in action_verbs

        if not has_verb and len(capability) > 5:
            # Infer appropriate verb based on content
            cap_lower = capability.lower()

            if any(word in cap_lower for word in ['notification', 'alert', 'email', 'message']):
                capability = f"receive {capability}"
            elif any(word in cap_lower for word in ['report', 'data', 'information']):
                capability = f"access {capability}"
            elif any(word in cap_lower for word in ['integration', 'connection', 'sync']):
                capability = f"have {capability}"
            elif any(word in cap_lower for word in ['feature', 'functionality', 'capability']):
                capability = f"use {capability}"
            else:
                # Generic fallback - "have" works for most noun phrases
                capability = f"have {capability}"

        # ================================================================
        # STEP 5: Final cleanup
        # ================================================================

        # Strip "so that..." suffix - this will be added back from _extract_benefit()
        # WHY: If the original text has "book appointments so that I don't have to call",
        # we want capability = "book appointments" and benefit = "I don't have to call"
        # Without this, we'd get "I want to book appointments so that I don't have to call,
        # so that I don't have to call" - duplicated!
        capability = re.sub(r'\s+so\s+that\s+.+$', '', capability, flags=re.IGNORECASE)

        # Also strip "in order to..." suffixes (same reason)
        capability = re.sub(r'\s+in\s+order\s+to\s+.+$', '', capability, flags=re.IGNORECASE)

        # Remove trailing punctuation
        capability = capability.rstrip('.')

        # If we stripped too much, fall back to original
        if len(capability) < 5:
            capability = text.rstrip('.')

        # Ensure it starts lowercase (for "I want to [x]" format)
        if capability and capability[0].isupper():
            # But not if it's an acronym (all caps word) or proper noun
            words = capability.split()
            if words:
                first = words[0]
                # Keep uppercase if it's an acronym (e.g., "API", "SSO")
                # or a proper noun we should preserve
                if not first.isupper() and first not in ['Salesforce', 'Slack', 'Excel']:
                    capability = capability[0].lower() + capability[1:]

        return capability.strip()

    def _extract_benefit(self, text: str) -> str:
        """
        PURPOSE:
            Extract or infer the benefit/value of the requirement.
            This becomes the "so that [Y]" part of the user story.

        R EQUIVALENT:
            extract_benefit <- function(text) {
                # Look for "so that", "in order to", "to enable"
                # If not found, infer from context
            }

        PARAMETERS:
            text (str): The requirement text

        RETURNS:
            str: The benefit statement

        WHY THIS APPROACH:
            The benefit explains WHY this feature matters. It's crucial for
            prioritization and ensures we're building valuable things.
            Many raw requirements don't include benefits, so we often need
            to infer or generate a placeholder.
        """
        text_lower = text.lower()

        # Look for explicit benefit phrases
        benefit_patterns = [
            r'so\s+that\s+(.+?)(?:\.|$)',
            r'in\s+order\s+to\s+(.+?)(?:\.|$)',
            r'to\s+(?:enable|allow|ensure|provide)\s+(.+?)(?:\.|$)',
            r'for\s+(?:better|improved|easier)\s+(.+?)(?:\.|$)',
            r'which\s+(?:will|would)\s+(.+?)(?:\.|$)',
        ]

        for pattern in benefit_patterns:
            match = re.search(pattern, text_lower)
            if match:
                benefit = match.group(1).strip()
                if len(benefit) > 5:  # Meaningful benefit
                    # Fix first-person pronoun "i" → "I"
                    # WHY: We extracted from lowercase text, but "I" should always be capitalized
                    # This handles "i don't have to..." → "I don't have to..."
                    benefit = re.sub(r'\bi\b', 'I', benefit)
                    return benefit

        # No explicit benefit found — infer from the capability
        # This is a placeholder that should be refined by a human
        capability_lower = text_lower

        # Try to infer common benefit patterns
        if any(word in capability_lower for word in ['login', 'auth', 'password']):
            return "I can securely access the system"
        if any(word in capability_lower for word in ['report', 'export', 'download']):
            return "I can analyze and share data externally"
        if any(word in capability_lower for word in ['dashboard', 'view', 'display']):
            return "I can quickly understand the current status"
        if any(word in capability_lower for word in ['edit', 'update', 'modify']):
            return "I can keep information current and accurate"
        if any(word in capability_lower for word in ['delete', 'remove']):
            return "I can manage and clean up data"
        if any(word in capability_lower for word in ['search', 'find', 'filter']):
            return "I can quickly locate the information I need"
        if any(word in capability_lower for word in ['notify', 'alert', 'email']):
            return "I can stay informed about important events"
        if any(word in capability_lower for word in ['integrate', 'connect', 'sync']):
            return "I can work seamlessly across systems"

        # Generic fallback
        return "I can accomplish my goal effectively"

    def _generate_title(self, text: str, req: dict) -> str:
        """
        PURPOSE:
            Generate a concise title for the user story.

        R EQUIVALENT:
            generate_title <- function(text, req) {
                # Use existing title if available, otherwise generate
            }

        PARAMETERS:
            text (str): The requirement text
            req (dict): The full requirement dictionary

        RETURNS:
            str: A short, descriptive title

        WHY THIS APPROACH:
            Titles should be short (< 60 chars) and action-oriented.
            They're used in sprint boards, reports, and GitHub issues.
        """
        # Use existing title if available
        if req.get('title'):
            return req['title']

        # Try to extract key action words
        text_clean = text.strip()

        # Remove common prefixes for title generation
        title = re.sub(
            r'^(?:the\s+)?(?:system|users?)\s+(?:shall|must|should|can|will)\s+',
            '', text_clean, flags=re.IGNORECASE
        )
        title = re.sub(
            r'^as\s+an?\s+\w+,?\s*i\s+(?:want|need)\s+to\s+',
            '', title, flags=re.IGNORECASE
        )

        # Capitalize first letter
        if title:
            title = title[0].upper() + title[1:]

        # Truncate if too long
        if len(title) > 60:
            # Try to cut at a word boundary
            title = title[:57]
            last_space = title.rfind(' ')
            if last_space > 40:
                title = title[:last_space]
            title += '...'

        return title.strip()

    def _generate_acceptance_criteria(self, text: str, capability: str) -> list[str]:
        """
        PURPOSE:
            Generate acceptance criteria for the user story.
            Criteria should be testable (SMART) and Gherkin-compatible.

        R EQUIVALENT:
            generate_ac <- function(text, capability) {
                # Extract explicit criteria from text
                # Generate additional criteria based on capability type
            }

        PARAMETERS:
            text (str): The original requirement text
            capability (str): The extracted capability

        RETURNS:
            list[str]: List of acceptance criteria strings

        WHY THIS APPROACH:
            Acceptance criteria define "done" — they're the testable conditions
            that must be met. We try to extract them from the requirement
            text and supplement with inferred criteria based on the feature type.

            Format is Gherkin-friendly: "Given [context], When [action], Then [outcome]"
            or simpler "Should [do X]" format.
        """
        criteria = []
        text_lower = text.lower()
        capability_lower = capability.lower()

        # ================================================================
        # Extract explicit criteria from the text
        # ================================================================
        # Look for bullet points or numbered items in the original
        # (Sometimes requirements include their own acceptance criteria)
        explicit_criteria = re.findall(
            r'(?:^|\n)\s*[-•*]\s*(.+?)(?=\n|$)',
            text
        )
        criteria.extend([c.strip() for c in explicit_criteria if len(c.strip()) > 10])

        # ================================================================
        # Generate criteria based on capability keywords
        # ================================================================

        # Login/Authentication features
        if any(word in capability_lower for word in ['login', 'sign in', 'authenticate']):
            criteria.extend([
                "Given valid credentials, When user submits login, Then user is authenticated and redirected to dashboard",
                "Given invalid credentials, When user submits login, Then appropriate error message is displayed",
                "Given session timeout, When user tries to access protected page, Then user is redirected to login",
            ])

        # Password features
        if 'password' in capability_lower:
            if 'reset' in capability_lower:
                criteria.extend([
                    "Given a valid email, When user requests password reset, Then reset email is sent within 5 minutes",
                    "Given a reset link, When user clicks link, Then user can set a new password",
                    "Given an expired reset link, When user clicks link, Then user sees expiration message with option to request new link",
                ])
            else:
                criteria.extend([
                    "Password must meet complexity requirements (min 8 chars, 1 uppercase, 1 number)",
                    "Password is stored using secure hashing (bcrypt or similar)",
                ])

        # View/Display features
        if any(word in capability_lower for word in ['view', 'display', 'show', 'see']):
            criteria.extend([
                "Data is displayed within 3 seconds of page load",
                "Display updates when underlying data changes",
                "User can only view data they have permission to access",
            ])

        # Edit/Update features
        if any(word in capability_lower for word in ['edit', 'update', 'modify', 'change']):
            criteria.extend([
                "Changes are saved when user clicks Save/Submit",
                "User sees confirmation message after successful save",
                "Unsaved changes trigger warning if user tries to navigate away",
                "Invalid input shows clear error message",
            ])

        # Delete features
        if any(word in capability_lower for word in ['delete', 'remove']):
            criteria.extend([
                "Confirmation dialog is shown before deletion",
                "Deleted item is removed from all views",
                "User sees success message after deletion",
            ])

        # Export/Download features
        if any(word in capability_lower for word in ['export', 'download']):
            criteria.extend([
                "Export completes within reasonable time (< 30 seconds for typical data)",
                "Exported file is in the correct format",
                "Export includes all visible/selected data",
            ])

        # Search/Filter features
        if any(word in capability_lower for word in ['search', 'find', 'filter']):
            criteria.extend([
                "Search results appear within 2 seconds",
                "Search matches are highlighted",
                "No results shows helpful message with suggestions",
            ])

        # Report features
        if 'report' in capability_lower:
            criteria.extend([
                "Report includes all required data fields",
                "Report data is accurate (matches source data)",
                "Report can be generated for custom date ranges",
            ])

        # Integration features
        if any(word in capability_lower for word in ['integrate', 'connect', 'sync']):
            criteria.extend([
                "Integration handles API errors gracefully",
                "Data sync completes without data loss",
                "Failed sync operations can be retried",
            ])

        # Notification features
        if any(word in capability_lower for word in ['notify', 'alert', 'email', 'notification']):
            criteria.extend([
                "Notification is sent within expected timeframe",
                "Notification includes all required information",
                "User can configure notification preferences",
            ])

        # ================================================================
        # Add generic criteria if we don't have many specific ones
        # ================================================================
        if len(criteria) < 2:
            criteria.extend([
                "Feature works as described in the requirement",
                "Feature handles error cases gracefully",
                "Feature is accessible to authorized users only",
            ])

        # Deduplicate while preserving order
        seen = set()
        unique_criteria = []
        for c in criteria:
            if c not in seen:
                seen.add(c)
                unique_criteria.append(c)

        return unique_criteria[:8]  # Limit to 8 criteria max

    def _check_for_vague_language(self, text: str) -> list[str]:
        """
        PURPOSE:
            Identify vague or non-testable language in the requirement.

        R EQUIVALENT:
            check_vague <- function(text) {
                patterns %>%
                    keep(~ str_detect(text, .x)) %>%
                    names()
            }

        PARAMETERS:
            text (str): The requirement text

        RETURNS:
            list[str]: List of vague terms found

        WHY THIS APPROACH:
            Vague requirements can't be tested — how do you verify "fast" or
            "user-friendly"? We flag these so they can be clarified with
            specific, measurable criteria.
        """
        found_terms = []
        text_lower = text.lower()

        for pattern in self.vague_indicators:
            match = re.search(pattern, text_lower)
            if match:
                # Extract the matched term for reporting
                found_terms.append(match.group(0))

        return found_terms

    def _build_description(self, req: dict, flags: list[str]) -> str:
        """
        PURPOSE:
            Build a description with context from the original requirement
            and any relevant metadata.

        R EQUIVALENT:
            build_description <- function(req, flags) {
                paste(
                    req$impact,
                    req$notes,
                    flag_warnings,
                    sep = "\\n\\n"
                )
            }

        PARAMETERS:
            req (dict): The original requirement
            flags (list[str]): Any flags/issues identified

        RETURNS:
            str: The formatted description

        WHY THIS APPROACH:
            The description provides context beyond the user story format.
            It includes business impact, technical notes, and any warnings
            about the requirement quality.
        """
        parts = []

        # Include impact if available
        if req.get('impact'):
            parts.append(f"**Business Impact:** {req['impact']}")

        # Include dependencies if available
        if req.get('dependencies'):
            parts.append(f"**Dependencies:** {req['dependencies']}")

        # Include notes if available
        if req.get('notes'):
            parts.append(f"**Notes:** {req['notes']}")

        # Add warnings for flagged issues
        if 'vague' in flags:
            vague_terms = [f.replace('vague_term:', '') for f in flags if f.startswith('vague_term:')]
            if vague_terms:
                parts.append(f"⚠️ **Needs clarification:** Contains vague terms: {', '.join(vague_terms)}")

        if 'priority_inferred' in flags:
            parts.append(f"ℹ️ Priority was not specified; defaulted to {self.default_priority}")

        if req.get('_split_index'):
            parts.append(f"ℹ️ Split from compound requirement ({req['_split_index']} of {req['_split_total']})")

        return '\n\n'.join(parts) if parts else ''

    def _generate_story_id(self, req: dict, text: str) -> str:
        """
        PURPOSE:
            Generate a unique identifier for the user story.

        R EQUIVALENT:
            generate_id <- function(req, text) {
                if (!is.null(req$requirement_id)) req$requirement_id
                else paste0("GEN-", digest::digest(text))
            }

        PARAMETERS:
            req (dict): The requirement dictionary
            text (str): The requirement text

        RETURNS:
            str: A unique identifier

        WHY THIS APPROACH:
            IDs enable traceability. If the original had an ID, we use it
            (with a suffix for split requirements). Otherwise, we generate
            a hash-based ID that's consistent for the same text.
        """
        original_id = req.get('requirement_id')

        if original_id and original_id not in ['TODO', '???', 'TBD']:
            base_id = original_id
        else:
            # Generate ID from text hash
            text_hash = hashlib.md5(text.encode()).hexdigest()[:6].upper()
            base_id = f"GEN-{text_hash}"

        # Add suffix for split requirements
        if req.get('_split_index'):
            return f"{base_id}-{req['_split_index']}"

        return base_id

    def _detect_duplicates(self) -> None:
        """
        PURPOSE:
            Scan all generated stories to find potential duplicates.
            Uses text similarity matching.

        R EQUIVALENT:
            detect_duplicates <- function(stories) {
                # Compare each pair of stories
                # Flag those above similarity threshold
            }

        PARAMETERS:
            None (operates on self._all_stories)

        RETURNS:
            None (modifies stories in place to add duplicate flags)

        WHY THIS APPROACH:
            Duplicate requirements waste effort and cause confusion.
            We use fuzzy matching because duplicates are rarely exact —
            "User can export to Excel" and "Users should be able to
            download data in spreadsheet format" are effectively duplicates.
        """
        n = len(self._all_stories)

        # Compare each pair of stories
        for i in range(n):
            for j in range(i + 1, n):
                story_a = self._all_stories[i]
                story_b = self._all_stories[j]

                # Skip comparing stories from the same source row
                # (They came from a compound split and are known to be related but distinct)
                row_a = story_a.get('source_requirement', {}).get('row_number')
                row_b = story_b.get('source_requirement', {}).get('row_number')
                if row_a and row_b and row_a == row_b:
                    continue

                # Compare the capabilities (core of what the story does)
                similarity = self._calculate_similarity(
                    story_a.get('capability', ''),
                    story_b.get('capability', '')
                )

                if similarity >= self.similarity_threshold:
                    # Flag both stories as potential duplicates
                    if 'potential_duplicate' not in story_a['flags']:
                        story_a['flags'].append('potential_duplicate')
                        story_a['flags'].append(f'similar_to:{story_b["generated_id"]}')

                    if 'potential_duplicate' not in story_b['flags']:
                        story_b['flags'].append('potential_duplicate')
                        story_b['flags'].append(f'similar_to:{story_a["generated_id"]}')

                    self.stats['duplicates_found'] += 1

    def _calculate_similarity(self, text_a: str, text_b: str) -> float:
        """
        PURPOSE:
            Calculate similarity between two text strings using multiple
            strategies: synonym normalization, keyword overlap, and
            sequence matching.

        R EQUIVALENT:
            Like stringdist::stringsim() but with preprocessing:
            similarity <- function(a, b) {
                a_norm <- normalize_synonyms(a)
                b_norm <- normalize_synonyms(b)
                seq_sim <- 1 - stringdist(a_norm, b_norm)
                keyword_sim <- jaccard(extract_keywords(a), extract_keywords(b))
                max(seq_sim, keyword_sim)  # Take the higher score
            }

        PARAMETERS:
            text_a (str): First text
            text_b (str): Second text

        RETURNS:
            float: Similarity score from 0.0 (different) to 1.0 (identical)

        WHY THIS APPROACH:
            Simple SequenceMatcher misses semantic similarity —
            "export to Excel" and "download spreadsheet" are 0.35 similar
            by character matching but semantically equivalent.

            We improve this by:
            1. Normalizing synonyms before comparison
            2. Computing keyword overlap (Jaccard similarity)
            3. Taking the MAX of both scores (either method can catch duplicates)
        """
        if not text_a or not text_b:
            return 0.0

        # Normalize texts
        text_a = text_a.lower().strip()
        text_b = text_b.lower().strip()

        # ================================================================
        # STRATEGY 1: Normalize synonyms and compute sequence similarity
        # ================================================================
        norm_a = self._normalize_synonyms(text_a)
        norm_b = self._normalize_synonyms(text_b)
        sequence_sim = SequenceMatcher(None, norm_a, norm_b).ratio()

        # ================================================================
        # STRATEGY 2: Keyword overlap (Jaccard similarity)
        # ================================================================
        # Extract meaningful words (nouns, verbs — skip stop words)
        keywords_a = self._extract_keywords(text_a)
        keywords_b = self._extract_keywords(text_b)

        if keywords_a and keywords_b:
            # Jaccard similarity: intersection / union
            intersection = keywords_a & keywords_b
            union = keywords_a | keywords_b
            keyword_sim = len(intersection) / len(union) if union else 0.0
        else:
            keyword_sim = 0.0

        # ================================================================
        # Return the HIGHER of the two scores
        # ================================================================
        # Either method might catch the duplicate — we want to flag it
        # if either score is high enough
        return max(sequence_sim, keyword_sim)

    def _normalize_synonyms(self, text: str) -> str:
        """
        PURPOSE:
            Replace common synonyms with canonical forms to improve
            similarity matching.

        R EQUIVALENT:
            normalize <- function(text) {
                text %>%
                    str_replace_all("download", "export") %>%
                    str_replace_all("spreadsheet", "excel") %>%
                    ...
            }

        PARAMETERS:
            text (str): Text to normalize

        RETURNS:
            str: Text with synonyms replaced by canonical forms

        WHY THIS APPROACH:
            "Export to Excel" and "download spreadsheet" are the same thing.
            By normalizing synonyms, we can catch these semantic duplicates
            with simple string matching.
        """
        # Synonym groups: first item is the canonical form
        synonym_groups = [
            # Data operations
            ['export', 'download', 'extract', 'save', 'output'],
            ['import', 'upload', 'load', 'ingest'],
            ['create', 'add', 'new', 'insert', 'generate'],
            ['delete', 'remove', 'erase', 'destroy'],
            ['update', 'edit', 'modify', 'change', 'alter'],
            ['view', 'see', 'display', 'show', 'read'],
            ['search', 'find', 'query', 'lookup', 'look up'],

            # File formats
            ['excel', 'spreadsheet', 'xlsx', 'xls', 'csv'],
            ['pdf', 'document', 'doc'],

            # Data terms
            ['data', 'information', 'content', 'records'],
            ['report', 'summary', 'analysis'],
            ['user', 'customer', 'client', 'member'],
            ['system', 'application', 'app', 'platform', 'software'],

            # UI terms
            ['dashboard', 'homepage', 'home page', 'main page'],
            ['button', 'link', 'action'],
            ['form', 'input', 'field'],

            # Actions
            ['login', 'log in', 'sign in', 'signin', 'authenticate'],
            ['logout', 'log out', 'sign out', 'signout'],
            ['register', 'sign up', 'signup', 'enroll'],
        ]

        result = text
        for group in synonym_groups:
            canonical = group[0]
            for synonym in group[1:]:
                # Use word boundaries to avoid partial replacements
                # \b doesn't work well with multi-word synonyms, so handle both
                if ' ' in synonym:
                    result = result.replace(synonym, canonical)
                else:
                    result = re.sub(rf'\b{synonym}\b', canonical, result)

        return result

    def _extract_keywords(self, text: str) -> set[str]:
        """
        PURPOSE:
            Extract meaningful keywords from text for overlap comparison.

        R EQUIVALENT:
            extract_keywords <- function(text) {
                words <- str_split(text, "\\s+")[[1]]
                words <- words[!words %in% stop_words]
                unique(words)
            }

        PARAMETERS:
            text (str): Text to extract keywords from

        RETURNS:
            set[str]: Set of meaningful keywords

        WHY THIS APPROACH:
            Comparing keyword overlap (Jaccard similarity) catches duplicates
            even when word order differs. "Export dashboard data" and
            "dashboard data export" would have 100% keyword overlap.
        """
        # Common stop words to ignore
        stop_words = {
            'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to',
            'for', 'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are',
            'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do',
            'does', 'did', 'will', 'would', 'could', 'should', 'may',
            'might', 'must', 'shall', 'can', 'need', 'dare', 'ought',
            'used', 'i', 'you', 'he', 'she', 'it', 'we', 'they', 'my',
            'your', 'his', 'her', 'its', 'our', 'their', 'this', 'that',
            'these', 'those', 'am', 'able', 'ability', 'want', 'like',
        }

        # Normalize synonyms first
        normalized = self._normalize_synonyms(text.lower())

        # Extract words
        words = re.findall(r'\b[a-z]+\b', normalized)

        # Filter out stop words and very short words
        keywords = {w for w in words if w not in stop_words and len(w) > 2}

        return keywords

    def get_stats(self) -> dict:
        """
        PURPOSE:
            Return statistics about the transformation process.

        PARAMETERS:
            None

        RETURNS:
            dict: Statistics including counts of transformations performed

        WHY THIS APPROACH:
            Stats help users understand what the generator did — how many
            requirements were split, flagged, etc. Useful for reporting
            and debugging.
        """
        return self.stats.copy()


# ============================================================================
# STANDALONE USAGE
# ============================================================================
if __name__ == "__main__":
    import sys
    import json

    # Path to the parsers module (for testing)
    sys.path.insert(0, str(__file__).replace('/generators/user_story_generator.py', ''))

    from parsers.excel_parser import ExcelParser

    # Check for command line argument
    if len(sys.argv) < 2:
        print("Usage: python user_story_generator.py <path_to_excel_file>")
        print("Example: python user_story_generator.py inputs/excel/requirements.xlsx")
        sys.exit(1)

    file_path = sys.argv[1]

    # Parse the Excel file
    print(f"Parsing: {file_path}")
    print("=" * 60)

    parser = ExcelParser(file_path)
    requirements = parser.parse()

    print(f"\nParsed {len(requirements)} requirements")
    print("=" * 60)

    # Generate user stories
    print("\nGenerating user stories...")

    generator = UserStoryGenerator()
    stories = generator.generate(requirements)

    # Print statistics
    stats = generator.get_stats()
    print(f"\n{'='*60}")
    print("GENERATION STATISTICS")
    print(f"{'='*60}")
    print(f"  Input requirements: {stats['total_input']}")
    print(f"  Output stories:     {stats['total_output']}")
    print(f"  Compound splits:    {stats['compound_split']}")
    print(f"  Vague flagged:      {stats['vague_flagged']}")
    print(f"  Duplicates found:   {stats['duplicates_found']}")
    print(f"  Priority inferred:  {stats['priority_inferred']}")

    # Print each story
    print(f"\n{'='*60}")
    print("GENERATED USER STORIES")
    print(f"{'='*60}")

    for i, story in enumerate(stories, start=1):
        print(f"\n{'─'*60}")
        print(f"Story {i}: {story['generated_id']}")
        print(f"{'─'*60}")
        print(f"Title: {story['title']}")
        print(f"\n{story['user_story']}")
        print(f"\nPriority: {story['priority']}")

        if story['flags']:
            print(f"\n⚠️  Flags: {', '.join(story['flags'])}")

        if story['description']:
            print(f"\nDescription:\n{story['description']}")

        print(f"\nAcceptance Criteria:")
        for j, ac in enumerate(story['acceptance_criteria'], start=1):
            print(f"  {j}. {ac}")

        print(f"\nSource: Row {story['source_requirement']['row_number']}")
