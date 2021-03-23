*** Settings ***
Documentation    Tests to verify that the date format on search feature displays correctly as expected.
Resource           ../../../../resources/init.robot
Resource          ../../../../keywords/admintools/main_page/login_keywords.robot
Resource          ../../../../keywords/admintools/main_page/menu_keywords.robot
Resource          ../../../../keywords/admintools/e-stamp/main_page_estamp/search_keywords.robot

Test Setup          Run Keywords    Open Browser With Chrome Headless Mode      ${ADMIN_TOOLS_URL}     AND     Precondition
Test Teardown       Close Browser

*** Keywords ***
Pre Condition
    Login as Estamp Admin
    Go to Estamp Main Page

*** Test Cases ***
TC_O2O_02158
    [Documentation]     Verify create date range format should displays correctly on field
    [Tags]      AdminTools      E-Stamp     Regression      Medium
    Given User Want To Filter Create Date
    When Select The Start Date Range
    And Select The End Date Range
    Then Date Selected Should Be Displayed       ${textfield_create_date}
    And Date Format Should Be Displayed Correctly With DD-MMM-YYYY     ${textfield_create_date}

TC_O2O_02159
    [Documentation]     Verify start date range format should displays correctly on field
    [Tags]      AdminTools      E-Stamp     Regression      Medium
    Given User Want To Filter Start Date
    When Select The Start Date Range
    And Select The End Date Range
    Then Date Selected Should Be Displayed       ${textfield_start_date}
    And Date Format Should Be Displayed Correctly With DD-MMM-YYYY     ${textfield_start_date}

TC_O2O_02160
    [Documentation]     Verify end date range format should displays correctly on field
    [Tags]      AdminTools      E-Stamp     Regression      Medium
    Given User Want To Filter End Date
    When Select The Start Date Range
    And Select The End Date Range
    Then Date Selected Should Be Displayed       ${textfield_end_date}
    And Date Format Should Be Displayed Correctly With DD-MMM-YYYY     ${textfield_end_date}

TC_O2O_02162
    [Documentation]     Verify when filtered with start date then date format should displays correctly on search results
    [Tags]      AdminTools      E-Stamp     Regression      High
    Given User Want To Filter Start Date
    When Select The Start Date Range
    And Select The End Date Range
    Then Date Selected Should Be Displayed       ${textfield_start_date}
    And Date Format Should Be Displayed Correctly With DD-MMM-YYYY     ${textfield_start_date}
    When Click On Search Button
    Then Campaign List Should Contain Start Date And Time Matches Regex

TC_O2O_02163
    [Documentation]     Verify when filtered with end date then date format should displays correctly on search results
    [Tags]      AdminTools      E-Stamp     Regression      High
    Given User Want To Filter End Date
    When Select The Start Date Range
    And Select The End Date Range
    Then Date Selected Should Be Displayed       ${textfield_end_date}
    And Date Format Should Be Displayed Correctly With DD-MMM-YYYY     ${textfield_end_date}
    When Click On Search Button
    Then Campaign List Should Contain End Date And Time Matches Regex