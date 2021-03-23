*** Settings ***
Library    String
Library    Collections

*** Keywords ***
Generate Element From Dynamic Locator
    [Arguments]    ${dynamic_locator}    @{list_value}
    ${index}=    Set Variable    ${0}
    FOR    ${value}    IN    @{list_value}
        ${string_value}    Convert To String    ${value}
        ${dynamic_locator}=    Replace String    ${dynamic_locator}    _DYNAMIC_${index}    ${string_value}
        ${index}=    Set Variable    ${index+1}
    END
    [Return]    ${dynamic_locator}