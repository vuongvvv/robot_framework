*** Settings ***
Library    Collections

*** Variables ***
${number_regex}    ^\\d+$
${base64_regex}    ^[a-zA-Z0-9\+\/]+$

*** Keywords ***
Sort List Items
    [Arguments]    ${list}    ${sort_option}
    Sort List    ${list}   
    Run Keyword If    '${sort_option}' != 'asc'    Reverse List    ${list}

All Items In List Are Number
    [Arguments]    ${list}
    FOR    ${property_value}    IN    @{list}
        Should Match Regexp    ${property_value}    ${number_regex}
    END

All Items In List Are Base64
    [Arguments]    ${list}
    FOR    ${property_value}    IN    @{list}
        Should Match Regexp    ${property_value}    ${base_64_regex}
    END

All Items In List Match Regex
    [Arguments]    ${list}    ${regex}
    FOR    ${property_value}    IN    @{list}
        ${string_value}=    Convert To String    ${property_value}
        Should Match Regexp    ${string_value}    ${regex}
    END

List Should Be String Or Empty
    [Arguments]    ${list}
    ${is_empty_list}=    Run Keyword And Return Status    Should Be Empty    ${list}
    Run Keyword If    ${is_empty_list}
    ...    Should Be Empty    ${list}
    ...    ELSE
    ...    All Items In List Match Regex    ${list}    \\w+

Verify List Is Sorting
    [Arguments]    ${list}    ${sort_order}=desc
    @{copy_list}    Copy List    ${list}
    Sort List Items    ${copy_list}    ${sort_order}    
    Lists Should Be Equal    ${copy_list}    ${list}
    
Verify List Is Not Empty
    [Arguments]    ${list}
    Should Not Be Empty    ${list}
    
Verify List Is Empty
    [Arguments]    ${list}
    Should Be Empty    ${list}
    
Verify List Length
    [Arguments]    ${list}    ${length}
    Length Should Be    ${list}    ${length}    