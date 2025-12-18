# User Stories & UAT Test Cases

**Generated:** 2025-12-17 15:54
**Source:** Autonomous Requirements Test.xlsx

## Summary

### Overview

- **Total User Stories:** 6
- **Total UAT Test Cases:** 27

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 0 |
| 🟠 High | 2 |
| 🟡 Medium | 4 |
| 🟢 Low | 0 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 6 |
| ❌ Negative | 14 |
| 🔶 Edge Case | 5 |
| 📏 Boundary | 2 |

---

## Table of Contents

1. [Allow users to login using email and password](#allow-users-to-login-using-email-and-password)
2. [Be able to reset their password via email link](#be-able-to-reset-their-password-via-email-link)
3. [View their profile](#view-their-profile)
4. [Edit their profile](#edit-their-profile)
5. [Upload a profile picture](#upload-a-profile-picture)
6. [Delete their account](#delete-their-account)

---

## Allow users to login using email and password

**User Story:** As a system, I want to login using email and password, so that I can securely access the system\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* SSO will be phase 2

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
| REQ-AUTH-001 | Authentication | Verify Allow users to login using ema... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given valid credentials, When user submits lo...<br>• Given invalid credentials, When user submits ...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| REQ-AUTH-002 | Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| REQ-AUTH-003 | Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| REQ-AUTH-004 | Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-AUTH-001: Verify Allow users to login using email and password
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

### REQ-AUTH-002: Verify login fails with invalid password
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

### REQ-AUTH-003: Verify login fails with non-existent user
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

### REQ-AUTH-004: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 6

---

## Be able to reset their password via email link

**User Story:** As a users, I want to reset their password via email link, so that I can securely access the system\.

**Priority:** 🟠 High

**Description:**
\*\*Notes:\*\* Check with legal on email retention

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
| REQ-AUTH-005 | Authentication | Verify Be able to reset their passwor... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given a valid email, When user requests passw...<br>• Given a reset link, When user clicks link, Th...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| REQ-AUTH-006 | Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| REQ-AUTH-007 | Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| REQ-AUTH-008 | Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-AUTH-005: Verify Be able to reset their password via email link
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

### REQ-AUTH-006: Verify login fails with invalid password
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

### REQ-AUTH-007: Verify login fails with non-existent user
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

### REQ-AUTH-008: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 7

---

## View their profile

**User Story:** As a user, I want to view their profile, so that I can quickly understand the current status\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Split from compound requirement \(1 of 4\)

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| REQ-DD-001 | Data Display | Verify View their profile | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the file view<br>*...(4 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Should Have | 8-10 min |  |
| REQ-DD-002 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-DD-001: Verify View their profile
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the file view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Data is displayed within 3 seconds of page load
• Display updates when underlying data changes
• User can only view data they have permission to access

### REQ-DD-002: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 8

---

## Edit their profile

**User Story:** As a user, I want to edit their profile, so that I can keep information current and accurate\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Split from compound requirement \(2 of 4\)

**Acceptance Criteria:**
- [ ] Changes are saved when user clicks Save/Submit
- [ ] User sees confirmation message after successful save
- [ ] Unsaved changes trigger warning if user tries to navigate away
- [ ] Invalid input shows clear error message

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| REQ-DE-001 | Data Entry | Verify Edit their profile | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the file entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Changes are saved when user clicks Save/Submit<br>• User sees confirmation message after successf...<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| REQ-DE-002 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| REQ-DE-003 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| REQ-DE-004 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| REQ-DE-005 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| REQ-DE-006 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| REQ-DE-007 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| REQ-DE-008 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| REQ-DE-009 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-DE-001: Verify Edit their profile
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the file entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Changes are saved when user clicks Save/Submit
• User sees confirmation message after successful save
• Unsaved changes trigger warning if user tries to navigate away

**Notes:** Test with both minimum and maximum field lengths

### REQ-DE-002: Verify form submission fails with missing required fields
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

### REQ-DE-003: Verify form validation for invalid data format
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

### REQ-DE-004: Verify unauthorized access is blocked
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

### REQ-DE-005: Verify handling of maximum length input
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

### REQ-DE-006: Verify duplicate entry prevention
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

### REQ-DE-007: Verify handling of special characters in input
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

### REQ-DE-008: Verify minimum required field length
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

### REQ-DE-009: Verify numeric field minimum value
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

**Source:** Autonomous Requirements Test.xlsx, Row 8

---

## Upload a profile picture

**User Story:** As a user, I want to upload a profile picture, so that I can accomplish my goal effectively\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Split from compound requirement \(3 of 4\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| REQ-DI-001 | Data Import | Verify Upload a profile picture | User is logged in as user<br>Valid import file is prepared<br>*...(3 total)* | Navigate to the import function<br>Select a valid import file in the correct format<br>*...(6 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Have rollback plan for fail... |
| REQ-DI-002 | Data Import | Verify import rejects invalid file fo... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to import feature<br>Select a file in wrong format (e.g., .txt inste...<br>*...(3 total)* | • Clear error message about invalid format<br>• List of supported formats is shown<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| REQ-DI-003 | Data Import | Verify import handles corrupted file | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to import feature<br>Upload a corrupted/invalid file<br>*...(3 total)* | • Error message indicates file is unreadable<br>• Partial data is NOT imported<br>*...(3 total)* | Should Have | 5-7 min | Important for data integrity |
| REQ-DI-004 | Data Import | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| REQ-DI-005 | Data Import | Verify import of large batch file | User is logged in with appropriate role<br>Test environment supports edge case data | Prepare import file with 1000+ records<br>Upload and process the file<br>*...(3 total)* | • Progress indicator during processing<br>• All valid records imported<br>*...(3 total)* | Could Have | 5-7 min | Performance test - may need... |
| REQ-DI-006 | Data Import | Verify import handles blank rows grac... | User is logged in with appropriate role<br>Test environment supports edge case data | Prepare import file with scattered blank rows<br>Upload and process<br>*...(3 total)* | • Blank rows are skipped without error<br>• Valid data rows are processed<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-DI-001: Verify Upload a profile picture
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Valid import file is prepared
- User has import permissions

**Test Steps:**
1. Navigate to the import function
2. Select a valid import file in the correct format
3. Click Upload/Import button
4. Wait for import processing to complete
5. Verify success message and record count
6. Verify imported data appears correctly in the system

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

**Notes:** Have rollback plan for failed imports

### REQ-DI-002: Verify import rejects invalid file format
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to import feature
2. Select a file in wrong format (e.g., .txt instead of .xlsx)
3. Attempt to upload

**Expected Results:**
• Clear error message about invalid format
• List of supported formats is shown
• System state is unchanged

**Notes:** Verify error handling and user feedback

### REQ-DI-003: Verify import handles corrupted file
*❌ Negative*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test data is prepared as specified

**Test Steps:**
1. Navigate to import feature
2. Upload a corrupted/invalid file
3. Attempt to process

**Expected Results:**
• Error message indicates file is unreadable
• Partial data is NOT imported
• Transaction is rolled back if applicable

**Notes:** Important for data integrity

### REQ-DI-004: Verify unauthorized access is blocked
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

### REQ-DI-005: Verify import of large batch file
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Prepare import file with 1000+ records
2. Upload and process the file
3. Verify import results

**Expected Results:**
• Progress indicator during processing
• All valid records imported
• Summary report of success/failure counts

**Notes:** Performance test - may need adjusted timeout

### REQ-DI-006: Verify import handles blank rows gracefully
*🔶 Edge Case*

**Pre-Requisites:**
- User is logged in with appropriate role
- Test environment supports edge case data

**Test Steps:**
1. Prepare import file with scattered blank rows
2. Upload and process
3. Check results

**Expected Results:**
• Blank rows are skipped without error
• Valid data rows are processed
• Report indicates rows skipped

**Notes:** Edge case - verify robustness

</details>

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 8

---

## Delete their account

**User Story:** As a user, I want to delete their account, so that I can manage and clean up data\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Split from compound requirement \(4 of 4\)

**Acceptance Criteria:**
- [ ] Confirmation dialog is shown before deletion
- [ ] Deleted item is removed from all views
- [ ] User sees success message after deletion

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| REQ-DM-001 | Data Management | Verify Delete their account | User is logged in as user<br>Target record exists in the system<br>*...(3 total)* | Navigate to the account to be deleted<br>Click Delete/Remove button<br>*...(4 total)* | • Confirmation dialog is shown before deletion<br>• Deleted item is removed from all views<br>*...(3 total)* | Should Have | 8-10 min |  |
| REQ-DM-002 | Data Management | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### REQ-DM-001: Verify Delete their account
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Target record exists in the system
- User has delete permissions

**Test Steps:**
1. Navigate to the account to be deleted
2. Click Delete/Remove button
3. Confirm the deletion in the confirmation dialog
4. Verify the item is removed from the list

**Expected Results:**
• Confirmation dialog is shown before deletion
• Deleted item is removed from all views
• User sees success message after deletion

### REQ-DM-002: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 8

---
