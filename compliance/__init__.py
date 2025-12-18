# compliance/__init__.py
# ============================================================================
# PURPOSE: Compliance module for validating requirements against regulations
#
# This module provides validators and test generators for:
# - FDA 21 CFR Part 11 (Electronic Records and Signatures)
# - HIPAA (Health Insurance Portability and Accountability Act)
# - SOC 2 (Service Organization Control 2 - Trust Services Criteria)
#
# USAGE:
#     from compliance import Part11Validator, HIPAAValidator, SOC2Validator
#     from compliance import Part11TestGenerator, HIPAATestGenerator, SOC2TestGenerator
#
#     # Quick validation
#     from compliance import validate_part11, validate_hipaa, validate_soc2
#     report = validate_part11(requirements)
#
#     # Generate compliance tests
#     from compliance import generate_part11_tests, generate_hipaa_tests, generate_soc2_tests
#     tests = generate_part11_tests(requirements, prefix="GRX")
#
# ============================================================================

# Base validator class
from .base_validator import BaseValidator

# Part 11 - FDA 21 CFR Part 11 (Electronic Records and Signatures)
from .part11_validator import Part11Validator, validate_part11
from .part11_test_generator import Part11TestGenerator, generate_part11_tests

# HIPAA - Health Insurance Portability and Accountability Act
from .hipaa_validator import HIPAAValidator, validate_hipaa
from .hipaa_test_generator import HIPAATestGenerator, generate_hipaa_tests

# SOC 2 - Service Organization Control 2 Trust Services Criteria
from .soc2_validator import SOC2Validator, validate_soc2
from .soc2_test_generator import SOC2TestGenerator, generate_soc2_tests


# ============================================================================
# CONVENIENCE FUNCTIONS FOR BATCH VALIDATION
# ============================================================================

def validate_all(
    requirements: list[dict],
    prefix: str = "COMP"
) -> dict:
    """
    PURPOSE:
        Validate requirements against all compliance frameworks at once.

    PARAMETERS:
        requirements (list[dict]): Requirements from parser
        prefix (str): Prefix for generated IDs

    RETURNS:
        dict: Reports for each framework

    USAGE:
        reports = validate_all(requirements)
        print(f"Part 11 score: {reports['part11']['summary']['compliance_score']}%")
        print(f"HIPAA score: {reports['hipaa']['summary']['compliance_score']}%")
        print(f"SOC 2 score: {reports['soc2']['summary']['compliance_score']}%")
    """
    return {
        'part11': validate_part11(requirements, prefix),
        'hipaa': validate_hipaa(requirements, prefix),
        'soc2': validate_soc2(requirements, prefix)
    }


def generate_all_compliance_tests(
    requirements: list[dict],
    prefix: str = "COMP"
) -> dict:
    """
    PURPOSE:
        Generate compliance test cases for all frameworks.

    PARAMETERS:
        requirements (list[dict]): Requirements from parser
        prefix (str): Prefix for test IDs

    RETURNS:
        dict: Test cases organized by framework

    USAGE:
        all_tests = generate_all_compliance_tests(requirements, prefix="GRX")
        part11_tests = all_tests['part11']
        hipaa_tests = all_tests['hipaa']
        soc2_tests = all_tests['soc2']
        combined = all_tests['combined']  # All tests in one list
    """
    part11_tests = generate_part11_tests(requirements, prefix)
    hipaa_tests = generate_hipaa_tests(requirements, prefix)
    soc2_tests = generate_soc2_tests(requirements, prefix)

    return {
        'part11': part11_tests,
        'hipaa': hipaa_tests,
        'soc2': soc2_tests,
        'combined': part11_tests + hipaa_tests + soc2_tests
    }


# What gets exported when using "from compliance import *"
__all__ = [
    # Base
    'BaseValidator',

    # Part 11
    'Part11Validator',
    'Part11TestGenerator',
    'validate_part11',
    'generate_part11_tests',

    # HIPAA
    'HIPAAValidator',
    'HIPAATestGenerator',
    'validate_hipaa',
    'generate_hipaa_tests',

    # SOC 2
    'SOC2Validator',
    'SOC2TestGenerator',
    'validate_soc2',
    'generate_soc2_tests',

    # Batch functions
    'validate_all',
    'generate_all_compliance_tests'
]
