# parsers/lucidchart_parser.py
# ============================================================================
# Lucidchart Diagram Parser
# ============================================================================
#
# PURPOSE:
#     Parse Lucidchart diagram exports (CSV and SVG) and extract requirements
#     from workflow diagrams. Converts shapes, connections, and swimlanes
#     into structured requirements compatible with the rest of the toolkit.
#
# AVIATION ANALOGY:
#     Like extracting a flight procedure from a visual approach chart.
#     The chart has symbols (shapes), paths (connections), and zones
#     (swimlanes). We interpret each element to build a textual procedure
#     that pilots can follow step-by-step.
#
# R EQUIVALENT:
#     In R, you might use xml2 for SVG parsing and read.csv for CSV:
#     library(xml2)
#     svg_doc <- read_xml("diagram.svg")
#     shapes <- xml_find_all(svg_doc, "//text")
#
# SUPPORTED FORMATS:
#     1. CSV Export (File → Download → CSV)
#        - Most structured, contains shape metadata
#        - Includes shape IDs, text, types, connections
#
#     2. SVG Export (File → Download → SVG)
#        - Visual representation, requires XML parsing
#        - Text content extracted from <text> elements
#        - Shape types inferred from path/rect elements
#
# USAGE:
#     from parsers.lucidchart_parser import LucidchartParser
#
#     parser = LucidchartParser("diagram_export.csv")
#     requirements = parser.parse()
#
# ============================================================================

import os
import re
import csv
import hashlib
from typing import Optional
from xml.etree import ElementTree as ET


class LucidchartParser:
    """
    PURPOSE:
        Parse Lucidchart diagram exports and extract requirements.
        Supports CSV exports (primary) and SVG exports (secondary).
        Converts workflow elements into structured requirements.

    R EQUIVALENT:
        # In R, you might create a similar parser:
        # LucidchartParser <- R6Class("LucidchartParser",
        #     public = list(
        #         file_path = NULL,
        #         initialize = function(file_path) {
        #             self$file_path <- file_path
        #         },
        #         parse = function() {
        #             ext <- tools::file_ext(self$file_path)
        #             if (ext == "csv") self$parse_csv()
        #             else if (ext == "svg") self$parse_svg()
        #         }
        #     )
        # )

    ATTRIBUTES:
        file_path (str): Path to the Lucidchart export file
        file_format (str): Detected format ('csv' or 'svg')
        shapes (list): Parsed shape data
        connections (list): Parsed connection data
        swimlanes (list): Parsed swimlane/container data

    WHY THIS CLASS:
        Diagrams are fundamentally different from spreadsheets.
        We need to understand visual relationships (connections, containment)
        to extract meaningful requirements. This class encapsulates
        all the diagram-specific parsing logic.
    """

    def __init__(self, file_path: str):
        """
        PURPOSE:
            Initialize the parser with a file path.

        R EQUIVALENT:
            # parser <- LucidchartParser$new("diagram.csv")

        PARAMETERS:
            file_path (str): Path to the Lucidchart export file.
                Supported formats: .csv, .svg

        RETURNS:
            None (constructor)

        WHY THIS APPROACH:
            We detect the format from the file extension and prepare
            the appropriate parsing strategy.
        """
        # Validate file exists
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")

        self.file_path = file_path

        # Detect file format from extension
        # WHY: Different formats need different parsing strategies
        _, ext = os.path.splitext(file_path)
        self.file_format = ext.lower().lstrip('.')

        if self.file_format not in ['csv', 'svg']:
            raise ValueError(
                f"Unsupported format: {self.file_format}\n"
                "Supported formats: .csv, .svg"
            )

        # Storage for parsed elements
        # WHY: We parse in stages - first extract shapes, then process
        self.shapes: list[dict] = []
        self.connections: list[dict] = []
        self.swimlanes: list[dict] = []

        # Shape type mappings for requirement generation
        # WHY: Different shape types become different requirement types
        self.shape_type_patterns = {
            # Process shapes → system actions/requirements
            'process': [
                'process', 'rectangle', 'rect', 'action', 'activity',
                'task', 'step', 'box'
            ],
            # Decision shapes → business rules/conditions
            'decision': [
                'decision', 'diamond', 'condition', 'gateway', 'branch',
                'if', 'choice'
            ],
            # Start/End shapes → triggers and outcomes
            'terminator': [
                'terminator', 'start', 'end', 'oval', 'terminal',
                'begin', 'finish', 'ellipse'
            ],
            # Data shapes → data requirements
            'data': [
                'data', 'document', 'database', 'storage', 'file',
                'cylinder', 'store'
            ],
            # Subprocess shapes → references to other processes
            'subprocess': [
                'subprocess', 'predefined', 'subroutine', 'call',
                'reference', 'page'
            ],
            # Manual shapes → user actions
            'manual': [
                'manual', 'manual operation', 'manual input', 'user',
                'human'
            ],
            # Swimlane/container shapes
            'swimlane': [
                'swimlane', 'pool', 'lane', 'container', 'group',
                'partition'
            ]
        }

        # Priority inference keywords
        # WHY: Diagrams rarely have explicit priority, so we infer from text
        self.priority_keywords = {
            'critical': ['critical', 'must', 'required', 'mandatory', 'essential'],
            'high': ['important', 'should', 'high', 'key', 'primary'],
            'medium': ['medium', 'normal', 'standard'],
            'low': ['low', 'optional', 'nice to have', 'could', 'may']
        }

        # Statistics tracking
        self.stats = {
            'shapes_parsed': 0,
            'connections_parsed': 0,
            'swimlanes_found': 0,
            'requirements_generated': 0,
            'empty_shapes_skipped': 0
        }

    def parse(self) -> list[dict]:
        """
        PURPOSE:
            Main entry point — parse the file and return requirements.

        R EQUIVALENT:
            # parse <- function() {
            #     if (file_format == "csv") parse_csv()
            #     else parse_svg()
            # }

        RETURNS:
            list[dict]: List of requirement dictionaries, compatible with
                the format returned by ExcelParser:
                - raw_text: The requirement text
                - row_number: Shape ID or index
                - source_cell: Shape reference
                - requirement_id: Auto-generated ID
                - priority: Inferred priority
                - category: From swimlane or shape type
                - description: Cleaned requirement text
                - notes: Additional context (connections, etc.)
                - shape_type: Original shape type
                - connected_to: List of connected shape IDs

        WHY THIS APPROACH:
            By returning the same structure as ExcelParser, we ensure
            the rest of the pipeline works identically regardless of
            input source.
        """
        # Parse based on file format
        if self.file_format == 'csv':
            self._parse_csv()
        elif self.file_format == 'svg':
            self._parse_svg()

        # Convert parsed shapes to requirements
        requirements = self._convert_to_requirements()

        return requirements

    # ========================================================================
    # CSV PARSING
    # ========================================================================

    def _parse_csv(self):
        """
        PURPOSE:
            Parse a Lucidchart CSV export file.
            CSV exports contain structured data about shapes and connections.

        R EQUIVALENT:
            # parse_csv <- function(file_path) {
            #     data <- read.csv(file_path, stringsAsFactors = FALSE)
            #     # Process rows...
            # }

        WHY THIS APPROACH:
            Lucidchart CSV exports have a specific structure:
            - Each row represents a shape or connection
            - Columns include: Id, Name, Shape Library, Text Area 1, etc.
            - We extract shape data and build relationships
        """
        with open(self.file_path, 'r', encoding='utf-8-sig') as f:
            # Use csv.DictReader for named column access
            # WHY: Lucidchart CSVs have headers, DictReader is cleaner
            reader = csv.DictReader(f)

            # Store rows for processing
            rows = list(reader)

        # Get column names (they vary by Lucidchart version)
        if not rows:
            return

        # Identify relevant columns
        # WHY: Lucidchart column names aren't always consistent
        columns = rows[0].keys()
        id_col = self._find_column(columns, ['Id', 'ID', 'id', 'Shape Id'])
        name_col = self._find_column(columns, ['Name', 'name', 'Shape Name'])
        type_col = self._find_column(columns, ['Shape Library', 'Type', 'Shape Type'])
        text_cols = self._find_text_columns(columns)
        container_col = self._find_column(columns, ['Contained By', 'Container', 'Parent', 'Swimlane'])
        source_col = self._find_column(columns, ['Line Source', 'Source', 'From'])
        target_col = self._find_column(columns, ['Line Destination', 'Target', 'To'])
        comments_col = self._find_column(columns, ['Comments', 'Notes', 'Comment'])

        # Also find specific text area columns for requirement IDs
        text_area_1 = self._find_column(columns, ['Text Area 1'])
        text_area_2 = self._find_column(columns, ['Text Area 2'])

        # First pass: identify swimlanes by their IDs for mapping
        swimlane_id_to_name = {}

        # Process each row
        for idx, row in enumerate(rows):
            # Extract shape ID
            shape_id = row.get(id_col, '') if id_col else f"shape_{idx}"

            # Extract shape name (determines shape type in Lucidchart exports)
            # WHY: In Lucidchart CSV, "Name" column contains shape type like "Swimlane", "Process", "Decision"
            shape_name = row.get(name_col, '') if name_col else ''

            # Extract shape library (usually "Flowchart")
            shape_type = row.get(type_col, '') if type_col else ''

            # Extract text from Text Area 1 (main text)
            primary_text = row.get(text_area_1, '') if text_area_1 else ''

            # Extract Text Area 2 (often contains requirement IDs like REQ-ONB-001)
            secondary_text = row.get(text_area_2, '') if text_area_2 else ''

            # Extract comments (often contains priority hints like "Must have", "Should have")
            comments = row.get(comments_col, '') if comments_col else ''

            # Check if this is a connection (line) vs a shape
            # WHY: In Lucidchart CSV, "Line" shapes are pure connectors,
            # while Process/Decision/etc shapes may HAVE connection info but ARE shapes
            source_id = row.get(source_col, '') if source_col else ''
            target_id = row.get(target_col, '') if target_col else ''

            # Determine if this is a connector line vs a shape with connection info
            # Shape types that are actual shapes (not connectors)
            shape_types = ['process', 'decision', 'terminator', 'data', 'document',
                          'subprocess', 'predefined process', 'manual operation',
                          'preparation', 'display', 'manual input', 'note', 'swimlane', 'page']
            is_shape = shape_name.lower() in shape_types

            # If it's a line/connector (not a shape type) and has source/target, it's a connection
            if source_id and target_id and not is_shape:
                # This is a connection/line
                self.connections.append({
                    'id': shape_id,
                    'source': source_id,
                    'target': target_id,
                    'text': primary_text
                })
                self.stats['connections_parsed'] += 1

            elif shape_name.lower() == 'swimlane':
                # This is a swimlane - use Text Area 1 as the swimlane name
                swimlane_name = primary_text or 'Unknown'
                self.swimlanes.append({
                    'id': shape_id,
                    'name': swimlane_name,
                    'type': 'swimlane',
                    'comments': comments
                })
                swimlane_id_to_name[shape_id] = swimlane_name
                self.stats['swimlanes_found'] += 1

            elif shape_name.lower() == 'page':
                # This is a page container, skip it but note the title
                pass  # Page is just container metadata

            elif primary_text or shape_name:
                # This is a regular shape (Process, Decision, Terminator, etc.)
                container_id = row.get(container_col, '') if container_col else ''

                # Map container ID to swimlane name
                swimlane_name = swimlane_id_to_name.get(container_id, '')

                self.shapes.append({
                    'id': shape_id,
                    'text': primary_text,
                    'type': shape_name,  # Use shape_name (Process, Decision, etc.) as type
                    'name': shape_name,
                    'container': container_id,
                    'swimlane': swimlane_name,
                    'requirement_id': secondary_text,  # Text Area 2 often has REQ-XXX
                    'comments': comments,  # Comments often has priority
                    'row_index': idx + 2  # +2 for 1-based + header
                })
                self.stats['shapes_parsed'] += 1

                # Also record connections FROM this shape if present
                # WHY: In Lucidchart CSV, shapes have Line Destination showing what they connect to
                if target_id:
                    # Target may be comma-separated (e.g., "8,12" for decision branches)
                    targets = [t.strip() for t in target_id.split(',') if t.strip()]
                    for target in targets:
                        self.connections.append({
                            'id': f'conn_{shape_id}_{target}',
                            'source': shape_id,
                            'target': target,
                            'text': ''
                        })
                        self.stats['connections_parsed'] += 1
            else:
                self.stats['empty_shapes_skipped'] += 1

        # Second pass: resolve swimlane names for shapes that reference swimlanes
        # parsed after their containing shape
        for shape in self.shapes:
            if not shape.get('swimlane') and shape.get('container'):
                shape['swimlane'] = swimlane_id_to_name.get(shape['container'], '')

    def _find_column(self, columns, candidates: list[str]) -> Optional[str]:
        """
        PURPOSE:
            Find a column by checking multiple possible names.

        PARAMETERS:
            columns: Available column names
            candidates: List of possible column names to match

        RETURNS:
            str or None: The matched column name, or None if not found

        WHY THIS APPROACH:
            Lucidchart export column names vary by version and settings.
            We try multiple common names to be resilient.
        """
        columns_lower = {c.lower(): c for c in columns}
        for candidate in candidates:
            if candidate.lower() in columns_lower:
                return columns_lower[candidate.lower()]
        return None

    def _find_text_columns(self, columns) -> list[str]:
        """
        PURPOSE:
            Find all columns that might contain shape text.

        PARAMETERS:
            columns: Available column names

        RETURNS:
            list[str]: Column names that likely contain text

        WHY THIS APPROACH:
            Lucidchart shapes can have multiple text areas (Text Area 1,
            Text Area 2, etc.). We collect all of them.
        """
        text_patterns = [
            r'text\s*area',
            r'text\s*\d*',
            r'content',
            r'label',
            r'value'
        ]

        text_cols = []
        for col in columns:
            col_lower = col.lower()
            if any(re.search(pattern, col_lower) for pattern in text_patterns):
                text_cols.append(col)
            elif col_lower in ['text', 'name', 'description']:
                text_cols.append(col)

        return text_cols

    def _extract_text_from_row(self, row: dict, text_cols: list[str]) -> str:
        """
        PURPOSE:
            Extract and combine text from multiple columns.

        PARAMETERS:
            row (dict): The CSV row
            text_cols (list[str]): Columns to check for text

        RETURNS:
            str: Combined text from all text columns

        WHY THIS APPROACH:
            Shapes may have text split across multiple areas.
            We combine them with newlines for complete extraction.
        """
        texts = []
        for col in text_cols:
            value = row.get(col, '')
            if value and str(value).strip():
                texts.append(str(value).strip())

        return '\n'.join(texts)

    # ========================================================================
    # SVG PARSING
    # ========================================================================

    def _parse_svg(self):
        """
        PURPOSE:
            Parse a Lucidchart SVG export file.
            SVG files are XML documents with visual elements.

        R EQUIVALENT:
            # library(xml2)
            # parse_svg <- function(file_path) {
            #     doc <- read_xml(file_path)
            #     texts <- xml_find_all(doc, "//text")
            #     # Process elements...
            # }

        WHY THIS APPROACH:
            SVG is less structured than CSV but sometimes it's the only
            export option. We extract text from <text> elements and
            infer shape types from surrounding elements.
        """
        # Parse the SVG as XML
        # WHY: SVG is XML-based, so we use ElementTree
        tree = ET.parse(self.file_path)
        root = tree.getroot()

        # SVG namespace handling
        # WHY: SVG elements are namespaced, we need to handle that
        namespaces = {
            'svg': 'http://www.w3.org/2000/svg',
            'xlink': 'http://www.w3.org/1999/xlink'
        }

        # Try to extract namespace from root if different
        ns_match = re.match(r'\{(.+)\}', root.tag)
        if ns_match:
            namespaces['svg'] = ns_match.group(1)

        # Find all groups (g elements) - these often represent shapes
        # In Lucidchart SVGs, shapes are typically wrapped in <g> elements
        groups = root.findall('.//{%s}g' % namespaces['svg'])

        shape_index = 0
        for group in groups:
            # Extract text from this group
            text_elements = group.findall('.//{%s}text' % namespaces['svg'])
            tspan_elements = group.findall('.//{%s}tspan' % namespaces['svg'])

            texts = []
            for elem in text_elements + tspan_elements:
                if elem.text and elem.text.strip():
                    texts.append(elem.text.strip())
                # Also check tail text
                if elem.tail and elem.tail.strip():
                    texts.append(elem.tail.strip())

            # Combine all text in this group
            combined_text = ' '.join(texts)

            if not combined_text:
                continue

            # Try to determine shape type from element attributes or children
            shape_type = self._infer_shape_type_from_svg(group, namespaces)

            # Get group ID if available
            group_id = group.get('id', f'svg_shape_{shape_index}')

            # Check if this looks like a swimlane label
            if self._is_swimlane_text(combined_text, shape_type):
                self.swimlanes.append({
                    'id': group_id,
                    'name': combined_text,
                    'type': 'swimlane'
                })
                self.stats['swimlanes_found'] += 1
            else:
                self.shapes.append({
                    'id': group_id,
                    'text': combined_text,
                    'type': shape_type,
                    'name': '',
                    'container': '',  # SVG doesn't easily expose containment
                    'row_index': shape_index + 1
                })
                self.stats['shapes_parsed'] += 1

            shape_index += 1

        # Try to extract connections from path elements
        self._extract_svg_connections(root, namespaces)

    def _infer_shape_type_from_svg(self, group, namespaces: dict) -> str:
        """
        PURPOSE:
            Infer the shape type from SVG element structure.

        PARAMETERS:
            group: The SVG group element
            namespaces (dict): XML namespaces

        RETURNS:
            str: Inferred shape type

        WHY THIS APPROACH:
            SVG doesn't explicitly label shapes. We look at the child
            elements (rect, ellipse, polygon, path) to guess the type.
        """
        svg_ns = namespaces['svg']

        # Check for specific shape elements
        if group.find('.//{%s}rect' % svg_ns) is not None:
            return 'process'  # Rectangles are usually process boxes

        if group.find('.//{%s}ellipse' % svg_ns) is not None:
            return 'terminator'  # Ellipses are usually start/end

        if group.find('.//{%s}circle' % svg_ns) is not None:
            return 'terminator'

        # Check for polygon (could be diamond/decision)
        polygon = group.find('.//{%s}polygon' % svg_ns)
        if polygon is not None:
            points = polygon.get('points', '')
            # Diamond shapes typically have 4 points
            point_count = len(points.split())
            if point_count == 4:
                return 'decision'

        # Check path elements for specific shapes
        path = group.find('.//{%s}path' % svg_ns)
        if path is not None:
            d = path.get('d', '')
            # Look for diamond-like path commands
            if d.count('L') >= 4 or d.count('l') >= 4:
                return 'decision'

        # Default to process
        return 'process'

    def _is_swimlane_text(self, text: str, shape_type: str) -> bool:
        """
        PURPOSE:
            Determine if text represents a swimlane label.

        PARAMETERS:
            text (str): The text content
            shape_type (str): The inferred shape type

        RETURNS:
            bool: True if this looks like a swimlane label

        WHY THIS APPROACH:
            Swimlane labels are typically short role names like
            "Customer", "System", "Admin". We use heuristics.
        """
        text_lower = text.lower().strip()

        # Common swimlane/role labels
        role_patterns = [
            r'^(?:customer|user|admin|system|manager|staff)$',
            r'^(?:client|operator|reviewer|approver)$',
            r'^(?:sales|support|hr|it|finance)$',
            r'^(?:phase|stage|department|team)\s*\d*$',
            r'^\w+\s+(?:team|dept|department)$'
        ]

        for pattern in role_patterns:
            if re.match(pattern, text_lower):
                return True

        # Short single words that look like roles
        if len(text.split()) == 1 and len(text) < 20:
            if text[0].isupper():  # Proper noun style
                return True

        return False

    def _extract_svg_connections(self, root, namespaces: dict):
        """
        PURPOSE:
            Extract connections (lines/arrows) from SVG.

        PARAMETERS:
            root: SVG root element
            namespaces (dict): XML namespaces

        WHY THIS APPROACH:
            Connections in SVG are typically <line> or <path> elements
            with marker-end attributes (arrows). We try to find them.
        """
        svg_ns = namespaces['svg']

        # Look for line elements
        lines = root.findall('.//{%s}line' % svg_ns)
        for idx, line in enumerate(lines):
            # Lines have x1,y1 to x2,y2
            # Without shape IDs, we can only note that connections exist
            self.connections.append({
                'id': f'connection_{idx}',
                'source': 'unknown',
                'target': 'unknown',
                'text': ''
            })
            self.stats['connections_parsed'] += 1

        # Look for paths that might be connectors
        # (paths with marker-end are usually arrows)
        paths = root.findall('.//{%s}path' % svg_ns)
        for idx, path in enumerate(paths):
            marker = path.get('marker-end', '')
            if 'arrow' in marker.lower() or 'end' in marker.lower():
                self.connections.append({
                    'id': f'connection_path_{idx}',
                    'source': 'unknown',
                    'target': 'unknown',
                    'text': ''
                })
                self.stats['connections_parsed'] += 1

    # ========================================================================
    # REQUIREMENT CONVERSION
    # ========================================================================

    def _convert_to_requirements(self) -> list[dict]:
        """
        PURPOSE:
            Convert parsed shapes into requirements format.

        RETURNS:
            list[dict]: Requirements in standard format

        WHY THIS APPROACH:
            We transform diagram elements into requirements by:
            1. Using shape text as the requirement description
            2. Inferring priority from keywords or comments
            3. Using swimlane as category/role
            4. Recording connections as dependencies
        """
        requirements = []

        # Build a map of shape connections for dependency tracking
        connection_map = self._build_connection_map()

        # Build swimlane lookup (for fallback when swimlane not directly on shape)
        swimlane_map = {s['id']: s['name'] for s in self.swimlanes}

        for shape in self.shapes:
            # Skip shapes with no meaningful text
            text = shape.get('text', '').strip()
            if not text or len(text) < 3:
                continue

            # Skip common non-requirement text
            if self._is_non_requirement_text(text):
                continue

            # Use explicit requirement ID from Text Area 2 if available
            # WHY: Lucidchart diagrams often have REQ-XXX IDs in Text Area 2
            explicit_req_id = shape.get('requirement_id', '').strip()
            if explicit_req_id and re.match(r'^[A-Z]{2,}-', explicit_req_id):
                req_id = explicit_req_id
            else:
                req_id = self._generate_requirement_id(shape)

            # Determine shape type category
            shape_type = shape.get('type', '')
            normalized_type = self._normalize_shape_type(shape_type)

            # Convert shape to requirement text
            requirement_text = self._shape_to_requirement(text, normalized_type)

            # Infer priority from comments first, then from text
            # WHY: Comments in Lucidchart often contain "Must have", "Should have", etc.
            comments = shape.get('comments', '')
            priority = self._infer_priority(comments) if comments else self._infer_priority(text)

            # Determine category from swimlane (directly stored or via container lookup)
            # WHY: CSV parsing now stores swimlane name directly on shape
            category = shape.get('swimlane', '')
            if not category:
                container_id = shape.get('container', '')
                category = swimlane_map.get(container_id, '')
            if not category:
                category = self._type_to_category(normalized_type)

            # Find connected shapes (dependencies)
            connected_to = connection_map.get(shape['id'], [])

            # Build the requirement dictionary
            # WHY: This format matches ExcelParser output for pipeline compatibility
            requirement = {
                'raw_text': text,
                'description': requirement_text,
                'row_number': shape.get('row_index', 0),
                'source_cell': f"Shape: {shape['id']}",
                'requirement_id': req_id,
                'priority': priority,
                'category': category,
                'notes': self._generate_notes(shape, connected_to),
                'shape_type': normalized_type,
                'connected_to': connected_to,
                # Additional fields for compatibility
                'title': '',
                'status': ''
            }

            requirements.append(requirement)
            self.stats['requirements_generated'] += 1

        # Sort by row_number (or shape order) for consistent output
        requirements.sort(key=lambda r: r.get('row_number', 0))

        return requirements

    def _build_connection_map(self) -> dict[str, list[str]]:
        """
        PURPOSE:
            Build a map of shape_id -> [connected shape IDs].

        RETURNS:
            dict: Mapping of source shapes to their targets

        WHY THIS APPROACH:
            This lets us quickly look up what each shape connects to,
            which we record as potential dependencies.
        """
        connection_map = {}

        for conn in self.connections:
            source = conn.get('source', '')
            target = conn.get('target', '')

            if source and target and source != 'unknown':
                if source not in connection_map:
                    connection_map[source] = []
                connection_map[source].append(target)

        return connection_map

    def _normalize_shape_type(self, shape_type: str) -> str:
        """
        PURPOSE:
            Normalize various shape type names to standard categories.

        PARAMETERS:
            shape_type (str): Raw shape type from Lucidchart

        RETURNS:
            str: Normalized type (process, decision, terminator, etc.)

        WHY THIS APPROACH:
            Lucidchart uses many different names for similar shapes.
            Normalizing helps us treat them consistently.
        """
        if not shape_type:
            return 'process'

        shape_lower = shape_type.lower()

        for normalized, patterns in self.shape_type_patterns.items():
            if any(pattern in shape_lower for pattern in patterns):
                return normalized

        return 'process'  # Default

    def _shape_to_requirement(self, text: str, shape_type: str) -> str:
        """
        PURPOSE:
            Convert shape text into requirement-style language.

        PARAMETERS:
            text (str): The shape text
            shape_type (str): Normalized shape type

        RETURNS:
            str: Requirement-formatted text

        WHY THIS APPROACH:
            Different shape types imply different requirement styles:
            - Process boxes → "System shall [action]"
            - Decisions → "If [condition], then [action]"
            - Manual → "User shall [action]"
        """
        text = text.strip()

        # If text already looks like a requirement, keep it
        if re.match(r'^(the\s+)?system\s+(shall|must|should|will)', text, re.I):
            return text
        if re.match(r'^(users?|admin)\s+(shall|must|can|should)', text, re.I):
            return text
        if re.match(r'^as\s+a\s+', text, re.I):
            return text

        # Transform based on shape type
        if shape_type == 'decision':
            # Decisions become conditions/business rules
            if '?' in text:
                return f"Business rule: {text}"
            else:
                return f"Condition: {text}"

        elif shape_type == 'terminator':
            # Start/end shapes become triggers or outcomes
            text_lower = text.lower()
            if any(word in text_lower for word in ['start', 'begin', 'initiate']):
                return f"Process trigger: {text}"
            elif any(word in text_lower for word in ['end', 'complete', 'finish']):
                return f"Process outcome: {text}"
            else:
                return text

        elif shape_type == 'data':
            # Data shapes become data requirements
            return f"System shall store/retrieve: {text}"

        elif shape_type == 'manual':
            # Manual shapes become user actions
            return f"User shall {text.lower()}"

        elif shape_type == 'subprocess':
            # Subprocess references
            return f"System shall execute subprocess: {text}"

        else:
            # Default: process shape → system requirement
            # Check if it's already a verb phrase
            first_word = text.split()[0].lower() if text.split() else ''
            action_verbs = [
                'create', 'read', 'update', 'delete', 'send', 'receive',
                'validate', 'process', 'calculate', 'display', 'generate',
                'notify', 'verify', 'check', 'store', 'retrieve', 'submit',
                'approve', 'reject', 'review', 'log', 'record', 'export',
                'import', 'search', 'filter', 'sort'
            ]

            if first_word in action_verbs:
                return f"System shall {text.lower()}"
            else:
                return f"System shall {text}"

    def _infer_priority(self, text: str) -> str:
        """
        PURPOSE:
            Infer priority from keywords in the text.

        PARAMETERS:
            text (str): The requirement text

        RETURNS:
            str: Priority level (Critical, High, Medium, Low)

        WHY THIS APPROACH:
            Diagrams rarely have explicit priority. We look for
            keywords that suggest importance.
        """
        text_lower = text.lower()

        for priority, keywords in self.priority_keywords.items():
            if any(keyword in text_lower for keyword in keywords):
                return priority.capitalize()

        return 'Medium'  # Default

    def _type_to_category(self, shape_type: str) -> str:
        """
        PURPOSE:
            Convert shape type to a category name.

        PARAMETERS:
            shape_type (str): Normalized shape type

        RETURNS:
            str: Category name

        WHY THIS APPROACH:
            When we don't have swimlane info, we use shape type
            as a fallback category.
        """
        type_to_category = {
            'process': 'System Function',
            'decision': 'Business Rule',
            'terminator': 'Process Boundary',
            'data': 'Data Management',
            'manual': 'User Action',
            'subprocess': 'Subprocess Reference'
        }

        return type_to_category.get(shape_type, 'General')

    def _is_non_requirement_text(self, text: str) -> bool:
        """
        PURPOSE:
            Filter out text that shouldn't become requirements.

        PARAMETERS:
            text (str): The shape text

        RETURNS:
            bool: True if this should be skipped

        WHY THIS APPROACH:
            Some shapes contain labels, annotations, or metadata
            that aren't actually requirements.
        """
        text_lower = text.lower().strip()

        # Skip very short text
        if len(text_lower) < 3:
            return True

        # Skip common non-requirement patterns
        skip_patterns = [
            r'^yes$', r'^no$', r'^y$', r'^n$',
            r'^true$', r'^false$',
            r'^page\s*\d+$',
            r'^version\s*[\d.]+$',
            r'^rev\s*[\d.]+$',
            r'^\d+$',  # Just a number
            r'^[a-z]$',  # Single letter
            r'^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)\s*\d+',  # Dates
            r'^\d{1,2}/\d{1,2}/\d{2,4}$',  # Date format
            r'^(note|notes|comment|comments):?\s*$',
            r'^(draft|final|approved|pending)$',
            r'^(legend|key):?\s*$',
            r'^(title|header|footer):?\s*$'
        ]

        for pattern in skip_patterns:
            if re.match(pattern, text_lower):
                return True

        return False

    def _generate_requirement_id(self, shape: dict) -> str:
        """
        PURPOSE:
            Generate a unique requirement ID for a shape.

        PARAMETERS:
            shape (dict): The shape data

        RETURNS:
            str: Generated requirement ID

        WHY THIS APPROACH:
            Diagram shapes may not have explicit IDs. We generate
            a consistent ID based on shape properties.
        """
        shape_id = shape.get('id', '')
        row_idx = shape.get('row_index', 0)

        if shape_id and not shape_id.startswith('shape_'):
            # Use shape ID if it looks meaningful
            clean_id = re.sub(r'[^a-zA-Z0-9]', '', shape_id)
            return f"LC-{clean_id[:8].upper()}"
        else:
            # Generate from row index
            return f"LC-{row_idx:03d}"

    def _generate_notes(self, shape: dict, connected_to: list[str]) -> str:
        """
        PURPOSE:
            Generate notes field with context about the shape.

        PARAMETERS:
            shape (dict): The shape data
            connected_to (list[str]): Connected shape IDs

        RETURNS:
            str: Notes string

        WHY THIS APPROACH:
            Notes provide context about where the requirement came from
            and what it connects to in the original diagram.
        """
        notes_parts = []

        # Include comments from the diagram (often has implementation notes)
        comments = shape.get('comments', '')
        if comments:
            notes_parts.append(comments)

        # Note connections
        if connected_to:
            notes_parts.append(f"Flows to: {', '.join(connected_to[:3])}")
            if len(connected_to) > 3:
                notes_parts.append(f"(+{len(connected_to) - 3} more)")

        # Note swimlane (role)
        swimlane = shape.get('swimlane', '')
        if swimlane:
            notes_parts.append(f"Role: {swimlane}")

        return '; '.join(notes_parts)

    def get_stats(self) -> dict:
        """
        PURPOSE:
            Return parsing statistics.

        RETURNS:
            dict: Statistics dictionary

        WHY THIS APPROACH:
            Statistics help understand the diagram complexity
            and what was extracted.
        """
        return self.stats.copy()

    def get_swimlanes(self) -> list[dict]:
        """
        PURPOSE:
            Return detected swimlanes (can be used for role mapping).

        RETURNS:
            list[dict]: List of swimlane data

        WHY THIS APPROACH:
            Swimlanes often represent user roles, which is useful
            for the "As a [role]" part of user stories.
        """
        return self.swimlanes.copy()


# ============================================================================
# STANDALONE TEST
# ============================================================================
# Run this file directly to test with sample data:
#     python parsers/lucidchart_parser.py
# ============================================================================

if __name__ == "__main__":
    import sys

    print("=" * 70)
    print("LUCIDCHART PARSER TEST")
    print("=" * 70)
    print()

    # Check if a file was provided
    if len(sys.argv) > 1:
        test_file = sys.argv[1]
        print(f"Testing with: {test_file}")
        print()

        try:
            parser = LucidchartParser(test_file)
            requirements = parser.parse()

            print(f"Parsed {len(requirements)} requirements")
            print()

            # Show statistics
            stats = parser.get_stats()
            print("Statistics:")
            for key, value in stats.items():
                print(f"  {key}: {value}")
            print()

            # Show swimlanes
            swimlanes = parser.get_swimlanes()
            if swimlanes:
                print(f"Swimlanes found: {len(swimlanes)}")
                for sl in swimlanes:
                    print(f"  - {sl['name']}")
                print()

            # Show sample requirements
            print("Sample requirements:")
            for req in requirements[:5]:
                print(f"  {req['requirement_id']}: {req['description'][:60]}...")
                print(f"    Category: {req['category']} | Priority: {req['priority']}")
                print()

        except Exception as e:
            print(f"ERROR: {e}")
            sys.exit(1)

    else:
        print("No file provided. Creating sample CSV for testing...")
        print()

        # Create a sample CSV file for testing
        sample_csv = """Id,Name,Shape Library,Text Area 1,Container,Line Source,Line Destination
shape_1,Start,Flowchart,Start Process,,
shape_2,Login,Flowchart,User enters credentials,Customer,
shape_3,Validate,Flowchart,Validate credentials,System,
shape_4,Decision,Flowchart,Valid?,System,
shape_5,Dashboard,Flowchart,Display dashboard,System,
shape_6,Error,Flowchart,Show error message,System,
shape_7,End,Flowchart,End Process,,
line_1,,,,,shape_1,shape_2
line_2,,,,,shape_2,shape_3
line_3,,,,,shape_3,shape_4
line_4,,,Yes,,shape_4,shape_5
line_5,,,No,,shape_4,shape_6
swimlane_1,Pool,Swimlane,Customer,,
swimlane_2,Pool,Swimlane,System,,"""

        # Write sample file
        sample_path = "inputs/lucidchart/sample_diagram.csv"
        os.makedirs(os.path.dirname(sample_path), exist_ok=True)

        with open(sample_path, 'w') as f:
            f.write(sample_csv)

        print(f"Created sample file: {sample_path}")
        print()

        # Parse it
        parser = LucidchartParser(sample_path)
        requirements = parser.parse()

        print(f"Parsed {len(requirements)} requirements")
        print()

        stats = parser.get_stats()
        print("Statistics:")
        for key, value in stats.items():
            print(f"  {key}: {value}")
        print()

        print("Requirements:")
        for req in requirements:
            print(f"  {req['requirement_id']}: {req['description']}")
            print(f"    Category: {req['category']} | Priority: {req['priority']}")
            if req['notes']:
                print(f"    Notes: {req['notes']}")
            print()
