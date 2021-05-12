*** Settings ***

*** Keywords ***
Should Be Number
    [Arguments]    ${item}
    ${number_item}    Convert To Number    ${item}
    Should Be Equal    ${item}    ${number_item}