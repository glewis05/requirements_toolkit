# User Stories & UAT Test Cases

**Generated:** 2025-12-18 09:14
**Source:** test_requirements.docx

## Summary

### Overview

- **Total User Stories:** 9
- **Total UAT Test Cases:** 35

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 0 |
| 🟠 High | 2 |
| 🟡 Medium | 4 |
| 🟢 Low | 3 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 9 |
| ❌ Negative | 18 |
| 🔶 Edge Case | 4 |
| 📏 Boundary | 4 |

---

## Table of Contents

1. [Allow users to login with email and password](#allow-users-to-login-with-email-and-password)
2. [Be able to reset their password via email](#be-able-to-reset-their-password-via-email)
3. [Support two-factor authentication](#support-two-factor-authentication)
4. [Allow administrators to create new user accounts.](#allow-administrators-to-create-new-user-accounts)
5. [Administrators must be able to assign roles to users.](#administrators-must-be-able-to-assign-roles-to-users)
6. [Log all user management activities.](#log-all-user-management-activities)
7. [Respond to user actions within 2 seconds](#respond-to-user-actions-within-2-seconds)
8. [Handle at least 1000 concurrent users](#handle-at-least-1000-concurrent-users)
9. [System availability should be 99.9% uptime](#system-availability-should-be-999-uptime)

---

## Allow users to login with email and password

**User Story:** As a system, I want to login with email and password, so that I can securely access the system\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Core feature

**Acceptance Criteria:**
- [ ] Given valid credentials, When user submits login, Then user is authenticated and redirected to dashboard
- [ ] Given invalid credentials, When user submits login, Then appropriate error message is displayed
- [ ] Given session timeout, When user tries to access protected page, Then user is redirected to login
- [ ] Password must meet complexity requirements (min 8 chars, 1 uppercase, 1 number)
- [ ] Password is stored using secure hashing (bcrypt or similar)
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-001 | Functional Requirements > Authentication | Verify Allow users to login with emai... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given valid credentials, When user submits lo...<br>• Given invalid credentials, When user submits ...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| SPEC-FR>-002 | Functional Requirements > Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| SPEC-FR>-003 | Functional Requirements > Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| SPEC-FR>-004 | Functional Requirements > Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-001: Verify Allow users to login with email and password
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
• Given valid credentials, When user submits login, Then user is authenticated and redirected to dashboard
• Given invalid credentials, When user submits login, Then appropriate error message is displayed
• Given session timeout, When user tries to access protected page, Then user is redirected to login

**Notes:** Verify across different browsers/devices

### SPEC-FR>-002: Verify login fails with invalid password
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

### SPEC-FR>-003: Verify login fails with non-existent user
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

### SPEC-FR>-004: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 1

---

## Be able to reset their password via email

**User Story:** As a users, I want to reset their password via email, so that I can securely access the system\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Security requirement

**Acceptance Criteria:**
- [ ] Given a valid email, When user requests password reset, Then reset email is sent within 5 minutes
- [ ] Given a reset link, When user clicks link, Then user can set a new password
- [ ] Given an expired reset link, When user clicks link, Then user sees expiration message with option to request new link
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-005 | Functional Requirements > Authentication | Verify Be able to reset their passwor... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given a valid email, When user requests passw...<br>• Given a reset link, When user clicks link, Th...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| SPEC-FR>-006 | Functional Requirements > Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| SPEC-FR>-007 | Functional Requirements > Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| SPEC-FR>-008 | Functional Requirements > Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-005: Verify Be able to reset their password via email
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
• Given a valid email, When user requests password reset, Then reset email is sent within 5 minutes
• Given a reset link, When user clicks link, Then user can set a new password
• Given an expired reset link, When user clicks link, Then user sees expiration message with option to request new link

**Notes:** Verify across different browsers/devices

### SPEC-FR>-006: Verify login fails with invalid password
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

### SPEC-FR>-007: Verify login fails with non-existent user
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

### SPEC-FR>-008: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 2

---

## Support two-factor authentication

**User Story:** As a system, I want to support two-factor authentication, so that I can securely access the system\.

**Priority:** 🟡 Medium

**Description:**
\*\*Notes:\*\* Future enhancement

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-009 | Functional Requirements > Authentication | Verify Support two-factor authentication | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Verify across different bro... |
| SPEC-FR>-010 | Functional Requirements > Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| SPEC-FR>-011 | Functional Requirements > Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| SPEC-FR>-012 | Functional Requirements > Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-009: Verify Support two-factor authentication
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
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Verify across different browsers/devices

### SPEC-FR>-010: Verify login fails with invalid password
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

### SPEC-FR>-011: Verify login fails with non-existent user
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

### SPEC-FR>-012: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 3

---

## Allow administrators to create new user accounts\.

**User Story:** As a system, I want to allow administrators to create new user accounts, so that I can accomplish my goal effectively\.

**Priority:** 🟢 Low

**Description:**
ℹ️ Split from compound requirement \(1 of 3\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-013 | Functional Requirements > User Management | Verify Allow administrators to create... | User is logged in as system<br>User has permission to create records<br>*...(3 total)* | Navigate to the user entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Could Have | 8-10 min | Test with both minimum and ... |
| SPEC-FR>-014 | Functional Requirements > User Management | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| SPEC-FR>-015 | Functional Requirements > User Management | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| SPEC-FR>-016 | Functional Requirements > User Management | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| SPEC-FR>-017 | Functional Requirements > User Management | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| SPEC-FR>-018 | Functional Requirements > User Management | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| SPEC-FR>-019 | Functional Requirements > User Management | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| SPEC-FR>-020 | Functional Requirements > User Management | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| SPEC-FR>-021 | Functional Requirements > User Management | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-013: Verify Allow administrators to create new user accounts.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the user entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Test with both minimum and maximum field lengths

### SPEC-FR>-014: Verify form submission fails with missing required fields
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

### SPEC-FR>-015: Verify form validation for invalid data format
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

### SPEC-FR>-016: Verify unauthorized access is blocked
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

### SPEC-FR>-017: Verify handling of maximum length input
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

### SPEC-FR>-018: Verify duplicate entry prevention
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

### SPEC-FR>-019: Verify handling of special characters in input
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

### SPEC-FR>-020: Verify minimum required field length
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

### SPEC-FR>-021: Verify numeric field minimum value
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

**Source:** test_requirements.docx, Row 7

---

## Administrators must be able to assign roles to users\.

**User Story:** As a administrator, I want to assign roles to users, so that I can accomplish my goal effectively\.

**Priority:** 🟢 Low

**Description:**
ℹ️ Split from compound requirement \(2 of 3\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-022 | Functional Requirements > User Management | Verify Administrators must be able to... | User is logged in as administrator | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Could Have | 8-10 min |  |
| SPEC-FR>-023 | Functional Requirements > User Management | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-022: Verify Administrators must be able to assign roles to users.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as administrator

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: assign roles to users
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### SPEC-FR>-023: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 7

---

## Log all user management activities\.

**User Story:** As a system, I want to log all user management activities, so that I can accomplish my goal effectively\.

**Priority:** 🟢 Low

**Description:**
ℹ️ Split from compound requirement \(3 of 3\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-FR>-024 | Functional Requirements > User Management | Verify Log all user management activi... | User is logged in as system | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Could Have | 8-10 min |  |
| SPEC-FR>-025 | Functional Requirements > User Management | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-FR>-024: Verify Log all user management activities.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: log all user management activities
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### SPEC-FR>-025: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 7

---

## Respond to user actions within 2 seconds

**User Story:** As a system, I want to have respond to user actions within 2 seconds, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-NR-001 | Non-Functional Requirements | Verify Respond to user actions within... | User is logged in as system | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| SPEC-NR-002 | Non-Functional Requirements | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-NR-001: Verify Respond to user actions within 2 seconds
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: have respond to user actions within 2 seconds
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### SPEC-NR-002: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 10

---

## Handle at least 1000 concurrent users

**User Story:** As a system, I want to handle at least 1000 concurrent users, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-NR-003 | Non-Functional Requirements | Verify Handle at least 1000 concurren... | User is logged in as system | Log in with appropriate credentials<br>Navigate to the relevant feature area<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min |  |
| SPEC-NR-004 | Non-Functional Requirements | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-NR-003: Verify Handle at least 1000 concurrent users
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system

**Test Steps:**
1. Log in with appropriate credentials
2. Navigate to the relevant feature area
3. Perform the action: handle at least 1000 concurrent users
4. Verify the action completes successfully

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### SPEC-NR-004: Verify unauthorized access is blocked
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

**Source:** test_requirements.docx, Row 11

---

## System availability should be 99\.9% uptime

**User Story:** As a user, I want to have System availability should be 99\.9% uptime, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| SPEC-NR-005 | Non-Functional Requirements | Verify System availability should be ... | User is logged in as user<br>Available time slots exist<br>*...(3 total)* | Navigate to the scheduling/booking feature<br>Select an available date and time slot<br>*...(5 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Consider time zone implicat... |
| SPEC-NR-006 | Non-Functional Requirements | Verify booking unavailable slot fails... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to scheduling feature<br>Attempt to book an already-taken slot<br>*...(3 total)* | • Error indicates slot is no longer available<br>• Alternative slots are suggested<br>*...(3 total)* | Should Have | 5-7 min | Handles race condition when... |
| SPEC-NR-007 | Non-Functional Requirements | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| SPEC-NR-008 | Non-Functional Requirements | Verify concurrent booking handling | User is logged in with appropriate role<br>Test environment supports edge case data | Open booking page in two browser windows<br>Select same time slot in both<br>*...(3 total)* | • Only one booking succeeds<br>• Other receives 'slot taken' message<br>*...(3 total)* | Could Have | 5-7 min | Race condition test - criti... |
| SPEC-NR-009 | Non-Functional Requirements | Verify booking at earliest available ... | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the earliest available slot<br>*...(3 total)* | • Booking is accepted<br>• Confirmation shows correct time | Could Have | 5-7 min | Boundary test - verify limi... |
| SPEC-NR-010 | Non-Functional Requirements | Verify booking at latest available time | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the latest available slot in the day<br>*...(3 total)* | • Booking is accepted<br>• No time zone issues at day boundary | Could Have | 5-7 min | Boundary test - verify limi... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### SPEC-NR-005: Verify System availability should be 99.9% uptime
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
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

### SPEC-NR-006: Verify booking unavailable slot fails gracefully
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

### SPEC-NR-007: Verify unauthorized access is blocked
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

### SPEC-NR-008: Verify concurrent booking handling
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

### SPEC-NR-009: Verify booking at earliest available time
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

### SPEC-NR-010: Verify booking at latest available time
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

**Source:** test_requirements.docx, Row 12

---
