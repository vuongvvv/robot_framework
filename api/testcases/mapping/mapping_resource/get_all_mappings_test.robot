*** Settings ***
Documentation    Tests to verify that getAllMappings api works correctly

Resource    ../../../resources/init.robot 
Resource    ../../../keywords/mapping/mapping_resource_keywords.robot

# permission_name=mapping.mapping.actAsAdmin
Test Setup    Generate Robot Automation Header    ${MAPPING_USER}    ${MAPPING_USER_PASSWORD}    
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_12202
    [Documentation]     [Membership][getAllMappings] User with "mapping.mapping.actAsAdmin" permisison requests API will return 200 with correct body
    [Tags]      Regression     High    Smoke
    Get All Mappings
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    .app
    Response Should Contain All Property Values Are String    .client
    Response Should Contain All Property Values Are Json Or Null    .mapping
    Response Should Contain All Property Values Are Boolean    .markAsDelete