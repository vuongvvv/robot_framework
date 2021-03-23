*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${member_resource}    /membership/api/members

*** Keywords ***
Get All Members
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${member_resource}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

#Data Preparation
Get Test Data Merchant Id For Membership
    [Arguments]    ${filter}=${EMPTY}
    Get All Members    ${filter}
    ${TEST_DATA_MERCHANT_ID_FOR_MEMBERSHIP}=    json_common.Get Property Value From Json By Index    .merchantId    0
    Set Test Variable    ${TEST_DATA_MERCHANT_ID_FOR_MEMBERSHIP}
    ${TEST_DATA_CREATED_DATE_MEMBER}=    json_common.Get Property Value By Another Property Value    .merchantId    ${TEST_DATA_MERCHANT_ID_FOR_MEMBERSHIP}    .createdDate
    Set Test Variable    ${TEST_DATA_CREATED_DATE_MEMBER}