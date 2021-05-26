*** Settings ***
Library    RequestsLibrary
Resource    ../../../utility/common/list_common.robot
Resource    ../../../utility/common/string_common.robot
Resource    ../../../utility/common/number_common.robot
Resource    ../../../utility/common/json_common.robot

*** Variables ***

*** Keywords ***
Response Correct Code
    [Arguments]    ${resp_code}
    Should Be Equal As Strings    ${RESP.status_code}    ${resp_code}
    
Verify Response Length
    [Arguments]    ${length}
    ${list}    Convert To List    ${RESP.json()}
    Verify List Length    ${list}    ${length}
    
Verify Response Field Is String
    [Arguments]    ${field_index}
    ${list}    Convert To List    ${RESP.json()}
    ${length}    Get Length    ${list}
    FOR    ${element}    IN    @{list}
        Should Be String    ${element}[${field_index}]
    END
    
Verify Response Field Is Number
    [Arguments]    ${field_index}
    ${list}    Convert To List    ${RESP.json()}
    ${length}    Get Length    ${list}
    FOR    ${element}    IN    @{list}
        Should Be Number    ${element}[${field_index}]
    END

Response Property Should Be
    [Arguments]    ${property}    ${value}    ${index}=0
    ${property_value}    Get Property Value From Json By Index    ${property}    ${index}
    Should Be Equal    ${property_value}    ${value}
    
Fetch Property From Response
    [Arguments]    ${property}    ${return_name}
    ${property_value}    Get Property Value From Json By Index    ${property}
    Set Test Variable    ${${return_name}}    ${property_value}
    
Fetch All Property Values
    [Arguments]    ${property}    ${return_name}
    ${property_value}    Get All Property Value    ${property}
    Set Test Variable    ${${return_name}}    ${property_value}