*** Settings ***
Resource      ../common/api_common.robot

*** Variables ***
${uaa_api_users_admin}    /uaa/api/users/admin

*** Keywords ***
Get User Admin Information
    [Arguments]         &{authorization}
    ${RESP}=            Get Request       ${GATEWAY_SESSION}      ${uaa_api_users_admin}    headers=&{authorization}
    Set Test Variable   ${RESP}
