*** Settings ***
Library    RequestsLibrary
Resource    ../../../utility/common/list_common.robot
Resource    ../../../utility/common/string_common.robot
Resource    ../../../utility/common/number_common.robot

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