*** Settings ***
Documentation    Verify Bifrost - Proxies page
Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/we_platform/common/common_keywords.robot
Resource    ../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../keywords/we_platform/bifrost/proxies_keywords.robot
Resource    ../../../resources/testdata/${ENV}/bifrost/proxies_testdata.robot

Test Setup  Run keywords  Open Browser With Option    ${WE_PLATFROM_URL}
...   AND   Login To We Platform Website     ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}
...   AND   Navigate To Main Menu And Sub Main Menu    Menu    Bifrost Proxy
Test Teardown    Run Keywords    Delete Proxy By Name    ${TEST_NAME}
...    AND    Clean Environment

*** Variables ***
${not_exist_project_id}   not_exist_project_id
@{proxies_table_column_headers}    Project Id    Group Name    Name    Description    Owner    Path    Method    Target Method    Target
@{proxies}    subject    action    resource
@{empty_proxies}    ${EMPTY}    ${EMPTY}    ${EMPTY}
@{javascript_proxies}    (function(proxyReq) { return proxyReq.getClientId(); })    (function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })    (function(proxyReq) { return proxyReq.getProjectId(); })
@{five_proxies}    (function(proxyReq) { return proxyReq.getClientId(); })    action    (function(proxyReq) { return proxyReq.getQueryParameters().get('category'); })    subject    action    resource    subject    action    resource    subject    action    resource    (function(proxyReq) { return proxyReq.getClientId(); })    (function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })    (function(proxyReq) { return proxyReq.getProjectId(); })    

*** Test Cases ***
TC_O2O_19971
    [Documentation]   Create proxy with project Id which doesn't exist 
    [Tags]    Regression    Smoke    High
    Verify Proxies Table Column Headers    ${proxies_table_column_headers}    
    Navigate To Create A New Proxy Page
    Create A New Proxy    ${not_exist_project_id}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${False}    ${EMPTY}
    Switch To Non Angular JS Site
    Verify Alert Message    Invalid Project Id
    Switch To Angular JS Site
    [Teardown]    Clean Environment
    
TC_O2O_19970
    [Documentation]   Create proxy without project Id 
    [Tags]    Regression    Smoke    High
    Navigate To Create A New Proxy Page
    Create A New Proxy    ${EMPTY}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${False}    ${EMPTY}
    
TC_O2O_19972
    [Documentation]   Create proxy with valid project Id 
    [Tags]    Regression    Smoke    High
    Navigate To Create A New Proxy Page
    Create A New Proxy    ${WE_PLATFORM_PROJECT_ID}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${False}    ${EMPTY}
    
TC_O2O_22253
    [Documentation]   [Create or edit a proxy] Verify "Create or edit a proxy" form
    [Tags]    Regression    Smoke    High
    # Fill in Subject, Action, Resource with Empty values and Save
    Navigate To Create A New Proxy Page
    Fill Proxy Information    ${EMPTY}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${True}    Project Id    @{empty_proxies}
    Verify Save Button Is Disabled
    Verify Delete Button Is Hidden
    Uncheck Enable Authorization Checkbox
    Verify Delete Button Is Shown
    
    # Fill in Subject, Action, Resource with Fixed values
    Navigate To Main Menu And Sub Main Menu    Menu    Bifrost Proxy
    Navigate To Create A New Proxy Page
    Fill Proxy Information    ${EMPTY}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${True}    Project Id    @{proxies}
    Verify Save Button Is Enabled
    
    # Fill in Subject, Action, Resource with JavaScript values
    Navigate To Main Menu And Sub Main Menu    Menu    Bifrost Proxy
    Navigate To Create A New Proxy Page
    Fill Proxy Information    ${EMPTY}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${True}    Project Id    @{javascript_proxies}
    Verify Save Button Is Enabled
    
    # Add 5 policies
    Navigate To Main Menu And Sub Main Menu    Menu    Bifrost Proxy
    Navigate To Create A New Proxy Page
    Fill Proxy Information    ${EMPTY}    ${TEST_NAME}    ${TEST_NAME}    ${TEST_NAME}    owner    /path    ${True}    GET    GET    target    ${True}    ${True}    (function(proxyReq) { return proxyReq.getProjectId(); })    @{five_proxies}
    Verify Save Button Is Enabled
    Verify Add Policy Button Is Disabled
    Click Save Policy Button