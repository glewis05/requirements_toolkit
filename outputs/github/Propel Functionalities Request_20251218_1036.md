# User Stories & UAT Test Cases

**Generated:** 2025-12-18 10:36
**Source:** Propel Functionalities Request.xlsx

## Summary

### Overview

- **Total User Stories:** 15
- **Total UAT Test Cases:** 232

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 0 |
| 🟠 High | 9 |
| 🟡 Medium | 6 |
| 🟢 Low | 0 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 126 |
| ❌ Negative | 75 |
| 🔶 Edge Case | 19 |
| 📏 Boundary | 12 |

### ⚠️ Items Requiring Attention

- **Need to be able to pull list of patients who have...**: Vague, Vague Term:Etc
- **Demographic comparison for various filters (gender,...**: Vague, Vague Term:Etc

---

## Table of Contents

1. [Track number (N) of patients who received invitations](#track-number-n-of-patients-who-received-invitations)
2. [Compare consent vs. decline consent rates](#compare-consent-vs-decline-consent-rates)
3. [Identify recruitment volume by program](#identify-recruitment-volume-by-program)
4. [See where users stop in the consent process](#see-where-users-stop-in-the-consent-process)
5. [Monitor if emails are opened or ignored](#monitor-if-emails-are-opened-or-ignored)
6. [Monitor which users opt out of reminder emails](#monitor-which-users-opt-out-of-reminder-emails)
7. [Track users who decline to participate in the registry...](#track-users-who-decline-to-participate-in-the-registry)
8. [Need to be able to pull list of patients who have...](#need-to-be-able-to-pull-list-of-patients-who-have)
9. [Track amount of time spent on each consent form page](#track-amount-of-time-spent-on-each-consent-form-page)
10. [Demographic comparison for various filters (gender,...](#demographic-comparison-for-various-filters-gender)
11. [Enables Discover Research team to order saliva kits via...](#enables-discover-research-team-to-order-saliva-kits-via)
12. [Cross validate participants entering through the MyChart...](#cross-validate-participants-entering-through-the-mychart)
13. [Once cross validation is confirmed, a patient is allowed...](#once-cross-validation-is-confirmed-a-patient-is-allowed)
14. [Show a personalized list of available studies on the...](#show-a-personalized-list-of-available-studies-on-the)
15. [Allows for researchers to reach out to patients via SMS...](#allows-for-researchers-to-reach-out-to-patients-via-sms)
16. [Traceability Matrix](#traceability-matrix)

---

## Track number \(N\) of patients who received invitations

**User Story:** As a user, I want to track number \(N\) of patients who received invitations, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Updated Clarifying Question for meeting:

When you say 'number of invited patients,' which point in the funnel are you trying to measure?

Option A: Gross invitations sent \(total emails dispatched\)
Option B: Patients who started the assessment \(actual engagement\) 
Option C: Patients who completed the assessment and are eligible for Discover

Options B or C would give you a more actionable number since they reflect real patient engagement, not just email volume\.

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-001 | Recruitment Analytics | Verify Track number (N) of patients w... | User is logged in as user<br>Target record exists in the system<br>*...(3 total)* | Navigate to the existing patient record<br>Click Edit button<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| DIS-RA-002 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-RA-003 | Recruitment Analytics | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-001: Verify Track number (N) of patients who received invitations
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Target record exists in the system
- User has edit permissions

**Test Steps:**
1. Navigate to the existing patient record
2. Click Edit button
3. Modify one or more fields with valid data
4. Click Save/Update button
5. Verify changes are saved and displayed correctly

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### DIS-RA-002: Verify unauthorized access is blocked
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

### DIS-RA-003: Verify handling of special characters in input
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

</details>

**Dependencies:** None

**Source:** Propel Functionalities Request.xlsx, Row 2

---

## Compare consent vs\. decline consent rates

**User Story:** As a user, I want to have Compare consent vs\. decline consent rates, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
ℹ️ Split from compound requirement \(1 of 1\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-004 | Recruitment Analytics | Verify Compare consent vs. decline co... | User is logged in as user | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| DIS-RA-005 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-004: Verify Compare consent vs. decline consent rates
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: have Compare consent vs. decline consent rates
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### DIS-RA-005: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 3

---

## Identify recruitment volume by program

**User Story:** As a user, I want to have Identify recruitment volume by program, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-006 | Recruitment Analytics | Verify Identify recruitment volume by... | User is logged in as user | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| DIS-RA-007 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-006: Verify Identify recruitment volume by program
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: have Identify recruitment volume by program
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### DIS-RA-007: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 4

---

## See where users stop in the consent process

**User Story:** As a user, I want to see where users stop in the consent process, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-008 | Recruitment Analytics | Verify See where users stop in the co... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the user view<br>*...(4 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Should Have | 8-10 min |  |
| DIS-RA-009 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-008: Verify See where users stop in the consent process
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the user view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Data is displayed within 3 seconds of page load
• Display updates when underlying data changes
• User can only view data they have permission to access

### DIS-RA-009: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 5

---

## Monitor if emails are opened or ignored

**User Story:** As a user, I want to monitor if emails are opened or ignored, so that I can stay informed about important events\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* I'd caution against using email opens as a meaningful metric\. Palbox tracks opens by detecting when the email client requests images\. If a patient's email client or browser blocks images by default — which is increasingly common — they can read the entire email but it won't register as opened\. This means open rates will consistently under-report actual engagement\.
That's why I recommend measuring from assessment started or assessment completed — those are definitive actions we can track with confidence\.

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-010 | Recruitment Analytics | Verify Monitor if emails are opened o... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| DIS-RA-011 | Recruitment Analytics | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| DIS-RA-012 | Recruitment Analytics | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| DIS-RA-013 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-010: Verify Monitor if emails are opened or ignored
*✅ Happy Path*

**Pre-Requisites:**
- Valid test user credentials are available
- User account is not locked

**Test Steps:**
1. Navigate to the login page
2. Enter valid username/email
3. Enter valid password
4. Click the login/sign-in button
5. Verify successful authentication

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

**Notes:** Verify across different browsers/devices

### DIS-RA-011: Verify login fails with invalid password
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to login page
2. Enter valid username
3. Enter incorrect password
4. Click login button

**Expected Results:**
• Error message displayed (generic, not revealing which field is wrong)
• User remains on login page
• Failed attempt is logged

**Notes:** Do not reveal whether username or password was incorrect

### DIS-RA-012: Verify login fails with non-existent user
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to login page
2. Enter non-existent username
3. Enter any password
4. Click login button

**Expected Results:**
• Same generic error message as invalid password
• No indication that user doesn't exist
• Response time similar to valid user check

**Notes:** Prevents user enumeration attacks

### DIS-RA-013: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 6

---

## Monitor which users opt out of reminder emails

**User Story:** As a user, I want to monitor which users opt out of reminder emails, so that I can stay informed about important events\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* For reminder email opt-out tracking, which scope are you looking for?

Option A: Discover-specific reminder opt-outs only \(patients who reached Discover and opted out of its reminders\) 
Option B: All reminder opt-outs across upstream programs \(Prevention4ME, Precision4ME, GenoRX\) that feed into Discover
Option C: Both — a combined view showing opt-outs at each program stage

Keep in mind: With Option B or C, a patient may opt out of upstream reminders before they ever know Discover is part of the journey\. Do you want visibility into that, or only patients who explicitly opted out of Discover communications?

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-014 | Recruitment Analytics | Verify Monitor which users opt out of... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the user entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| DIS-RA-015 | Recruitment Analytics | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-016 | Recruitment Analytics | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-017 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-RA-018 | Recruitment Analytics | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-RA-019 | Recruitment Analytics | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-RA-020 | Recruitment Analytics | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-RA-021 | Recruitment Analytics | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-RA-022 | Recruitment Analytics | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-014: Verify Monitor which users opt out of reminder emails
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the user entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

**Notes:** Test with both minimum and maximum field lengths

### DIS-RA-015: Verify form submission fails with missing required fields
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

### DIS-RA-016: Verify form validation for invalid data format
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

### DIS-RA-017: Verify unauthorized access is blocked
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

### DIS-RA-018: Verify handling of maximum length input
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

### DIS-RA-019: Verify duplicate entry prevention
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

### DIS-RA-020: Verify handling of special characters in input
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

### DIS-RA-021: Verify minimum required field length
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

### DIS-RA-022: Verify numeric field minimum value
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

**Source:** Propel Functionalities Request.xlsx, Row 7

---

## Track users who decline to participate in the registry\.\.\.

**User Story:** As a user, I want to track users who decline to participate in the registry entirely, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-023 | Recruitment Analytics | Verify Track users who decline to par... | User is logged in as user | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| DIS-RA-024 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-023: Verify Track users who decline to participate in the registry...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: track users who decline to participate in the registry entirely
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### DIS-RA-024: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 8

---

## Need to be able to pull list of patients who have\.\.\.

**User Story:** As a user, I want to have be able to pull list of patients who have declined to participate in the registry, consented, opted-in for future research, etc, so that I can quickly locate the information I need\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Currently you can filter by patient status and download lists\. Can you help me understand where the gap is?

Access Issue: Do you need someone without full system access to pull these reports?
Usability Issue: Is the current filter/download process too cumbersome or slow?
Format Issue: Do you need the data in a different format or with additional fields?
Automation Issue: Are you looking for scheduled/automated reports instead of manual pulls?

Understanding what's friction today will help us scope the right solution\.

⚠️ \*\*Needs clarification:\*\* Contains vague terms: etc

**Acceptance Criteria:**
- [ ] Search results appear within 2 seconds
- [ ] Search matches are highlighted
- [ ] No results shows helpful message with suggestions

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-025 | Recruitment Analytics | Verify Need to be able to pull list o... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Search results appear within 2 seconds<br>• Search matches are highlighted<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| DIS-RA-026 | Recruitment Analytics | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-027 | Recruitment Analytics | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-028 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-RA-029 | Recruitment Analytics | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-RA-030 | Recruitment Analytics | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-RA-031 | Recruitment Analytics | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-RA-032 | Recruitment Analytics | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-RA-033 | Recruitment Analytics | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-025: Verify Need to be able to pull list of patients who have...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Search results appear within 2 seconds
• Search matches are highlighted
• No results shows helpful message with suggestions

**Notes:** Test with both minimum and maximum field lengths

### DIS-RA-026: Verify form submission fails with missing required fields
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

### DIS-RA-027: Verify form validation for invalid data format
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

### DIS-RA-028: Verify unauthorized access is blocked
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

### DIS-RA-029: Verify handling of maximum length input
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

### DIS-RA-030: Verify duplicate entry prevention
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

### DIS-RA-031: Verify handling of special characters in input
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

### DIS-RA-032: Verify minimum required field length
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

### DIS-RA-033: Verify numeric field minimum value
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

**Quality Flags:**
- ⚠️ Vague
- ⚠️ Vague Term:Etc

**Dependencies:** None

**Source:** Propel Functionalities Request.xlsx, Row 9

---

## Track amount of time spent on each consent form page

**User Story:** As a user, I want to track amount of time spent on each consent form page, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-034 | Recruitment Analytics | Verify Track amount of time spent on ... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| DIS-RA-035 | Recruitment Analytics | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-036 | Recruitment Analytics | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-037 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-RA-038 | Recruitment Analytics | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-RA-039 | Recruitment Analytics | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-RA-040 | Recruitment Analytics | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-RA-041 | Recruitment Analytics | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-RA-042 | Recruitment Analytics | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-034: Verify Track amount of time spent on each consent form page
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
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

### DIS-RA-035: Verify form submission fails with missing required fields
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

### DIS-RA-036: Verify form validation for invalid data format
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

### DIS-RA-037: Verify unauthorized access is blocked
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

### DIS-RA-038: Verify handling of maximum length input
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

### DIS-RA-039: Verify duplicate entry prevention
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

### DIS-RA-040: Verify handling of special characters in input
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

### DIS-RA-041: Verify minimum required field length
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

### DIS-RA-042: Verify numeric field minimum value
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

**Source:** Propel Functionalities Request.xlsx, Row 10

---

## Demographic comparison for various filters \(gender,\.\.\.

**User Story:** As a user, I want to have Demographic comparison for various filters \(gender, race/ethnicity, age, etc\.\), so that I can quickly locate the information I need\.

**Priority:** 🟡 Medium

**Description:**
⚠️ \*\*Needs clarification:\*\* Contains vague terms: etc

**Acceptance Criteria:**
- [ ] Search results appear within 2 seconds
- [ ] Search matches are highlighted
- [ ] No results shows helpful message with suggestions

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-RA-043 | Recruitment Analytics | Verify Demographic comparison for var... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Search results appear within 2 seconds<br>• Search matches are highlighted<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| DIS-RA-044 | Recruitment Analytics | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-045 | Recruitment Analytics | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-RA-046 | Recruitment Analytics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-RA-047 | Recruitment Analytics | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-RA-048 | Recruitment Analytics | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-RA-049 | Recruitment Analytics | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-RA-050 | Recruitment Analytics | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-RA-051 | Recruitment Analytics | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-RA-043: Verify Demographic comparison for various filters (gender,...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Search results appear within 2 seconds
• Search matches are highlighted
• No results shows helpful message with suggestions

**Notes:** Test with both minimum and maximum field lengths

### DIS-RA-044: Verify form submission fails with missing required fields
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

### DIS-RA-045: Verify form validation for invalid data format
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

### DIS-RA-046: Verify unauthorized access is blocked
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

### DIS-RA-047: Verify handling of maximum length input
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

### DIS-RA-048: Verify duplicate entry prevention
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

### DIS-RA-049: Verify handling of special characters in input
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

### DIS-RA-050: Verify minimum required field length
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

### DIS-RA-051: Verify numeric field minimum value
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

**Quality Flags:**
- ⚠️ Vague
- ⚠️ Vague Term:Etc

**Dependencies:** None

**Source:** Propel Functionalities Request.xlsx, Row 11

---

## Enables Discover Research team to order saliva kits via\.\.\.

**User Story:** As a user, I want to have Enables Discover Research team to order saliva kits via Propel dashboard for participants that opted-in for population sequencing protocol, so that I can quickly understand the current status\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Search results appear within 2 seconds
- [ ] Search matches are highlighted
- [ ] No results shows helpful message with suggestions

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-OL-001 | Operational Logistics | Verify Enables Discover Research team... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the order view<br>*...(4 total)* | • Search results appear within 2 seconds<br>• Search matches are highlighted<br>*...(3 total)* | Should Have | 8-10 min |  |
| DIS-OL-002 | Operational Logistics | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-OL-001: Verify Enables Discover Research team to order saliva kits via...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the order view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Search results appear within 2 seconds
• Search matches are highlighted
• No results shows helpful message with suggestions

### DIS-OL-002: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 12

---

## Cross validate participants entering through the MyChart\.\.\.

**User Story:** As a user, I want to have Cross validate participants entering through the MyChart recruitment pathway against existing e-consent records in Propel to prevent duplicate enrollment from other recruitment pathways, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Enage with Brett on\.

ℹ️ Split from compound requirement \(1 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-DIW-001 | Data Integrity/Recruitment Workflow | Verify Cross validate participants en... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| DIS-DIW-002 | Data Integrity/Recruitment Workflow | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-DIW-003 | Data Integrity/Recruitment Workflow | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-DIW-004 | Data Integrity/Recruitment Workflow | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-DIW-005 | Data Integrity/Recruitment Workflow | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-DIW-006 | Data Integrity/Recruitment Workflow | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-DIW-007 | Data Integrity/Recruitment Workflow | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-DIW-008 | Data Integrity/Recruitment Workflow | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-DIW-009 | Data Integrity/Recruitment Workflow | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-DIW-001: Verify Cross validate participants entering through the MyChart...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
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

### DIS-DIW-002: Verify form submission fails with missing required fields
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

### DIS-DIW-003: Verify form validation for invalid data format
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

### DIS-DIW-004: Verify unauthorized access is blocked
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

### DIS-DIW-005: Verify handling of maximum length input
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

### DIS-DIW-006: Verify duplicate entry prevention
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

### DIS-DIW-007: Verify handling of special characters in input
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

### DIS-DIW-008: Verify minimum required field length
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

### DIS-DIW-009: Verify numeric field minimum value
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

**Source:** Propel Functionalities Request.xlsx, Row 13

---

## Once cross validation is confirmed, a patient is allowed\.\.\.

**User Story:** As a user, I want to have Once cross validation is confirmed, a patient is allowed to proceed with consent if no consent exists or presented with a screen that notes that they have already been enrolled if validation notes a consent exists, so that I can accomplish my goal effectively\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Enage with Brett on\.

ℹ️ Split from compound requirement \(2 of 2\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-DIW-010 | Data Integrity/Recruitment Workflow | Verify Once cross validation is confi... | User is logged in as user<br>Validation service is accessible<br>*...(3 total)* | Navigate to the validation feature<br>Enter the data to be validated<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| DIS-DIW-011 | Data Integrity/Recruitment Workflow | Verify validation handles invalid data | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to validation feature<br>Enter data that should fail validation<br>*...(3 total)* | • Clear indication of validation failure<br>• Specific reason for failure is shown<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-DIW-012 | Data Integrity/Recruitment Workflow | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-DIW-010: Verify Once cross validation is confirmed, a patient is allowed...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
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

### DIS-DIW-011: Verify validation handles invalid data
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

### DIS-DIW-012: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 13

---

## Show a personalized list of available studies on the\.\.\.

**User Story:** As a user, I want to show a personalized list of available studies on the patient dashboard; each study appears as a collapsible accordion with shorthand details and a "Learn more/Sign Up" action, so that I can quickly understand the current status\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Split from compound requirement \(1 of 1\)

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-PEU-001 | Participant Experience/Recruitment UX | Verify Show a personalized list of av... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the patient view<br>*...(4 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Should Have | 8-10 min |  |
| DIS-PEU-002 | Participant Experience/Recruitment UX | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-PEU-001: Verify Show a personalized list of available studies on the...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the patient view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Data is displayed within 3 seconds of page load
• Display updates when underlying data changes
• User can only view data they have permission to access

### DIS-PEU-002: Verify unauthorized access is blocked
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

**Source:** Propel Functionalities Request.xlsx, Row 14

---

## Allows for researchers to reach out to patients via SMS\.\.\.

**User Story:** As a user, I want to have Allows for researchers to reach out to patients via SMS through the platform, so that I can quickly locate the information I need\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* For SMS outreach reminders, here's what we need from you:

Coordinate with Andrew — he'll work with you to gather the required campaign information for Amazon approval
Timeline Expectation: Typically ~2 weeks for approval, but could extend if iterations are needed
Reference: Precision4ME had some friction but still resolved within 2 weeks

What we need to kick this off: The sooner you connect with Andrew, the sooner we can submit\. What's your availability to start that conversation?

**Acceptance Criteria:**
- [ ] Search results appear within 2 seconds
- [ ] Search matches are highlighted
- [ ] No results shows helpful message with suggestions

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| DIS-PEU-003 | Participant Experience/Recruitment UX | Verify Allows for researchers to reac... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the patient entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Search results appear within 2 seconds<br>• Search matches are highlighted<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| DIS-PEU-004 | Participant Experience/Recruitment UX | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-PEU-005 | Participant Experience/Recruitment UX | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| DIS-PEU-006 | Participant Experience/Recruitment UX | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| DIS-PEU-007 | Participant Experience/Recruitment UX | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| DIS-PEU-008 | Participant Experience/Recruitment UX | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| DIS-PEU-009 | Participant Experience/Recruitment UX | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| DIS-PEU-010 | Participant Experience/Recruitment UX | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| DIS-PEU-011 | Participant Experience/Recruitment UX | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### DIS-PEU-003: Verify Allows for researchers to reach out to patients via SMS...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the patient entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Search results appear within 2 seconds
• Search matches are highlighted
• No results shows helpful message with suggestions

**Notes:** Test with both minimum and maximum field lengths

### DIS-PEU-004: Verify form submission fails with missing required fields
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

### DIS-PEU-005: Verify form validation for invalid data format
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

### DIS-PEU-006: Verify unauthorized access is blocked
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

### DIS-PEU-007: Verify handling of maximum length input
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

### DIS-PEU-008: Verify duplicate entry prevention
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

### DIS-PEU-009: Verify handling of special characters in input
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

### DIS-PEU-010: Verify minimum required field length
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

### DIS-PEU-011: Verify numeric field minimum value
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

**Source:** Propel Functionalities Request.xlsx, Row 16

---

## Traceability Matrix

### Coverage Summary

- **Total Requirements:** 14
- **Total Test Cases:** 232

| Coverage Status | Count | Percentage |
|-----------------|-------|------------|
| Full | 8 | 57.1% |
| Partial | 6 | 42.9% |
| None | 0 | 0.0% |

### Compliance Test Coverage

| Framework | Requirements | Tests |
|-----------|--------------|-------|
| Part11 | 0 | 59 |
| HIPAA | 0 | 51 |
| SOC2 | 0 | 46 |

### Detailed Traceability

| Req ID | Requirement | Story ID | Story Title | Test Cases | Compliance | Status |
|--------|-------------|----------|-------------|------------|------------|--------|
| REQ-ROW2 | Track number (N) of patients who rece... | GEN-154EE6 | Track number (N) of patient... | DIS-RA-001, DIS-RA-002 +1 | None | 🟡 Partial |
| REQ-ROW3 | Compare consent vs. decline consent r... | GEN-18FAA8-1 | Compare consent vs. decline... | DIS-RA-004, DIS-RA-005 | None | 🟢 Full |
| REQ-ROW4 | Identify recruitment volume by program | GEN-0FF982 | Identify recruitment volume... | DIS-RA-006, DIS-RA-007 | None | 🟢 Full |
| REQ-ROW5 | See where users stop in the consent p... | GEN-40F34F | See where users stop in the... | DIS-RA-008, DIS-RA-009 | None | 🟢 Full |
| REQ-ROW6 | Monitor if emails are opened or ignored | GEN-6061A2 | Monitor if emails are opene... | DIS-RA-010, DIS-RA-011 +2 | None | 🟢 Full |
| REQ-ROW7 | Monitor which users opt out of remind... | GEN-43775F | Monitor which users opt out... | DIS-RA-014, DIS-RA-015 +7 | None | 🟢 Full |
| REQ-ROW8 | Track users who decline to participat... | GEN-2A9878 | Track users who decline to ... | DIS-RA-023, DIS-RA-024 | None | 🟢 Full |
| REQ-ROW9 | Need to be able to pull list of patie... | GEN-B2432A | Need to be able to pull lis... | DIS-RA-025, DIS-RA-026 +7 | None | 🟡 Partial |
| REQ-ROW10 | Track amount of time spent on each co... | GEN-105341 | Track amount of time spent ... | DIS-RA-034, DIS-RA-035 +7 | None | 🟢 Full |
| REQ-ROW11 | Demographic comparison for various fi... | GEN-DCEE2E | Demographic comparison for ... | DIS-RA-043, DIS-RA-044 +7 | None | 🟡 Partial |
| REQ-ROW12 | Enables Discover Research team to ord... | GEN-1AF5C9 | Enables Discover Research t... | DIS-OL-001, DIS-OL-002 | None | 🟢 Full |
| REQ-ROW13 | Cross validate participants entering ... | GEN-B7C9DB-1 | Cross validate participants... | DIS-DIW-001, DIS-DIW-002 +10 | None | 🟡 Partial |
| REQ-ROW14 | Show a personalized list of available... | GEN-44B0C4-1 | Show a personalized list of... | DIS-PEU-001, DIS-PEU-002 | None | 🟡 Partial |
| REQ-ROW16 | Allows for researchers to reach out t... | GEN-36C0C0 | Allows for researchers to r... | DIS-PEU-003, DIS-PEU-004 +7 | None | 🟡 Partial |

### Identified Gaps

> **Note:** The following requirements have coverage gaps that may need attention.

**REQ-ROW2:**
- May need HIPAA compliance tests

**REQ-ROW9:**
- May need HIPAA compliance tests

**REQ-ROW11:**
- May need HIPAA compliance tests

**REQ-ROW13:**
- May need HIPAA compliance tests

**REQ-ROW14:**
- May need HIPAA compliance tests

**REQ-ROW16:**
- May need HIPAA compliance tests

---
