*** Settings ***
Documentation    Tests to verify that API rpp-config work correctly
Resource        ../../../resources/init.robot
Resource        ../../../keywords/rpp_config/CRUD_config_keywords.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot

# on ALPHA, no need the authorisation
Suite Setup      Create RPP Gateway Header
Suite Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_10320
    [Documentation]   Should return all configurations
    [Tags]    Regression
    Get All RPP Config
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With String Value    data.[0].id     
    Response Should Contain Property With String Value    data.[0].content_type       
    Response Should Contain Property With String Value    data.[0].content_id 
    Response Should Contain Property With String Value    data.[0].key
    Response Should Contain Property With String Value    data.[0].configs

TC_O2O_10321
    [Documentation]   Should return event configuration
    [Tags]    Regression
    Create Param To Get    saleapp    event    event
    Get RPP Config Detail    ${params}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With String Value    data.[0].id     
    Response Should Contain Property With Value    data.[0].content_type    saleapp
    Response Should Contain Property With Value    data.[0].content_id    event
    Response Should Contain Property With Value    data.[0].key    event
    Response Should Contain Property With String Value    data.[0].configs

TC_O2O_10324 
    [Documentation]    Should return correct config that just created
    [Tags]    Regression    Smoke
    Post Add RPP Config    { "content_type": "test-content-type-1", "content_id": "test-content-id-1", "key": "test-single-key-1", "configs": { "key-1": "value-1" } }
    Get RPP Config Id  
    Create Params To Get     test-content-type-1    test-content-id-1    test-single-key-1    value-1
    Get RPP Config Detail    ${params}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With String Value    data.[0].id
    Response Should Contain Property With Value    data.[0].content_type    test-content-type-1
    Response Should Contain Property With Value    data.[0].content_id    test-content-id-1
    Response Should Contain Property With Value    data.[0].key    test-single-key-1
    Response Should Contain Property With Value    data.[0].configs.key-1    value-1
    Delete RPP Config   ${RPP_CONFIG_ID}