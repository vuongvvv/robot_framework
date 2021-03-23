*** Settings ***
Library    Collections

# https://rpaframework.org/libdoc/RPA_Browser_Playwright.html
*** Keywords ***
Open Browser With Option
    [Arguments]    ${url}    ${browser}=chromium    ${headless_mode}=${False}    ${width}=1920    ${height}=1080
    New Browser    browser=${browser}    headless=${headless_mode}
    New Context    viewport={'width': ${width}, 'height': ${height}}
    New Page    ${url}
    
Clean Environment
    Close Browser    browser=ALL
    
Click Visible Element
    [Arguments]    ${element}
    Click    selector=${element}
    
Input Text Into Visible Element
    [Arguments]    ${element}    ${text}
    Type Text    ${element}    ${text}

Hover On Element
    [Arguments]    ${element}
    Hover    ${element}
    
Get Element By Index
    [Arguments]    ${elements}    ${index}=1
    ${elements_list}    Get Elements    ${elements}
    [Return]    ${elements_list}[${${index}-1}]
    
Get Element Text
    [Arguments]    ${element}
    ${return_text}    Get Text    ${element}
    [Return]    ${return_text}
            
Get Elements Text
    [Arguments]    ${elements_locator}
    ${return_elements_text_list}=    Create List
    ${elements_list}=    Get Elements    ${elements_locator}
    FOR    ${element}    IN    @{elements_list}
        ${element_text}=    Get Text    ${element}
        Append To List    ${return_elements_text_list}    ${element_text}    
    END
    [Return]    ${return_elements_text_list}

Mouse Over
    [Arguments]    ${element}
    Hover    ${element}
            
Select Dropwdown List By Label
    [Arguments]    ${dropdown_element}    ${label}    
    Select Options By    selector=${dropdown_element}    attribute=label    ${label}

Select Visible Checkbox
    [Arguments]    ${checkbox_element}    
    Check Checkbox    ${checkbox_element}

Unselect Visible Checkbox
    [Arguments]    ${checkbox_element}    
    Uncheck Checkbox    ${checkbox_element}
        
Clean And Input Text Into Element
    [Arguments]    ${element}    ${text}    
    Fill Text    ${element}    ${text}
    
Get Selected Dropdown List
    [Arguments]    ${element}    ${select_by}=label
    ${return_label}    Get Selected Options    ${element}    ${select_by}
    [Return]    ${return_label}

# https://rpaframework.org/libdoc/RPA_Browser_Playwright.html#Assertions
Verify Selected Dropdown List
    [Arguments]    ${element}    ${expected_value}    ${option_attribute}=label    ${assertion_operator}=equal
    Get Selected Options    ${element}    ${option_attribute}    ${assertion_operator}    ${expected_value}
    
Verify Element State
    [Arguments]    ${element}    ${expected_state}=visible    ${timeout}=10s
    Wait For Elements State    selector=${element}    state=${expected_state}    timeout=${timeout}
    
Verify Element Text
    [Arguments]    ${element}    ${expected_text}    ${assertion_operator}=equal
    Get Text    ${element}    ${assertion_operator}    ${expected_text}

Verify Textfield Value
    [Arguments]    ${element}    ${expected_text}    ${assertion_operator}=equal
    Get Textfield Value    ${element}    ${assertion_operator}    ${expected_text}

# https://rpaframework.org/libdoc/RPA_Browser_Playwright.html#Get%20Checkbox%20State
Verify Checkbox State
    [Arguments]    ${element}    ${expected_state}=${False}    ${assertion_operator}=equal
    Get Checkbox State    ${element}    ${assertion_operator}    ${expected_state}
    
Go To Url
    [Arguments]    ${url}
    New Page    ${url}
    
Wait Until Page Finish Loading
    Wait Until Network Is Idle