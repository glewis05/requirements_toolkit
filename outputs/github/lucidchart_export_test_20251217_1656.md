# User Stories & UAT Test Cases

**Generated:** 2025-12-17 16:56
**Source:** lucidchart_export_test.csv

## Summary

### Overview

- **Total User Stories:** 19
- **Total UAT Test Cases:** 117

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 6 |
| 🟠 High | 4 |
| 🟡 Medium | 7 |
| 🟢 Low | 2 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 19 |
| ❌ Negative | 42 |
| 🔶 Edge Case | 32 |
| 📏 Boundary | 24 |

---

## Table of Contents

1. [Process trigger: Start: Patient Arrives](#process-trigger-start-patient-arrives)
2. [Collect patient demographics including name DOB address...](#collect-patient-demographics-including-name-dob-address)
3. [Emergency contact](#emergency-contact)
4. [Retrieve existing patient record](#retrieve-existing-patient-record)
5. [Verify information is current](#verify-information-is-current)
6. [Update any changed demographics](#update-any-changed-demographics)
7. [Flag patient record for insurance follow-up](#flag-patient-record-for-insurance-follow-up)
8. [Notify billing team](#notify-billing-team)
9. [Create new patient record with unique mrn](#create-new-patient-record-with-unique-mrn)
10. [Verify insurance eligibility in real-time via...](#verify-insurance-eligibility-in-real-time-via)
11. [Patient completes consent forms electronically](#patient-completes-consent-forms-electronically)
12. [Send insurance verification confirmation to registration...](#send-insurance-verification-confirmation-to-registration)
13. [Review consent forms for completeness](#review-consent-forms-for-completeness)
14. [Send reminder notification to patient for missing consents](#send-reminder-notification-to-patient-for-missing-consents)
15. [Generate patient welcome packet with appointment details...](#generate-patient-welcome-packet-with-appointment-details)
16. [Facility map](#facility-map)
17. [Process outcome: End: Patient Onboarded](#process-outcome-end-patient-onboarded)
18. [TODO: Add HIPAA audit logging throughout](#todo-add-hipaa-audit-logging-throughout)
19. [Handle walk-in vs scheduled patient differently](#handle-walk-in-vs-scheduled-patient-differently)

---

## Process trigger: Start: Patient Arrives

**User Story:** As a user, I want to process trigger: Start: Patient Arrives, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Entry point; Flows to: 6; Role: Patient

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-PATI-001 | Patient | Verify Process trigger: Start: Patien... | User is logged in as user | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| ONB-PATI-002 | Patient | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-PATI-001: Verify Process trigger: Start: Patient Arrives
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: process trigger: Start: Patient Arrives
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-PATI-002: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 6

---

## Collect patient demographics including name DOB address\.\.\.

**User Story:** As a system, I want to receive Collect patient demographics including name DOB address phone email insurance, so that I can stay informed about important events\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have - HIPAA required; Flows to: 7; Role: Registration Staff

ℹ️ Split from compound requirement \(1 of 2\)

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-001 | Registration Staff | Verify Collect patient demographics i... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-RS-002 | Registration Staff | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-003 | Registration Staff | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-004 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-RS-005 | Registration Staff | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-RS-006 | Registration Staff | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-RS-007 | Registration Staff | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-RS-008 | Registration Staff | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-RS-009 | Registration Staff | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-001: Verify Collect patient demographics including name DOB address...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

**Notes:** Test with both minimum and maximum field lengths

### ONB-RS-002: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-RS-003: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-RS-004: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-RS-005: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-RS-006: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-RS-007: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-RS-008: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-RS-009: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 7

---

## Emergency contact

**User Story:** As a system, I want to have emergency contact, so that I can accomplish my goal effectively\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have - HIPAA required; Flows to: 7; Role: Registration Staff

ℹ️ Split from compound requirement \(2 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-010 | Registration Staff | Verify Emergency contact | User is logged in as system | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| ONB-RS-011 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-010: Verify Emergency contact
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: have emergency contact
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-RS-011: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 7

---

## Retrieve existing patient record

**User Story:** As a system, I want to retrieve existing patient record, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Flows to: 9; Role: System

ℹ️ Split from compound requirement \(1 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-001 | System | Verify Retrieve existing patient record | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| ONB-SYST-002 | System | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-003 | System | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-004 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-005 | System | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SYST-006 | System | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SYST-007 | System | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SYST-008 | System | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-009 | System | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-001: Verify Retrieve existing patient record
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-SYST-002: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SYST-003: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SYST-004: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-005: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SYST-006: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SYST-007: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SYST-008: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-009: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 9

---

## Verify information is current

**User Story:** As a system, I want to verify information is current, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Flows to: 9; Role: System

ℹ️ Split from compound requirement \(2 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-010 | System | Verify Verify information is current | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| ONB-SYST-011 | System | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-012 | System | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-013 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-014 | System | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SYST-015 | System | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SYST-016 | System | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SYST-017 | System | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-018 | System | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-010: Verify Verify information is current
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-SYST-011: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SYST-012: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SYST-013: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-014: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SYST-015: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SYST-016: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SYST-017: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-018: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 9

---

## Update any changed demographics

**User Story:** As a system, I want to update any changed demographics, so that I can keep information current and accurate\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Should have; Flows to: 10; Role: Registration Staff

**Acceptance Criteria:**
- [ ] Changes are saved when user clicks Save/Submit
- [ ] User sees confirmation message after successful save
- [ ] Unsaved changes trigger warning if user tries to navigate away
- [ ] Invalid input shows clear error message

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-012 | Registration Staff | Verify Update any changed demographics | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Changes are saved when user clicks Save/Submit<br>• User sees confirmation message after successf...<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-RS-013 | Registration Staff | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-014 | Registration Staff | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-015 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-RS-016 | Registration Staff | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-RS-017 | Registration Staff | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-RS-018 | Registration Staff | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-RS-019 | Registration Staff | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-RS-020 | Registration Staff | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-012: Verify Update any changed demographics
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Changes are saved when user clicks Save/Submit
• User sees confirmation message after successful save
• Unsaved changes trigger warning if user tries to navigate away

**Notes:** Test with both minimum and maximum field lengths

### ONB-RS-013: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-RS-014: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-RS-015: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-RS-016: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-RS-017: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-RS-018: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-RS-019: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-RS-020: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 10

---

## Flag patient record for insurance follow-up

**User Story:** As a system, I want to have Flag patient record for insurance follow-up, so that I can accomplish my goal effectively\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have; Flows to: 14; Role: System

ℹ️ Split from compound requirement \(1 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-019 | System | Verify Flag patient record for insura... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-SYST-020 | System | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-021 | System | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-022 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-023 | System | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SYST-024 | System | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SYST-025 | System | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SYST-026 | System | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-027 | System | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-019: Verify Flag patient record for insurance follow-up
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-SYST-020: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SYST-021: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SYST-022: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-023: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SYST-024: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SYST-025: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SYST-026: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-027: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 12

---

## Notify billing team

**User Story:** As a system, I want to notify billing team, so that I can stay informed about important events\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have; Flows to: 14; Role: System

ℹ️ Split from compound requirement \(2 of 2\)

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-028 | System | Verify Notify billing team | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-SYST-029 | System | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-030 | System | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-031 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-032 | System | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SYST-033 | System | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SYST-034 | System | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SYST-035 | System | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-036 | System | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-028: Verify Notify billing team
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

**Notes:** Test with both minimum and maximum field lengths

### ONB-SYST-029: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SYST-030: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SYST-031: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-032: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SYST-033: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SYST-034: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SYST-035: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-036: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 12

---

## Create new patient record with unique mrn

**User Story:** As a system, I want to create new patient record with unique mrn, so that I can accomplish my goal effectively\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have - auto-generate MRN; Flows to: 13; Role: System

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-037 | System | Verify Create new patient record with... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-SYST-038 | System | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-039 | System | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SYST-040 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-041 | System | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SYST-042 | System | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SYST-043 | System | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SYST-044 | System | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-045 | System | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-037: Verify Create new patient record with unique mrn
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-SYST-038: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SYST-039: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SYST-040: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-041: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SYST-042: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SYST-043: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SYST-044: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-045: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 13

---

## Verify insurance eligibility in real-time via\.\.\.

**User Story:** As a system, I want to verify insurance eligibility in real-time via clearinghouse api, so that I can accomplish my goal effectively\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Must have - integrate with Availity; Flows to: 10; Role: Registration Staff

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-021 | Registration Staff | Verify Verify insurance eligibility i... | User is logged in as system<br>Validation service is accessible<br>*...(3 total)* | Navigate to the validation feature<br>Enter the data to be validated<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| ONB-RS-022 | Registration Staff | Verify validation handles invalid data | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to validation feature<br>Enter data that should fail validation<br>*...(3 total)* | • Clear indication of validation failure<br>• Specific reason for failure is shown<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-023 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-021: Verify Verify insurance eligibility in real-time via...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Validation service is accessible
- Test data for validation is prepared

**Test Steps:**
1. Navigate to the validation feature
2. Enter the data to be validated
3. Click Validate/Check button
4. Wait for validation to complete
5. Verify validation result is displayed correctly

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-RS-022: Verify validation handles invalid data
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to validation feature
2. Enter data that should fail validation
3. Execute validation

**Expected Results:**
• Clear indication of validation failure
• Specific reason for failure is shown
• Guidance on correcting the data

**Notes:** Verify error handling and user feedback

### ONB-RS-023: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 14

---

## Patient completes consent forms electronically

**User Story:** As a system, I want to have Patient completes consent forms electronically, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Should have - e-signature; Flows to: 16; Role: Patient

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-PATI-003 | Patient | Verify Patient completes consent form... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| ONB-PATI-004 | Patient | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-PATI-005 | Patient | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-PATI-006 | Patient | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-PATI-007 | Patient | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-PATI-008 | Patient | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-PATI-009 | Patient | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-PATI-010 | Patient | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-PATI-011 | Patient | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-PATI-003: Verify Patient completes consent forms electronically
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-PATI-004: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-PATI-005: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-PATI-006: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-PATI-007: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-PATI-008: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-PATI-009: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-PATI-010: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-PATI-011: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 15

---

## Send insurance verification confirmation to registration\.\.\.

**User Story:** As a system, I want to send insurance verification confirmation to registration staff, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Flows to: 14; Role: System

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-046 | System | Verify Send insurance verification co... | User is logged in as system<br>Notification settings are configured<br>*...(3 total)* | Trigger the notification condition<br>Wait for the notification to be sent<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| ONB-SYST-047 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-046: Verify Send insurance verification confirmation to registration...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Notification settings are configured
- Recipient contact information is valid

**Test Steps:**
1. Trigger the notification condition
2. Wait for the notification to be sent
3. Verify notification is received (email/SMS/in-app)
4. Verify notification content is correct

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-SYST-047: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 16

---

## Review consent forms for completeness

**User Story:** As a system, I want to review consent forms for completeness, so that I can quickly understand the current status\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Flows to: 19; Role: Registration Staff

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-024 | Registration Staff | Verify Review consent forms for compl... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| ONB-RS-025 | Registration Staff | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-026 | Registration Staff | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-RS-027 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-RS-028 | Registration Staff | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-RS-029 | Registration Staff | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-RS-030 | Registration Staff | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-RS-031 | Registration Staff | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-RS-032 | Registration Staff | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-024: Verify Review consent forms for completeness
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Data is displayed within 3 seconds of page load
• Display updates when underlying data changes
• User can only view data they have permission to access

**Notes:** Test with both minimum and maximum field lengths

### ONB-RS-025: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-RS-026: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-RS-027: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-RS-028: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-RS-029: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-RS-030: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-RS-031: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-RS-032: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 18

---

## Send reminder notification to patient for missing consents

**User Story:** As a system, I want to send reminder notification to patient for missing consents, so that I can accomplish my goal effectively\.

**Priority:** 🟢 Low

**Description:**
\*\*Notes:\*\* Could have - SMS or email; Flows to: 17; Role: System

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-048 | System | Verify Send reminder notification to ... | User is logged in as system<br>Notification settings are configured<br>*...(3 total)* | Trigger the notification condition<br>Wait for the notification to be sent<br>*...(4 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Could Have | 8-10 min |  |
| ONB-SYST-049 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-048: Verify Send reminder notification to patient for missing consents
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Notification settings are configured
- Recipient contact information is valid

**Test Steps:**
1. Trigger the notification condition
2. Wait for the notification to be sent
3. Verify notification is received (email/SMS/in-app)
4. Verify notification content is correct

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

### ONB-SYST-049: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 19

---

## Generate patient welcome packet with appointment details\.\.\.

**User Story:** As a system, I want to generate patient welcome packet with appointment details visit instructions, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Should have; Flows to: 20; Role: System

ℹ️ Split from compound requirement \(1 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-050 | System | Verify Generate patient welcome packe... | User is logged in as system<br>Available time slots exist<br>*...(3 total)* | Navigate to the scheduling/booking feature<br>Select an available date and time slot<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min | Consider time zone implicat... |
| ONB-SYST-051 | System | Verify booking unavailable slot fails... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to scheduling feature<br>Attempt to book an already-taken slot<br>*...(3 total)* | • Error indicates slot is no longer available<br>• Alternative slots are suggested<br>*...(3 total)* | Should Have | 5-7 min | Handles race condition when... |
| ONB-SYST-052 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SYST-053 | System | Verify concurrent booking handling | User is logged in with appropriate role<br>Test environment supports edge case data | Open booking page in two browser windows<br>Select same time slot in both<br>*...(3 total)* | • Only one booking succeeds<br>• Other receives 'slot taken' message<br>*...(3 total)* | Could Have | 5-7 min | Race condition test - criti... |
| ONB-SYST-054 | System | Verify booking at earliest available ... | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the earliest available slot<br>*...(3 total)* | • Booking is accepted<br>• Confirmation shows correct time | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SYST-055 | System | Verify booking at latest available time | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the latest available slot in the day<br>*...(3 total)* | • Booking is accepted<br>• No time zone issues at day boundary | Could Have | 5-7 min | Boundary test - verify limi... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-050: Verify Generate patient welcome packet with appointment details...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Available time slots exist
- Calendar/schedule is accessible

**Test Steps:**
1. Navigate to the scheduling/booking feature
2. Select an available date and time slot
3. Enter any required booking details
4. Confirm the booking
5. Verify confirmation message/email is received

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Consider time zone implications

### ONB-SYST-051: Verify booking unavailable slot fails gracefully
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to scheduling feature
2. Attempt to book an already-taken slot
3. Submit the booking

**Expected Results:**
• Error indicates slot is no longer available
• Alternative slots are suggested
• No double-booking occurs

**Notes:** Handles race condition when slot is taken between display and booking

### ONB-SYST-052: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SYST-053: Verify concurrent booking handling
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Open booking page in two browser windows
2. Select same time slot in both
3. Submit both bookings simultaneously

**Expected Results:**
• Only one booking succeeds
• Other receives 'slot taken' message
• No double-booking in system

**Notes:** Race condition test - critical for booking systems

### ONB-SYST-054: Verify booking at earliest available time
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to scheduling
2. Select the earliest available slot
3. Complete the booking

**Expected Results:**
• Booking is accepted
• Confirmation shows correct time

**Notes:** Boundary test - verify limits are enforced

### ONB-SYST-055: Verify booking at latest available time
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to scheduling
2. Select the latest available slot in the day
3. Complete the booking

**Expected Results:**
• Booking is accepted
• No time zone issues at day boundary

**Notes:** Boundary test - verify limits are enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 20

---

## Facility map

**User Story:** As a system, I want to have facility map, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Should have; Flows to: 20; Role: System

ℹ️ Split from compound requirement \(2 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SYST-056 | System | Verify Facility map | User is logged in as system | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| ONB-SYST-057 | System | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SYST-056: Verify Facility map
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: have facility map
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-SYST-057: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 20

---

## Process outcome: End: Patient Onboarded

**User Story:** As a user, I want to process outcome: End: Patient Onboarded, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Exit point; Role: Patient

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-PATI-012 | Patient | Verify Process outcome: End: Patient ... | User is logged in as user | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| ONB-PATI-013 | Patient | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-PATI-012: Verify Process outcome: End: Patient Onboarded
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: process outcome: End: Patient Onboarded
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### ONB-PATI-013: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 21

---

## TODO: Add HIPAA audit logging throughout

**User Story:** As a system, I want to have TODO: Add HIPAA audit logging throughout, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Compliance requirement

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-SF-001 | System Function | Verify TODO: Add HIPAA audit logging ... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| ONB-SF-002 | System Function | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SF-003 | System Function | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| ONB-SF-004 | System Function | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-SF-005 | System Function | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| ONB-SF-006 | System Function | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| ONB-SF-007 | System Function | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| ONB-SF-008 | System Function | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-SF-009 | System Function | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-SF-001: Verify TODO: Add HIPAA audit logging throughout
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### ONB-SF-002: Verify form submission fails with missing required fields
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Leave required fields empty
3. Attempt to submit the form

**Expected Results:**
• Form submission is prevented
• Required fields are highlighted
• Clear error message indicates what's missing
• Previously entered data is preserved

**Notes:** Verify error handling and user feedback

### ONB-SF-003: Verify form validation for invalid data format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to the data entry form
2. Enter invalid format (e.g., letters in phone field, invalid email)
3. Attempt to submit

**Expected Results:**
• Validation error is displayed
• Invalid field is highlighted
• Helpful format guidance is shown

**Notes:** Verify error handling and user feedback

### ONB-SF-004: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-SF-005: Verify handling of maximum length input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the entry form
2. Enter maximum allowed characters in text fields
3. Submit the form

**Expected Results:**
• System accepts input up to max length
• No truncation occurs without warning
• Database stores full value

**Notes:** Edge case - verify robustness

### ONB-SF-006: Verify duplicate entry prevention
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Create a record with specific identifying data
2. Attempt to create another record with same identifiers
3. Observe system behavior

**Expected Results:**
• Duplicate is detected
• Clear message about existing record
• Option to view existing or modify entry

**Notes:** May not apply if duplicates are allowed

### ONB-SF-007: Verify handling of special characters in input
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Navigate to the feature
2. Enter data containing special characters: < > & " ' / \
3. Submit/save the data
4. Verify data is handled correctly

**Expected Results:**
• Special characters are properly escaped/encoded
• No XSS or injection vulnerabilities
• Data displays correctly when retrieved

**Notes:** Security consideration - prevents injection attacks

### ONB-SF-008: Verify minimum required field length
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter single character in a required text field
3. Attempt to submit

**Expected Results:**
• If minimum > 1, validation error displayed
• If minimum = 1, submission succeeds
• Clear message about minimum length requirement

**Notes:** Boundary test - verify limits are enforced

### ONB-SF-009: Verify numeric field minimum value
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to the form
2. Enter 0 or negative number in numeric field
3. Attempt to submit

**Expected Results:**
• Validation enforces minimum value
• Error message shows allowed range

**Notes:** Document actual min/max for each numeric field

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 22

---

## Handle walk-in vs scheduled patient differently

**User Story:** As a system, I want to handle walk-in vs scheduled patient differently, so that I can accomplish my goal effectively\.

**Priority:** 🟢 Low

**Description:**
\*\*Notes:\*\* Nice to have; Role: Registration Staff

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| ONB-RS-033 | Registration Staff | Verify Handle walk-in vs scheduled pa... | User is logged in as system<br>Available time slots exist<br>*...(3 total)* | Navigate to the scheduling/booking feature<br>Select an available date and time slot<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Could Have | 8-10 min | Consider time zone implicat... |
| ONB-RS-034 | Registration Staff | Verify booking unavailable slot fails... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to scheduling feature<br>Attempt to book an already-taken slot<br>*...(3 total)* | • Error indicates slot is no longer available<br>• Alternative slots are suggested<br>*...(3 total)* | Should Have | 5-7 min | Handles race condition when... |
| ONB-RS-035 | Registration Staff | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| ONB-RS-036 | Registration Staff | Verify concurrent booking handling | User is logged in with appropriate role<br>Test environment supports edge case data | Open booking page in two browser windows<br>Select same time slot in both<br>*...(3 total)* | • Only one booking succeeds<br>• Other receives 'slot taken' message<br>*...(3 total)* | Could Have | 5-7 min | Race condition test - criti... |
| ONB-RS-037 | Registration Staff | Verify booking at earliest available ... | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the earliest available slot<br>*...(3 total)* | • Booking is accepted<br>• Confirmation shows correct time | Could Have | 5-7 min | Boundary test - verify limi... |
| ONB-RS-038 | Registration Staff | Verify booking at latest available time | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the latest available slot in the day<br>*...(3 total)* | • Booking is accepted<br>• No time zone issues at day boundary | Could Have | 5-7 min | Boundary test - verify limi... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### ONB-RS-033: Verify Handle walk-in vs scheduled patient differently
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Available time slots exist
- Calendar/schedule is accessible

**Test Steps:**
1. Navigate to the scheduling/booking feature
2. Select an available date and time slot
3. Enter any required booking details
4. Confirm the booking
5. Verify confirmation message/email is received

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Consider time zone implications

### ONB-RS-034: Verify booking unavailable slot fails gracefully
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to scheduling feature
2. Attempt to book an already-taken slot
3. Submit the booking

**Expected Results:**
• Error indicates slot is no longer available
• Alternative slots are suggested
• No double-booking occurs

**Notes:** Handles race condition when slot is taken between display and booking

### ONB-RS-035: Verify unauthorized access is blocked
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Log out of the system
2. Attempt to access the feature URL directly
3. Observe the system response

**Expected Results:**
• User is redirected to login page
• No protected data is displayed
• Session is not created

**Notes:** Security test - verify authentication is enforced

### ONB-RS-036: Verify concurrent booking handling
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Open booking page in two browser windows
2. Select same time slot in both
3. Submit both bookings simultaneously

**Expected Results:**
• Only one booking succeeds
• Other receives 'slot taken' message
• No double-booking in system

**Notes:** Race condition test - critical for booking systems

### ONB-RS-037: Verify booking at earliest available time
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to scheduling
2. Select the earliest available slot
3. Complete the booking

**Expected Results:**
• Booking is accepted
• Confirmation shows correct time

**Notes:** Boundary test - verify limits are enforced

### ONB-RS-038: Verify booking at latest available time
*📏 Boundary*

**Pre-Requisites:**
- User is logged in with appropriate role
- Boundary values are documented

**Test Steps:**
1. Navigate to scheduling
2. Select the latest available slot in the day
3. Complete the booking

**Expected Results:**
• Booking is accepted
• No time zone issues at day boundary

**Notes:** Boundary test - verify limits are enforced

</details>

**Dependencies:** None

**Source:** lucidchart_export_test.csv, Row 24

---
