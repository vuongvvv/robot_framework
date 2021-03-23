Resource    ../common/api_common.robot

*** Keywords ***
Get Outlet Payment Infomation
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/outlets/paymentInfo    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
