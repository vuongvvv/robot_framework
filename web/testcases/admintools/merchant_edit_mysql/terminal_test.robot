*** Settings ***
Documentation     Verify user must have bi permission to access into BI function

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/common/common_keywords.robot
Resource    ../../../keywords/admintools/merchant_edit_mysql/terminal_keywords.robot

Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
Test teardown    Clean Environment

*** Test Cases ***
TC_O2O_13224
    [Documentation]    [Admintool] Verify Terminal List page by verify Search button and fill in data correctly Terminal ID search box
    [Tags]    Regression    Smoke    High    o2o-admintools
    Navigate On Left Menu Bar     Merchant Edit (MySQL)    Terminal
    Fetch Devices List On Page
    Search Terminal    SELLER_APP
    Verify Search Feature Works Correctly
    Clear Search
    Verify Clear Search Feature Works Correctly