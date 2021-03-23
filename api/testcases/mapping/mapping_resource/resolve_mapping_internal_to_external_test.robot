*** Settings ***
Documentation    Tests to verify that resolveMappingInternalToExternal api works correctly

Resource    ../../resources/init.robot
Resource    ../../keywords/mapping/mapping_resource_keywords.robot
Test Setup    Generate Gateway Header    ${MAPPING_USER}    ${MAPPING_USER_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${app}    POS5
${client}    BBQ5
${merchant_id}    1100001
${outlet_id}    00006
${terminal_id}    69000006

*** Test Cases ***
TC_O2O_02154
    [Documentation]     [API] [Mapping] [resolveMappingInternalToExternal] Request with Mapping  Json format invalid returns 400
    [Tags]      Regression     Medium
    Post Resolve Mapping Internal To External    { "app": "${app}", "client": "${client}" "mapping": { "merchantId":["${merchant_id}"], "outletId":["${outlet_id}"], "terminalId":["${terminal_id}"] } }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Bad Request
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With String Value    detail
    Response Should Contain Property With Value    path    /api/reverse-mapping
    Response Should Contain Property With Value    message    error.http.400