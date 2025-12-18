# User Stories & UAT Test Cases

**Generated:** 2025-12-17 15:54
**Source:** test_requirements.xlsx

## Summary

### Overview

- **Total User Stories:** 2
- **Total UAT Test Cases:** 3

### By Priority

| Priority | Count |
|----------|-------|
| 🔴 Critical | 0 |
| 🟠 High | 1 |
| 🟡 Medium | 1 |
| 🟢 Low | 0 |

### Test Coverage

| Test Type | Count |
|-----------|-------|
| ✅ Happy Path | 2 |
| ❌ Negative | 1 |
| 🔶 Edge Case | 0 |
| 📏 Boundary | 0 |

### ⚠️ Items Requiring Attention

- **Export dashboard data to Excel**: Priority was auto-assigned (review recommended)

---

## Table of Contents

1. [User login with email and password](#user-login-with-email-and-password)
2. [Export dashboard data to Excel](#export-dashboard-data-to-excel)

---

## User login with email and password

**User Story:** As a user, I want to login with my email and password, so that I can access my account securely\.

**Priority:** 🟠 High

**Description:**
Standard email/password authentication flow\.
*Notes: SSO to be added in phase 2*

**Acceptance Criteria:**
- [ ] Given valid credentials, user is logged in successfully
- [ ] Given invalid credentials, error message is displayed
- [ ] Session expires after 30 minutes of inactivity

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| TEST-AUTH-001 | Authentication | Verify successful login with valid cr... | Valid test user exists<br>User is not logged in | Navigate to login page<br>Enter valid email<br>*...(4 total)* | • User is redirected to dashboard<br>• Welcome message displayed | Must Have | 5 min | Test on Chrome, Firefox, Sa... |
| TEST-AUTH-002 | Authentication | Verify login fails with invalid password | Valid test user exists | Navigate to login page<br>Enter valid email<br>*...(4 total)* | • Error message displayed<br>• User remains on login page | Must Have | 3 min |  |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### TEST-AUTH-001: Verify successful login with valid credentials
*✅ Happy Path*

**Pre-Requisites:**
- Valid test user exists
- User is not logged in

**Test Steps:**
1. Navigate to login page
2. Enter valid email
3. Enter valid password
4. Click Login

**Expected Results:**
• User is redirected to dashboard
• Welcome message displayed

**Notes:** Test on Chrome, Firefox, Safari

### TEST-AUTH-002: Verify login fails with invalid password
*❌ Negative*

**Pre-Requisites:**
- Valid test user exists

**Test Steps:**
1. Navigate to login page
2. Enter valid email
3. Enter wrong password
4. Click Login

**Expected Results:**
• Error message displayed
• User remains on login page

</details>

**Dependencies:** None

**Source:** test_requirements.xlsx, Row 5

---

## Export dashboard data to Excel

**User Story:** As an analyst, I want to export dashboard data to Excel, so that I can perform offline analysis\.

**Priority:** 🟡 Medium

**Acceptance Criteria:**
- [ ] Export button visible on dashboard
- [ ] Excel file downloads within 10 seconds
- [ ] All visible data included in export

**UAT Test Cases:**

| Test ID | Category | Title | Pre-Requisites | Test Steps | Expected Results | MoSCoW | Est. Time | Notes |
|---------|----------|-------|----------------|------------|------------------|--------|-----------|-------|
| TEST-RPT-001 | Reporting | Verify Excel export downloads success... | User is logged in<br>Dashboard has data | Navigate to dashboard<br>Click Export button<br>*...(3 total)* | • Excel file downloads<br>• File opens correctly<br>*...(3 total)* | Should Have | 5 min | Check file size is reasonable |

<details>
<summary><strong>Detailed Test Steps (click to expand)</strong></summary>

### TEST-RPT-001: Verify Excel export downloads successfully
*✅ Happy Path*

**Pre-Requisites:**
- User is logged in
- Dashboard has data

**Test Steps:**
1. Navigate to dashboard
2. Click Export button
3. Wait for download

**Expected Results:**
• Excel file downloads
• File opens correctly
• Data matches dashboard

**Notes:** Check file size is reasonable

</details>

**Quality Flags:**
- ⚠️ Priority was auto-assigned (review recommended)

**Dependencies:** None

**Source:** test_requirements.xlsx, Row 12

---
