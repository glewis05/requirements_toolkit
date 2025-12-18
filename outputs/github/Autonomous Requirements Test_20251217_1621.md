# User Stories & UAT Test Cases

**Generated:** 2025-12-17 16:21
**Source:** Autonomous Requirements Test.xlsx

## Summary

### Overview

- **Total User Stories:** 22
- **Total UAT Test Cases:** 93

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 3 |
| 🟠 High | 6 |
| 🟡 Medium | 10 |
| 🟢 Low | 2 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 22 |
| ❌ Negative | 41 |
| 🔶 Edge Case | 18 |
| 📏 Boundary | 12 |

### ⚠️ Items Requiring Attention

- **Make the login faster**: Vague, Vague Term:Faster
- **See a summary dashboard so that I can quickly assess...**: Vague, Vague Term:Quickly
- **Export dashboard data to Excel**: Potential Duplicate, Similar To:Req-005
- **Have the ability to download dashboard information in...**: Potential Duplicate, Similar To:Us-002
- **Reports must be exportable to PDF and Excel formats.**: Priority was auto-assigned (review recommended)
- **Reports should include charts and graphs.**: Priority was auto-assigned (review recommended)
- **Report templates should be customizable.**: Priority was auto-assigned (review recommended)
- **Ad-hoc reporting capability needed**: Priority was auto-assigned (review recommended)

---

## Table of Contents

1. [Allow users to login using email and password](#allow-users-to-login-using-email-and-password)
2. [Be able to reset their password via email link](#be-able-to-reset-their-password-via-email-link)
3. [View their profile](#view-their-profile)
4. [Edit their profile](#edit-their-profile)
5. [Upload a profile picture](#upload-a-profile-picture)
6. [Delete their account](#delete-their-account)
7. [Make the login faster](#make-the-login-faster)
8. [See a summary dashboard so that I can quickly assess...](#see-a-summary-dashboard-so-that-i-can-quickly-assess)
9. [Dashboard should display real-time metrics including sales](#dashboard-should-display-real-time-metrics-including-sales)
10. [Dashboard should support tickets](#dashboard-should-support-tickets)
11. [Dashboard should active users](#dashboard-should-active-users)
12. [Export dashboard data to Excel](#export-dashboard-data-to-excel)
13. [Have the ability to download dashboard information in...](#have-the-ability-to-download-dashboard-information-in)
14. [Generate monthly sales reports automatically](#generate-monthly-sales-reports-automatically)
15. [Reports must be exportable to PDF and Excel formats.](#reports-must-be-exportable-to-pdf-and-excel-formats)
16. [Reports should include charts and graphs.](#reports-should-include-charts-and-graphs)
17. [Report templates should be customizable.](#report-templates-should-be-customizable)
18. [Ad-hoc reporting capability needed](#ad-hoc-reporting-capability-needed)
19. [Integrate with Salesforce CRM via REST API](#integrate-with-salesforce-crm-via-rest-api)
20. [Slack notifications for critical alerts](#slack-notifications-for-critical-alerts)
21. [Integrate with quickbooks](#integrate-with-quickbooks)
22. [Email notifications shall be sent when report generation...](#email-notifications-shall-be-sent-when-report-generation)

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
| GRX-AUTH-001 | Authentication | Verify Allow users to login using ema... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given valid credentials, When user submits lo...<br>• Given invalid credentials, When user submits ...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| GRX-AUTH-002 | Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| GRX-AUTH-003 | Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| GRX-AUTH-004 | Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-AUTH-001: Verify Allow users to login using email and password
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

### GRX-AUTH-002: Verify login fails with invalid password
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

### GRX-AUTH-003: Verify login fails with non-existent user
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

### GRX-AUTH-004: Verify unauthorized access is blocked
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
| GRX-AUTH-005 | Authentication | Verify Be able to reset their passwor... | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given a valid email, When user requests passw...<br>• Given a reset link, When user clicks link, Th...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| GRX-AUTH-006 | Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| GRX-AUTH-007 | Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| GRX-AUTH-008 | Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-AUTH-005: Verify Be able to reset their password via email link
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

### GRX-AUTH-006: Verify login fails with invalid password
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

### GRX-AUTH-007: Verify login fails with non-existent user
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

### GRX-AUTH-008: Verify unauthorized access is blocked
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
| GRX-DD-001 | Data Display | Verify View their profile | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the file view<br>*...(4 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Should Have | 8-10 min |  |
| GRX-DD-002 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-001: Verify View their profile
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

### GRX-DD-002: Verify unauthorized access is blocked
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
| GRX-DE-001 | Data Entry | Verify Edit their profile | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the file entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Changes are saved when user clicks Save/Submit<br>• User sees confirmation message after successf...<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| GRX-DE-002 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-003 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-004 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DE-005 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| GRX-DE-006 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| GRX-DE-007 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| GRX-DE-008 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-DE-009 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DE-001: Verify Edit their profile
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

### GRX-DE-002: Verify form submission fails with missing required fields
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

### GRX-DE-003: Verify form validation for invalid data format
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

### GRX-DE-004: Verify unauthorized access is blocked
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

### GRX-DE-005: Verify handling of maximum length input
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

### GRX-DE-006: Verify duplicate entry prevention
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

### GRX-DE-007: Verify handling of special characters in input
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

### GRX-DE-008: Verify minimum required field length
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

### GRX-DE-009: Verify numeric field minimum value
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
| GRX-DI-001 | Data Import | Verify Upload a profile picture | User is logged in as user<br>Valid import file is prepared<br>*...(3 total)* | Navigate to the import function<br>Select a valid import file in the correct format<br>*...(6 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Should Have | 8-10 min | Have rollback plan for fail... |
| GRX-DI-002 | Data Import | Verify import rejects invalid file fo... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to import feature<br>Select a file in wrong format (e.g., .txt inste...<br>*...(3 total)* | • Clear error message about invalid format<br>• List of supported formats is shown<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DI-003 | Data Import | Verify import handles corrupted file | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to import feature<br>Upload a corrupted/invalid file<br>*...(3 total)* | • Error message indicates file is unreadable<br>• Partial data is NOT imported<br>*...(3 total)* | Should Have | 5-7 min | Important for data integrity |
| GRX-DI-004 | Data Import | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DI-005 | Data Import | Verify import of large batch file | User is logged in with appropriate role<br>Test environment supports edge case data | Prepare import file with 1000+ records<br>Upload and process the file<br>*...(3 total)* | • Progress indicator during processing<br>• All valid records imported<br>*...(3 total)* | Could Have | 5-7 min | Performance test - may need... |
| GRX-DI-006 | Data Import | Verify import handles blank rows grac... | User is logged in with appropriate role<br>Test environment supports edge case data | Prepare import file with scattered blank rows<br>Upload and process<br>*...(3 total)* | • Blank rows are skipped without error<br>• Valid data rows are processed<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DI-001: Verify Upload a profile picture
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

### GRX-DI-002: Verify import rejects invalid file format
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

### GRX-DI-003: Verify import handles corrupted file
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

### GRX-DI-004: Verify unauthorized access is blocked
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

### GRX-DI-005: Verify import of large batch file
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

### GRX-DI-006: Verify import handles blank rows gracefully
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
| GRX-DM-001 | Data Management | Verify Delete their account | User is logged in as user<br>Target record exists in the system<br>*...(3 total)* | Navigate to the account to be deleted<br>Click Delete/Remove button<br>*...(4 total)* | • Confirmation dialog is shown before deletion<br>• Deleted item is removed from all views<br>*...(3 total)* | Should Have | 8-10 min |  |
| GRX-DM-002 | Data Management | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DM-001: Verify Delete their account
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

### GRX-DM-002: Verify unauthorized access is blocked
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

## Make the login faster

**User Story:** As a user, I want to make the login faster, so that I can securely access the system\.

**Priority:** 🟠 High

**Description:**
⚠️ \*\*Needs clarification:\*\* Contains vague terms: faster

**Acceptance Criteria:**
- [ ] Given valid credentials, When user submits login, Then user is authenticated and redirected to dashboard
- [ ] Given invalid credentials, When user submits login, Then appropriate error message is displayed
- [ ] Given session timeout, When user tries to access protected page, Then user is redirected to login

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-AUTH-009 | Authentication | Verify Make the login faster | Valid test user credentials are available<br>User account is not locked | Navigate to the login page<br>Enter valid username/email<br>*...(5 total)* | • Given valid credentials, When user submits lo...<br>• Given invalid credentials, When user submits ...<br>*...(3 total)* | Must Have | 8-10 min | Verify across different bro... |
| GRX-AUTH-010 | Authentication | Verify login fails with invalid password | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter valid username<br>*...(4 total)* | • Error message displayed (generic, not reveali...<br>• User remains on login page<br>*...(3 total)* | Should Have | 8-10 min | Do not reveal whether usern... |
| GRX-AUTH-011 | Authentication | Verify login fails with non-existent ... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to login page<br>Enter non-existent username<br>*...(4 total)* | • Same generic error message as invalid password<br>• No indication that user doesn't exist<br>*...(3 total)* | Should Have | 8-10 min | Prevents user enumeration a... |
| GRX-AUTH-012 | Authentication | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-AUTH-009: Verify Make the login faster
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

### GRX-AUTH-010: Verify login fails with invalid password
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

### GRX-AUTH-011: Verify login fails with non-existent user
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

### GRX-AUTH-012: Verify unauthorized access is blocked
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

**Quality Flags:**
- ⚠️ Vague
- ⚠️ Vague Term:Faster

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 9

---

## See a summary dashboard so that I can quickly assess\.\.\.

**User Story:** As a manager, I want to see a summary dashboard, so that I can quickly assess team performance\.

**Priority:** 🔴 Critical

**Description:**
⚠️ \*\*Needs clarification:\*\* Contains vague terms: quickly

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DE-010 | Data Entry | Verify See a summary dashboard so tha... | User is logged in as manager<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Must Have | 8-10 min | Test with both minimum and ... |
| GRX-DE-011 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-012 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-013 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DE-014 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| GRX-DE-015 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| GRX-DE-016 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| GRX-DE-017 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-DE-018 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DE-010: Verify See a summary dashboard so that I can quickly assess...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as manager
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

### GRX-DE-011: Verify form submission fails with missing required fields
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

### GRX-DE-012: Verify form validation for invalid data format
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

### GRX-DE-013: Verify unauthorized access is blocked
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

### GRX-DE-014: Verify handling of maximum length input
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

### GRX-DE-015: Verify duplicate entry prevention
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

### GRX-DE-016: Verify handling of special characters in input
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

### GRX-DE-017: Verify minimum required field length
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

### GRX-DE-018: Verify numeric field minimum value
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
- ⚠️ Vague Term:Quickly

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 12

---

## Dashboard should display real-time metrics including sales

**User Story:** As a user, I want to view real-time metrics including sales on the dashboard, so that I can quickly understand the current status\.

**Priority:** 🟠 High

**Description:**
ℹ️ Split from compound requirement \(1 of 3\)

**Acceptance Criteria:**
- [ ] Data is displayed within 3 seconds of page load
- [ ] Display updates when underlying data changes
- [ ] User can only view data they have permission to access

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-003 | Data Display | Verify Dashboard should display real-... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the record view<br>*...(4 total)* | • Data is displayed within 3 seconds of page load<br>• Display updates when underlying data changes<br>*...(3 total)* | Must Have | 8-10 min |  |
| GRX-DD-004 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-003: Verify Dashboard should display real-time metrics including sales
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the record view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Data is displayed within 3 seconds of page load
• Display updates when underlying data changes
• User can only view data they have permission to access

### GRX-DD-004: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 13

---

## Dashboard should support tickets

**User Story:** As a user, I want to support tickets, so that I can quickly understand the current status\.

**Priority:** 🟠 High

**Description:**
ℹ️ Split from compound requirement \(2 of 3\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-005 | Data Display | Verify Dashboard should support tickets | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the ticket view<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| GRX-DD-006 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-005: Verify Dashboard should support tickets
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the ticket view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### GRX-DD-006: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 13

---

## Dashboard should active users

**User Story:** As a user, I want to have active users, so that I can quickly understand the current status\.

**Priority:** 🟠 High

**Description:**
ℹ️ Split from compound requirement \(3 of 3\)

**Acceptance Criteria:**
- [ ] Feature works as described in the requirement
- [ ] Feature handles error cases gracefully
- [ ] Feature is accessible to authorized users only

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-007 | Data Display | Verify Dashboard should active users | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the user view<br>*...(4 total)* | • Feature works as described in the requirement<br>• Feature handles error cases gracefully<br>*...(3 total)* | Must Have | 8-10 min |  |
| GRX-DD-008 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-007: Verify Dashboard should active users
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
• Feature works as described in the requirement
• Feature handles error cases gracefully
• Feature is accessible to authorized users only

### GRX-DD-008: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 13

---

## Export dashboard data to Excel

**User Story:** As a user, I want to export dashboard data to Excel, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Export completes within reasonable time (< 30 seconds for typical data)
- [ ] Exported file is in the correct format
- [ ] Export includes all visible/selected data

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-009 | Data Display | Verify Export dashboard data to Excel | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the record view<br>*...(4 total)* | • Export completes within reasonable time (< 30...<br>• Exported file is in the correct format<br>*...(3 total)* | Should Have | 8-10 min |  |
| GRX-DD-010 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-009: Verify Export dashboard data to Excel
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the record view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Export completes within reasonable time (< 30 seconds for typical data)
• Exported file is in the correct format
• Export includes all visible/selected data

### GRX-DD-010: Verify unauthorized access is blocked
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

**Quality Flags:**
- ⚠️ Potential Duplicate
- ⚠️ Similar To:Req-005

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 14

---

## Have the ability to download dashboard information in\.\.\.

**User Story:** As a users, I want to have the ability to download dashboard information in spreadsheet format, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Export completes within reasonable time (< 30 seconds for typical data)
- [ ] Exported file is in the correct format
- [ ] Export includes all visible/selected data

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DE-019 | Data Entry | Verify Have the ability to download d... | User is logged in as users<br>User has permission to create records<br>*...(3 total)* | Navigate to the record entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Export completes within reasonable time (< 30...<br>• Exported file is in the correct format<br>*...(3 total)* | Should Have | 8-10 min | Test with both minimum and ... |
| GRX-DE-020 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-021 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-022 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DE-023 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| GRX-DE-024 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| GRX-DE-025 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| GRX-DE-026 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-DE-027 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DE-019: Verify Have the ability to download dashboard information in...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as users
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the record entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Export completes within reasonable time (< 30 seconds for typical data)
• Exported file is in the correct format
• Export includes all visible/selected data

**Notes:** Test with both minimum and maximum field lengths

### GRX-DE-020: Verify form submission fails with missing required fields
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

### GRX-DE-021: Verify form validation for invalid data format
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

### GRX-DE-022: Verify unauthorized access is blocked
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

### GRX-DE-023: Verify handling of maximum length input
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

### GRX-DE-024: Verify duplicate entry prevention
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

### GRX-DE-025: Verify handling of special characters in input
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

### GRX-DE-026: Verify minimum required field length
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

### GRX-DE-027: Verify numeric field minimum value
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
- ⚠️ Potential Duplicate
- ⚠️ Similar To:Us-002

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 15

---

## Generate monthly sales reports automatically

**User Story:** As a system, I want to generate monthly sales reports automatically, so that I can analyze and share data externally\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* Needs to run on 1st of month - coordinate with IT

**Acceptance Criteria:**
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-011 | Data Display | Verify Generate monthly sales reports... | User is logged in as system<br>Test data exists in the system<br>*...(3 total)* | Log in as system with appropriate permissions<br>Navigate to the report view<br>*...(4 total)* | • Report includes all required data fields<br>• Report data is accurate (matches source data)<br>*...(3 total)* | Must Have | 8-10 min |  |
| GRX-DD-012 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-011: Verify Generate monthly sales reports automatically
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as system with appropriate permissions
2. Navigate to the report view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Report includes all required data fields
• Report data is accurate (matches source data)
• Report can be generated for custom date ranges

### GRX-DD-012: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 18

---

## Reports must be exportable to PDF and Excel formats\.

**User Story:** As a user, I want to export Reports to PDF and Excel formats, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Priority was not specified; defaulted to Medium

ℹ️ Split from compound requirement \(1 of 3\)

**Acceptance Criteria:**
- [ ] Export completes within reasonable time (< 30 seconds for typical data)
- [ ] Exported file is in the correct format
- [ ] Export includes all visible/selected data
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DE-028 | Data Entry | Verify Reports must be exportable to ... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the report entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Export completes within reasonable time (< 30...<br>• Exported file is in the correct format<br>*...(3 total)* | Should Have | 8-10 min | Priority was auto-assigned;... |
| GRX-DE-029 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-030 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-031 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DE-032 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| GRX-DE-033 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| GRX-DE-034 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| GRX-DE-035 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-DE-036 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DE-028: Verify Reports must be exportable to PDF and Excel formats.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the report entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Export completes within reasonable time (< 30 seconds for typical data)
• Exported file is in the correct format
• Export includes all visible/selected data

**Notes:** Priority was auto-assigned; Test with both minimum and maximum field lengths

### GRX-DE-029: Verify form submission fails with missing required fields
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

### GRX-DE-030: Verify form validation for invalid data format
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

### GRX-DE-031: Verify unauthorized access is blocked
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

### GRX-DE-032: Verify handling of maximum length input
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

### GRX-DE-033: Verify duplicate entry prevention
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

### GRX-DE-034: Verify handling of special characters in input
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

### GRX-DE-035: Verify minimum required field length
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

### GRX-DE-036: Verify numeric field minimum value
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
- ⚠️ Priority was auto-assigned (review recommended)

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 19

---

## Reports should include charts and graphs\.

**User Story:** As a user, I want to access Reports should include charts and graphs, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Priority was not specified; defaulted to Medium

ℹ️ Split from compound requirement \(2 of 3\)

**Acceptance Criteria:**
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-013 | Data Display | Verify Reports should include charts ... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the report view<br>*...(4 total)* | • Report includes all required data fields<br>• Report data is accurate (matches source data)<br>*...(3 total)* | Should Have | 8-10 min | Priority was auto-assigned |
| GRX-DD-014 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-013: Verify Reports should include charts and graphs.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the report view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Report includes all required data fields
• Report data is accurate (matches source data)
• Report can be generated for custom date ranges

**Notes:** Priority was auto-assigned

### GRX-DD-014: Verify unauthorized access is blocked
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

**Quality Flags:**
- ⚠️ Priority was auto-assigned (review recommended)

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 19

---

## Report templates should be customizable\.

**User Story:** As a user, I want to access customiz Report templates, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Priority was not specified; defaulted to Medium

ℹ️ Split from compound requirement \(3 of 3\)

**Acceptance Criteria:**
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-015 | Data Display | Verify Report templates should be cus... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the report view<br>*...(4 total)* | • Report includes all required data fields<br>• Report data is accurate (matches source data)<br>*...(3 total)* | Should Have | 8-10 min | Priority was auto-assigned |
| GRX-DD-016 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-015: Verify Report templates should be customizable.
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the report view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Report includes all required data fields
• Report data is accurate (matches source data)
• Report can be generated for custom date ranges

**Notes:** Priority was auto-assigned

### GRX-DD-016: Verify unauthorized access is blocked
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

**Quality Flags:**
- ⚠️ Priority was auto-assigned (review recommended)

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 19

---

## Ad-hoc reporting capability needed

**User Story:** As a user, I want to access ad-hoc reporting capability needed, so that I can analyze and share data externally\.

**Priority:** 🟡 Medium

**Description:**
ℹ️ Priority was not specified; defaulted to Medium

**Acceptance Criteria:**
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-017 | Data Display | Verify Ad-hoc reporting capability ne... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the report view<br>*...(4 total)* | • Report includes all required data fields<br>• Report data is accurate (matches source data)<br>*...(3 total)* | Should Have | 8-10 min | Priority was auto-assigned |
| GRX-DD-018 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-017: Verify Ad-hoc reporting capability needed
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the report view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Report includes all required data fields
• Report data is accurate (matches source data)
• Report can be generated for custom date ranges

**Notes:** Priority was auto-assigned

### GRX-DD-018: Verify unauthorized access is blocked
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

**Quality Flags:**
- ⚠️ Priority was auto-assigned (review recommended)

**Dependencies:** None

**Source:** Autonomous Requirements Test.xlsx, Row 20

---

## Integrate with Salesforce CRM via REST API

**User Story:** As a system, I want to integrate with Salesforce CRM via REST API, so that I can work seamlessly across systems\.

**Priority:** 🔴 Critical

**Description:**
\*\*Notes:\*\* API key management - see security doc

**Acceptance Criteria:**
- [ ] Integration handles API errors gracefully
- [ ] Data sync completes without data loss
- [ ] Failed sync operations can be retried

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-019 | Data Display | Verify Integrate with Salesforce CRM ... | User is logged in as system<br>Test data exists in the system<br>*...(3 total)* | Log in as system with appropriate permissions<br>Navigate to the record view<br>*...(4 total)* | • Integration handles API errors gracefully<br>• Data sync completes without data loss<br>*...(3 total)* | Must Have | 8-10 min |  |
| GRX-DD-020 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-019: Verify Integrate with Salesforce CRM via REST API
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as system
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as system with appropriate permissions
2. Navigate to the record view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Integration handles API errors gracefully
• Data sync completes without data loss
• Failed sync operations can be retried

### GRX-DD-020: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 24

---

## Slack notifications for critical alerts

**User Story:** As a user, I want to receive Slack notifications for critical alerts, so that I can stay informed about important events\.

**Priority:** 🟢 Low

**Acceptance Criteria:**
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DE-037 | Data Entry | Verify Slack notifications for critic... | User is logged in as user<br>User has permission to create records<br>*...(3 total)* | Navigate to the notification entry screen<br>Enter all required fields with valid data<br>*...(5 total)* | • Notification is sent within expected timeframe<br>• Notification includes all required information<br>*...(3 total)* | Could Have | 8-10 min | Test with both minimum and ... |
| GRX-DE-038 | Data Entry | Verify form submission fails with mis... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Leave required fields empty<br>*...(3 total)* | • Form submission is prevented<br>• Required fields are highlighted<br>*...(4 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-039 | Data Entry | Verify form validation for invalid da... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to the data entry form<br>Enter invalid format (e.g., letters in phone fi...<br>*...(3 total)* | • Validation error is displayed<br>• Invalid field is highlighted<br>*...(3 total)* | Should Have | 5-7 min | Verify error handling and u... |
| GRX-DE-040 | Data Entry | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-DE-041 | Data Entry | Verify handling of maximum length input | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the entry form<br>Enter maximum allowed characters in text fields<br>*...(3 total)* | • System accepts input up to max length<br>• No truncation occurs without warning<br>*...(3 total)* | Could Have | 5-7 min | Edge case - verify robustness |
| GRX-DE-042 | Data Entry | Verify duplicate entry prevention | User is logged in with appropriate role<br>Test environment supports edge case data | Create a record with specific identifying data<br>Attempt to create another record with same iden...<br>*...(3 total)* | • Duplicate is detected<br>• Clear message about existing record<br>*...(3 total)* | Could Have | 5-7 min | May not apply if duplicates... |
| GRX-DE-043 | Data Entry | Verify handling of special characters... | User is logged in with appropriate role<br>Test environment supports edge case data | Navigate to the feature<br>Enter data containing special characters: < > &...<br>*...(4 total)* | • Special characters are properly escaped/encoded<br>• No XSS or injection vulnerabilities<br>*...(3 total)* | Could Have | 8-10 min | Security consideration - pr... |
| GRX-DE-044 | Data Entry | Verify minimum required field length | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter single character in a required text field<br>*...(3 total)* | • If minimum > 1, validation error displayed<br>• If minimum = 1, submission succeeds<br>*...(3 total)* | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-DE-045 | Data Entry | Verify numeric field minimum value | User is logged in with appropriate role<br>Boundary values are documented | Navigate to the form<br>Enter 0 or negative number in numeric field<br>*...(3 total)* | • Validation enforces minimum value<br>• Error message shows allowed range | Could Have | 5-7 min | Document actual min/max for... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DE-037: Verify Slack notifications for critical alerts
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- User has permission to create records
- Required reference data exists (dropdowns, lookups)

**Test Steps:**
1. Navigate to the notification entry screen
2. Enter all required fields with valid data
3. Enter optional fields as needed
4. Click Save/Submit button
5. Verify confirmation message appears

**Expected Results:**
• Notification is sent within expected timeframe
• Notification includes all required information
• User can configure notification preferences

**Notes:** Test with both minimum and maximum field lengths

### GRX-DE-038: Verify form submission fails with missing required fields
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

### GRX-DE-039: Verify form validation for invalid data format
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

### GRX-DE-040: Verify unauthorized access is blocked
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

### GRX-DE-041: Verify handling of maximum length input
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

### GRX-DE-042: Verify duplicate entry prevention
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

### GRX-DE-043: Verify handling of special characters in input
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

### GRX-DE-044: Verify minimum required field length
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

### GRX-DE-045: Verify numeric field minimum value
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

**Source:** Autonomous Requirements Test.xlsx, Row 25

---

## Integrate with quickbooks

**User Story:** As a user, I want to integrate with quickbooks, so that I can work seamlessly across systems\.

**Priority:** 🟢 Low

**Acceptance Criteria:**
- [ ] Integration handles API errors gracefully
- [ ] Data sync completes without data loss
- [ ] Failed sync operations can be retried

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-SCHE-001 | Scheduling | Verify Integrate with quickbooks | User is logged in as user<br>Available time slots exist<br>*...(3 total)* | Navigate to the scheduling/booking feature<br>Select an available date and time slot<br>*...(5 total)* | • Integration handles API errors gracefully<br>• Data sync completes without data loss<br>*...(3 total)* | Could Have | 8-10 min | Consider time zone implicat... |
| GRX-SCHE-002 | Scheduling | Verify booking unavailable slot fails... | User is logged in with appropriate role<br>Test data is prepared as specified | Navigate to scheduling feature<br>Attempt to book an already-taken slot<br>*...(3 total)* | • Error indicates slot is no longer available<br>• Alternative slots are suggested<br>*...(3 total)* | Should Have | 5-7 min | Handles race condition when... |
| GRX-SCHE-003 | Scheduling | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |
| GRX-SCHE-004 | Scheduling | Verify concurrent booking handling | User is logged in with appropriate role<br>Test environment supports edge case data | Open booking page in two browser windows<br>Select same time slot in both<br>*...(3 total)* | • Only one booking succeeds<br>• Other receives 'slot taken' message<br>*...(3 total)* | Could Have | 5-7 min | Race condition test - criti... |
| GRX-SCHE-005 | Scheduling | Verify booking at earliest available ... | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the earliest available slot<br>*...(3 total)* | • Booking is accepted<br>• Confirmation shows correct time | Could Have | 5-7 min | Boundary test - verify limi... |
| GRX-SCHE-006 | Scheduling | Verify booking at latest available time | User is logged in with appropriate role<br>Boundary values are documented | Navigate to scheduling<br>Select the latest available slot in the day<br>*...(3 total)* | • Booking is accepted<br>• No time zone issues at day boundary | Could Have | 5-7 min | Boundary test - verify limi... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-SCHE-001: Verify Integrate with quickbooks
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
• Integration handles API errors gracefully
• Data sync completes without data loss
• Failed sync operations can be retried

**Notes:** Consider time zone implications

### GRX-SCHE-002: Verify booking unavailable slot fails gracefully
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

### GRX-SCHE-003: Verify unauthorized access is blocked
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

### GRX-SCHE-004: Verify concurrent booking handling
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

### GRX-SCHE-005: Verify booking at earliest available time
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

### GRX-SCHE-006: Verify booking at latest available time
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

**Source:** Autonomous Requirements Test.xlsx, Row 26

---

## Email notifications shall be sent when report generation\.\.\.

**User Story:** As a user, I want to receive Email notifications when report generation completes, so that I can analyze and share data externally\.

**Priority:**  2

**Acceptance Criteria:**
- [ ] Report includes all required data fields
- [ ] Report data is accurate (matches source data)
- [ ] Report can be generated for custom date ranges
- [ ] Notification is sent within expected timeframe
- [ ] Notification includes all required information
- [ ] User can configure notification preferences

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| GRX-DD-021 | Data Display | Verify Email notifications shall be s... | User is logged in as user<br>Test data exists in the system<br>*...(3 total)* | Log in as user with appropriate permissions<br>Navigate to the report view<br>*...(4 total)* | • Report includes all required data fields<br>• Report data is accurate (matches source data)<br>*...(3 total)* | Should Have | 8-10 min |  |
| GRX-DD-022 | Data Display | Verify unauthorized access is blocked | User is logged in with appropriate role<br>Test data is prepared as specified | Log out of the system<br>Attempt to access the feature URL directly<br>*...(3 total)* | • User is redirected to login page<br>• No protected data is displayed<br>*...(3 total)* | Should Have | 5-7 min | Security test - verify auth... |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### GRX-DD-021: Verify Email notifications shall be sent when report generation...
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in as user
- Test data exists in the system
- User has view permissions

**Test Steps:**
1. Log in as user with appropriate permissions
2. Navigate to the report view
3. Verify the data displays correctly
4. Check that all expected fields are visible

**Expected Results:**
• Report includes all required data fields
• Report data is accurate (matches source data)
• Report can be generated for custom date ranges

### GRX-DD-022: Verify unauthorized access is blocked
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

**Source:** Autonomous Requirements Test.xlsx, Row 28

---
