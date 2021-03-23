*** Keywords ***
#Trigger cronjob to update True Money Status
Get True Money Check Approve
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP} =    Get Request    ${RPP_SESSION}    /crm-ms-mtransaction-api/v1/tmn/checkapprove    params=${params_uri}    headers=&{RPP_HEADER}
    Set Test Variable    ${RESP}