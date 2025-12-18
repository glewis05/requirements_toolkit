# parsers/__init__.py
# Makes this directory a Python package (like how R uses NAMESPACE files)
# This allows imports like: from parsers.excel_parser import ExcelParser

from .excel_parser import ExcelParser
from .lucidchart_parser import LucidchartParser
from .word_parser import WordParser

__all__ = ["ExcelParser", "LucidchartParser", "WordParser"]
