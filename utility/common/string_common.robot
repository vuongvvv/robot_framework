*** Settings ***
Library    DateTime
Library    String

*** Keywords ***
Random Unique String By Epoch Datetime
    ${return_string}=    DateTime.Get Current Date    time_zone=local    increment=0    result_format=%Y%m%d%H%M%S%f    exclude_millis=False
    ${return_string}=    Convert To String    ${return_string}
    [Return]    ${return_string}

Get Random Strings
    [Arguments]    ${length}    ${format}
    ${random_string} =    Generate Random String    ${length}    ${format}
    [Return]    ${random_string}

Format Mobile Number
    [Arguments]    ${mobile_number}    ${replaced_prefix}=0    ${new_prefix}=66
    ${return_mobile_number}=    Replace String    ${mobile_number}    ${replaced_prefix}    ${new_prefix}    1
    [Return]    ${return_mobile_number}
    
Is String Contain
    [Arguments]    ${container_string}    ${item_string}
    ${is_contain}    Run Keyword And Return Status    Should Contain    ${container_string}    ${item_string}
    [Return]    ${is_contain}
    
Generate Random Number In Range
    [Arguments]    ${range_min}    ${range_max}
    ${return_value}    Evaluate    random.sample(range(${range_min}, ${range_max}), 1)    random
    [Return]    ${return_value}[0]
    
Replace String From Right
    [Arguments]    ${string}    ${search_for}    ${replace_with}
    ${rest}    ${last}    Split String From Right    ${string}    ${search_for}    1
    ${return_string}    Set Variable    ${rest}${replace_with}
    [Return]    ${return_string}        