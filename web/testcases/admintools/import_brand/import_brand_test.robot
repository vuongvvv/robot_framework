*** Settings ***
Documentation     Verify user must have bi permission to access into BI function

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot
Resource    ../../../keywords/admintools/import_brand/import_brand_outlet_terminal_keywords.robot

# permission: mbs.rpp-edc.history.get
Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
Test teardown    Clean Environment

*** Test Cases ***
TC_O2O_06603
    [Documentation]    Search transactions on Import brand page.
    [Tags]    Regression    E2E    High    o2o-admintools
    Navigate On Left Menu Bar     Import brand
    Fetch Status On Page
    Search Reports    status=SUCCESS
    Verify Search Feature Works Correctly
    Clear Search
    Verify Clear Search Feature Works Correctly