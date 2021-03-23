*** Settings ***
Resource      ../../resources/init.robot
Resource      ../common/api_common.robot
Resource      ../common/json_common.robot
Resource      ../common/file_common.robot

*** Keywords ***
Get MOT Status
    [Arguments]  ${params_uri}=${EMPTY}
    Create RPP Session
    ${RESP}=    Get Request    ${RPP_SESSION}    /crm-ms-edc/v1/terminals/activated   params=${params_uri}
    Set Test Variable    ${RESP}

