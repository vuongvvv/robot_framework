*** Settings ***
Library    String

*** Keywords ***
Should Be Boolean
    [Arguments]    ${value}
    ${converted_value}=    Convert To Boolean    ${value}
    Should Be Equal    ${value}    ${converted_value}
    
Should Be Null
    [Arguments]    ${value}
    Should Be Equal    ${value}    ${None}
    
Should Be String Or Null
    [Arguments]    ${value}
    ${is_string}=    Run Keyword And Return Status    Should Be String    ${value}
    Run Keyword If    ${is_string}
    ...    Should Be String    ${value}
    ...    ELSE
    ...    Should Be Null    ${value}

Should Be Number Or Null
    [Arguments]    ${value}
    ${is_number}=    Run Keyword And Return Status    Should Be Equal As Numbers    ${value}    ${${value}}
    Run Keyword If    ${is_number}
    ...    Should Be Equal As Numbers    ${value}    ${${value}}
    ...    ELSE
    ...    Should Be Null    ${value}

Should Match Regex Or Null
    [Arguments]    ${value}    ${regex}
    ${is_null}=    Run Keyword And Return Status    Should Be Null    ${value}
    Run Keyword If    ${is_null}
    ...    Should Be Null    ${value}
    ...    ELSE
    ...    Should Match Regexp    ${value}    ${regex}

Dates Should Be Equal
    [Arguments]    ${first_date}    ${second_date}
    ${converted_first_date}=    Convert Date    ${first_date}    epoch
    ${converted_second_date}=    Convert Date    ${second_date}    epoch
    Should Be Equal    ${converted_first_date}    ${converted_second_date}
    
Date Should Be Greater Or Equal
    [Arguments]    ${first_date}    ${second_date}
    ${converted_first_date}=    Convert Date    ${first_date}    epoch
    ${converted_second_date}=    Convert Date    ${second_date}    epoch
    Should Be True    ${converted_first_date} >= ${converted_second_date}