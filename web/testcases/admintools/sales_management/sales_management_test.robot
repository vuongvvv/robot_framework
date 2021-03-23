*** Settings ***
Documentation     Verify user must have bi permission to access into BI function

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot
Resource    ../../../keywords/admintools/sales_management/dashboard_keywords.robot

Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
Test teardown    Clean Environment

*** Test Cases ***
TC_O2O_06600
    [Documentation]    Search transactions on Sale management page.
    [Tags]    Regression    Smoke    High    o2o-admintools
    Navigate On Left Menu Bar     Sales Management
    Fetch Total Items On Page
    Search Sales History    SUCCESS
    Verify Search Feature Works Correctly
    Clear Search
    Verify Clear Search Feature Works Correctly