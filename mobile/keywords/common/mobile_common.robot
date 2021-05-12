*** Settings ***
Library    String
Library    AppiumLibrary    run_on_failure=Capture Page Screenshot      timeout=20s
Library    Collections
Library    Process
Library    ../../python_library/common.py

*** Keywords ***
Open Apps
    [Arguments]     ${app}    ${no_reset}=${True}
    ${app_path}=    Get Canonical Path      ${CURDIR}/../../../app-path/${app}
    ${OS}=    Convert To Lowercase        ${OS}
    
    # ${app_path}    Run Keyword If      '${OS}' == 'android'    Set Variable    ${app_path}.apk
    # ...    ELSE    Set Variable        ${app_path}.apps
    
    ${app_path}    Set Variable If    '${OS}' == 'android'    ${app_path}.apk    ${app_path}.app
    Set To Dictionary    ${${DEVICE}}    noReset=${no_reset}    app=${app_path}
    # ${OS}=    Convert To Lowercase        ${OS}
    # Run Keyword If      '${OS}' == 'android'    
    Open Application    ${REMOTE_URL}    &{${DEVICE}}
    Switch To Native Context
    
Close Test Application
    Close All Applications
        
Hide The Keyboard
     Run Keyword If    '${OS}' == 'android'      Hide Keyboard
     Run Keyword If    '${OS}' == 'ios'          Hide Keyboard       &{keyboard}[keyboard_done]

Swipe To Left
     ${width}=    Get Window Width
     ${height}=   Get Window Height
     ${start_x}=      Evaluate    0.67 * ${width}
     ${start_y}=      Evaluate    0.90 * ${height}
     ${offset_x}=     Evaluate    0 * ${width}
     ${offset_y}=     Evaluate    0.30 * ${height}
     Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    1000

Swipe Up
    ${width}=    Get Window Width
    ${height}=   Get Window Height
    ${start_x}=      Evaluate    0.5 * ${width}
    ${start_y}=      Evaluate    0.7 * ${height}
    ${offset_x}=     Evaluate    0.5 * ${width}
    ${offset_y}=     Evaluate    0.3 * ${height}
    Swipe    ${start_x}    ${start_y}    ${offset_x}    ${offset_y}    1000

Swipe Down
    ${width}=    Get Window Width
    ${height}=   Get Window Height
    ${start_x}=      Evaluate    0.5 * ${width}
    ${start_y}=      Evaluate    0.5 * ${height}    
    ${offset_y}=     Evaluate    0.25 * ${height}
    Swipe    ${start_x}    ${start_y}    ${start_x}    ${offset_y}    1000

Select Item On List View
     [Arguments]     ${tbl_list}     ${item}
     @{elements}     Get Webelements    ${tbl_list}
     Click Element    @{elements}[${item}]

Click On Menu
    [Arguments]     ${mnu}
    Click Element       ${mnu}

Click On Back Button
    [Arguments]     ${btn_back}
    Click Element       ${btn_back}

Click On OK Button
    [Arguments]     ${btn_ok}
    Click Element       ${btn_ok}

Alert Popup Is Displayed
    [Arguments]     ${alert}
    Wait Until Element Is Visible       ${alert}        timeout=10s

Click On Allow Button
    [Arguments]     ${btn_allow}
    Wait Until Element Is Visible        ${btn_allow}
    Click Element       ${btn_allow}

Accept Alert Popup
    ${status}   ${value} =      Run Keyword And Ignore Error        Alert Popup Is Displayed    &{alert}[page_alert]
    Run Keyword If      '${status}' == 'PASS'       Click On Allow Button    &{alert}[btn_allow]
    Run Keyword Unless  '${status}' == 'PASS'       Wait Until Page Does Not Contain Element    &{alert}[page_alert]

Switch To Webview Context
    ${default_context}=    Get Current Context
    @{all_context}=    Get Contexts
    ${count_list}=    Get Length    ${all_context}
    ${webview_context}=    Get From List    ${all_context}    ${count_list-1}
    Switch To Context    ${webview_context}

Switch To Native Context
     ${default_context}=    Get Current Context
     @{all_context}=    Get Contexts
     ${count_list}=    Get Length    ${all_context}
     ${native_context}=    Get From List    ${all_context}    0
     Switch To Context    ${native_context}

Page Should Contain Property With Value
    [Arguments]    ${page_content}
    Page Should Contain Text    ${page_content}

Click On Go Button
    [Arguments]     ${btn_go}
    Wait Until Element Is Visible        ${btn_go}
    Click Element       ${btn_go}

Swipe Up To Element
    [Arguments]    ${expected_locator}
    Wait Until Keyword Succeeds    10x    1s    Run Keywords    Swipe Up    AND    Wait Until Page Contains Element    ${expected_locator}      timeout=5s

Swipe Down To Element
     [Arguments]    ${expected_locator}
     Wait Until Keyword Succeeds    10x    3s    Run Keywords    Swipe Down
     ...    AND    Wait Element Is Visible    ${expected_locator}      2s

Scroll Element To Middle
     [Arguments]    ${element}
     Wait Until Keyword Succeeds    10x    1s    Run Keywords    Swipe Down
     ...    AND    Element Is In Middle Of Screen    ${element}

Swipe Left From Element To Element
     [Arguments]    ${from_element}    ${expected_element}    
     Wait Until Element Is Visible    ${from_element}
     ${element_location}=    Get Element Location    ${from_element}
     ${element_location}=    Convert To String    ${element_location}
     @{list_coordinates}=    Get Regexp Matches    ${element_location}    \\d+
     Wait Until Keyword Succeeds    10x    2s    Run Keywords    Swipe    ${list_coordinates}[0]    ${list_coordinates}[1]    0    ${list_coordinates}[1]  
     ...    AND    Wait Until Element Is Visible    ${expected_element}      timeout=1s

Wait Element Is Visible
    [Arguments]    ${locator}    ${timeout}=${None}
    Wait Until Element Is Visible    ${locator}    ${timeout}
        
Element Is In Middle Of Screen
    [Arguments]    ${element}    ${variance}=300
    ${screen_height}=    Get Window Height
    ${element_location}=    Get Element Location    ${element}
    ${element_location}=    Convert To String    ${element_location}
    @{list_coordinates}=    Get Regexp Matches    ${element_location}    \\d+
    ${middle_point}=    Evaluate    ${screen_height} * 0.5
    ${element_position}=    Evaluate    abs(${list_coordinates}[1] - ${middle_point})
    Should Be True    ${element_position} < 300               

Wait Until Element Is Enabled
    [Arguments]    ${element}    ${timeout}=30
    ${interval}=    Evaluate    ${timeout} / 10    
    Wait Until Keyword Succeeds    10x    ${${interval}}s    Element Should Be Enabled    ${element}
    Element Should Be Enabled    ${element}

Click Visible Element
    [Arguments]    ${element}    ${delay}=${None}    ${repeat}=1
    Run Keyword If    '${delay}'!='${None}'    Sleep    ${delay}
    FOR    ${index}    IN RANGE    0    ${repeat}
        Click Element    ${element}
        Sleep    1s    
    END  
    
Click Visible Element2
    [Arguments]    ${element}
        Click Element    ${element}

Tap Element
    [Arguments]    ${element}
    Tap    ${element}

Input Text Into Element
    [Arguments]    ${element}    ${text}
    Input Text    ${element}    ${text}
        
Wait Element Disappear
    [Arguments]    ${element}    ${timeout}=${None}
    Wait Until Page Does Not Contain Element    ${element}    ${timeout}

Capture Screen
    [Arguments]    ${file_name}
    Capture Page Screenshot    ${file_name}.png

Verify By Screenshot
    [Arguments]    ${message}
    Sleep    1s
    Capture Screen    ${message}
    Log    ${message}    WARN    
# Get Elements Text
    # [Arguments]    ${elements_locator}
    # ${return_elements_text_list}=    Create List
    # ${elements_list}=    Wait Until Keyword Succeeds    10s    2s    Get Webelements    ${elements_locator}
    # FOR    ${element}    IN    @{elements_list}
        # ${element_text}=    Get Text    ${element}
        # Append To List    ${return_elements_text_list}    ${element_text}    
    # END
    # [Return]    ${return_elements_text_list}