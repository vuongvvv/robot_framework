*** Settings ***
Documentation     Verify user must have bi permission to access into BI function

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/bi/dashboards_keywords.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot

Test Setup    Run Keywords    Generate Gateway Header With Scope and Permission    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}    permission_name=bi.bi.get
...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test teardown    Run keywords    Delete Created Client And User Group    AND    Clean Environment

*** Test Cases ***
TC_O2O_08897
    [Documentation]    The user have access to BI via AdminTools with a permission
    [Tags]    Regression    Smoke    High    ASCO2O-15722
    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
    Navigate On Left Menu Bar    BI
    Verify Dashboards Page Displays
