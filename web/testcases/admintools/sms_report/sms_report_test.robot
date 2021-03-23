*** Settings ***
Documentation     To verify user permission in AdminTools

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/bi/dashboards_keywords.robot

Test Setup    Run keywords    Generate Gateway Header With Scope and Permission    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}    permission_name=notification.message.get,bi.bi.get
...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test teardown    Run keywords    Delete Created Client And User Group    AND    Clean Environment

*** Test Cases ***
TC_O2O_09172
    [Documentation]    Access to admin tools with permission as "notification.message.get"
    [Tags]    Regression    Smoke    Security    High    ASCO2O-15722
    Login Backoffice   ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    Click the Hamburger Menu
    Navigate On Right Menu Bar    SMS    Report
    Verify Dashboards Page Displays
