*** Variables ***
${create_activation_code_api}    /rpp-merchant/api/outlets/
${activate_activation_code_api}    /rpp-merchant/api/terminals/activate
${get_activation_code_api}    /rpp-merchant/api/activationcodes
${get_terminal_api}    /rpp-merchant/api/terminals/activatecode/
${activate_terminal_api}    /rpp-merchant/api/terminals/activate/edc
${random_activation_code_length}    12

*** Keywords ***
Put Create Activation Code For Outlet
    [Arguments]    ${outlet_id}    ${json_data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_activation_code_api}${outlet_id}/activationcodes    data=${json_data}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Activation Code ID
    @{activation_codes}    Get Value From Json    ${resp.json()}    $..activationCodes
    Set Test Variable    ${ACTIVATION_CODE}    @{activation_codes}[0]

Get Activation Code Information
    [Arguments]    ${properties_and_values}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${get_activation_code_api}?${properties_and_values}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Put Activate Activation Code And Create Terminal For Outlet
    [Arguments]    ${json_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${activate_activation_code_api}    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Terminal External ID
    ${EXTERNAL_TERMINAL_ID}=    Get Value From Json    ${resp.json()}    $..terminalExternalId
    Set Test Variable    ${EXTERNAL_TERMINAL_ID}

Get Terminal Information
    [Arguments]    ${properties_and_values}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${get_terminal_api}${properties_and_values}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Activate Terminal
    [Arguments]    ${json_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${activate_terminal_api}    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Random Activation Code
    ${random_activation_code} =    Get Random Strings    ${random_activation_code_length}    [LETTERS][NUMBERS][UPPER]
    Set Test Variable    ${RANDOM_ACTIVATION_CODE}    ${random_activation_code}

