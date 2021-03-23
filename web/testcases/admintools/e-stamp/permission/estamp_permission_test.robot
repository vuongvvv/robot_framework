*** Settings ***
Documentation      Tests to verify that the permission of E-Stamp admin correctly as expected.
Resource           ../../../../resources/init.robot
Resource          ../../../../keywords/admintools/main_page/login_keywords.robot
Resource          ../../../../keywords/admintools/main_page/menu_keywords.robot

Test Setup     Open Browser With Chrome Headless Mode      ${ADMIN_TOOLS_URL}
Test Teardown  Close browser

*** Test Cases ***
TC_O2O_02041
    [Documentation]     Verify E-stamp admin tools when user is admin role and user has been given "estamp.estamp.actAsAdmin" permission
    [Tags]      AdminTools      E-Stamp     Regression      High
    Given Login as Estamp Admin
    When Click the Hamburger Menu
    Then Estamp Menu should be displayed