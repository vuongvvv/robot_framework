*** Settings ***
Documentation    Tests to verify that API rpp-config work correctly
Resource        ../../../resources/init.robot
Resource        ../../../keywords/rpp_config/CRUD_config_keywords.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot

# on ALPHA, no need the authorisation
Test Setup      Create RPP Gateway Header
Test Teardown    Run Keywords    Delete RPP Config    ${RPP_CONFIG_ID}    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_10326 
    [Documentation]   Should be updated existing config to have new value
    [Tags]    Regression    Smoke
    Post Add RPP Config    { "content_type": "test-content-type-1", "content_id": "test-content-id-1", "key": "test-single-key-1", "configs": { "key-1": "value-1" } }
    Get RPP Config Id
    Update RPP Config    ${RPP_CONFIG_ID}    { "content_type": "test-content-type-1", "content_id": "test-content-id-1", "key": "test-single-key-1", "configs":{ "key_1":"value-1.1" } }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With String Value    data.id
    Response Should Contain Property With Value    data.content_type    test-content-type-1
    Response Should Contain Property With Value    data.content_id    test-content-id-1
    Response Should Contain Property With Value    data.key    test-single-key-1
    Response Should Contain Property With Value    data.configs.key_1    value-1.1   