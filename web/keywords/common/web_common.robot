*** Settings ***
Library    DateTime
Library    Collections
Library    String
Resource    ../../resources/locators/admintools/common/common_locators.robot
Resource    ../../../api/keywords/common/validation_common.robot
Resource    locator_common.robot

*** Variables ***
@{chrome_arguments}    --disable-infobars    --headless    --disable-gpu     --no-sandbox    --disable-dev-shm-usage

*** Keywords ***
Open Browser With Option
    [Arguments]    ${url}    ${browser}=Chrome    ${headless_mode}=${False}    ${width}=1920    ${hight}=1080   ${JS_Site}=${True}
    Run Keyword If    ${headless_mode} == ${True}    Open Browser With Chrome Headless Mode    ${url}
    ...    ELSE IF    ${headless_mode} == ${False} and ${JS_Site} == ${False}    Switch To Non Angular JS Site
    Navigate To Url    ${browser}    ${url}
    Maximize Browser Window

Navigate To Url
    [Arguments]    ${browser}    ${url}
    Open Browser    ${url}    ${browser}

Go To Url
    [Arguments]    ${url}
    [Documentation]    Navigates the current browser window to the provided url
    Go To    ${url}

Open Browser To Admin Tools
    Open Browser    ${ADMIN_TOOLS_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Set Chrome Options
    [Documentation]    Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${option}    IN    @{chrome_arguments}
        Call Method    ${options}    add_argument    ${option}
    END
    [Return]    ${options}

Open Browser With Chrome Headless Mode
    [Arguments]      ${page_url}
    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${page_url}

Clean Environment
    Close All Browsers

Navigate On Right Menu Bar
    [Arguments]    ${menu}    ${sub_menu}
    ${menu_locator}=    Generate Element From Dynamic Locator    ${mnu_right_menu_bar}    ${menu}
    Click Element    ${menu_locator}
    ${sub_menu_locator}=    Generate Element From Dynamic Locator    ${mnu_sub_menu}    ${menu}    ${sub_menu}
    Click Element    ${sub_menu_locator}

Click the Hamburger Menu
    Click element    ${hamberger_menu}

Go To Page Number
    [Arguments]    ${page_number}
    ${locator}=    Generate Element From Dynamic Locator    ${lnk_page_number}    ${page_number}
    Click Element    ${locator}

Text Value Of Locator Should Be
    [Arguments]    ${text_locator}    ${expected_value}    @{text_field}
    ${locator}=    Generate Element From Dynamic Locator    ${text_locator}    @{text_field}
    Element Text Should Be    ${locator}    ${expected_value}

Date Value Of Locator Greater Than
    [Arguments]    ${date_locator}    ${expected_date_value}=today    @{text_field}
    ${expected_date_time}=    Run Keyword If    '${expected_date_value}' == 'today'    Get Current Date    result_format=%Y-%m-%d    ELSE    Set Variable    ${expected_date_value}
    ${locator}=    Generate Element From Dynamic Locator    ${date_locator}    @{text_field}
    ${element_date}=    Get Text    ${locator}
    Date Should Be Greater Or Equal    ${expected_date_time}    ${element_date}

Get Value From URL By Regexp
    [Arguments]    ${regular_expression}
    ${url} =   Get Location
    ${value} =    Get Regexp Matches	${url}    ${regular_expression}
    [Return]    ${value}

Wait Until Element Is Disappear
    [Arguments]    ${element}    ${time_out}=None
    Wait Until Element Is Not Visible    ${element}    ${time_out}

Wait Until Element Contain Text
    [Arguments]    ${element}    ${expected_text}    ${time_out}=None
    Wait Until Element Contains    ${element}    ${expected_text}    ${time_out}

Switch To New Window
    [Arguments]    ${window_title}
    Wait Until Keyword Succeeds    5    1    Switch Window    ${window_title}

Click Visible Element
    [Arguments]    ${element}
    Click Element    ${element}

Click Elements
    [Arguments]    ${elements_locator}
    ${elements_list}=    Get WebElements    ${elements_locator}
    Get Length    ${elements_list}
    FOR    ${element}    IN    @{elements_list}
        # Scroll Element Into View    ${element}
        Run Keyword And Ignore Error    Click Visible Element    ${element}
    END
    
Update Text
    [Arguments]    ${element}    ${text}
    Clear Element Text    ${element}
    Input Text    ${element}    ${text}

Input Text Into Visible Element
    [Arguments]    ${element}    ${text}
    Input Text    ${element}    ${text}

Clean And Input Text Into Element
    [Arguments]    ${element}    ${text}    
    Input Text    ${element}    ${text}    clear=${True}
    
Check Element Text
    [Arguments]    ${element}    ${expected_text}
    Element Text Should Be    ${element}    ${expected_text}

Send Keys To Element
    [Arguments]    ${element}=${None}    @{keys}
    Press Keys    ${element}    ${keys}

Wait Until Element Is Interactable
    [Arguments]    ${element}    ${loop}=5    ${sleep_time}=0.5s
    FOR    ${index}    IN RANGE    0    ${loop}
        Sleep    ${sleep_time}
        ${is_element_interactable}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        Exit For Loop If    ${is_element_interactable}==${True}
    END

Wait List Contains Label
    [Arguments]    ${list_element}    ${label}
    Wait Until Element Contains    ${list_element}    ${label}

Wait Until Page Contains Text
    [Arguments]    ${text}    ${time_out}=None
    Wait Until Page Contains    ${text}    ${time_out}

Verify Element Contain Text
    [Arguments]    ${element}    ${expected_text}    
    Element Should Contain    ${element}    ${expected_text}

Verify Element Property Value
    [Arguments]    ${element}    ${property}    ${expected_value}
    Element Attribute Value Should Be    ${element}    ${property}    ${expected_value}
            
Verify Element Is Visible
    [Arguments]    ${element}    ${assertion}=${False}
    Run Keyword If    ${assertion}==${False}    Element Should Be Visible    ${element}
    ...    ELSE    Run Keyword And Continue On Failure    Element Should Be Visible    ${element}

Verify Checkbox Is Selected
    [Arguments]    ${element}    
    Scroll Element Into View    ${element}
    Checkbox Should Be Selected    ${element}

Verify Checkbox Is Not Selected
    [Arguments]    ${element}    
    Scroll Element Into View    ${element}
    Checkbox Should Not Be Selected    ${element}
    
Verify Element Is Not Visible
    [Arguments]    ${element}    
    Wait Until Element Is Disappear    ${element}
    Element Should Not Be Visible    ${element}
    
Verify Element Is Disabled
    [Arguments]    ${element}    
    Element Should Be Disabled    ${element}
    
Verify Element Is Enabled
    [Arguments]    ${element}    
    Element Should Be Enabled    ${element}

Verify Dropdown Items
    [Arguments]    ${element}    ${expected_dropdown_items}    
    ${actual_dropdown_items}    Get List Items    ${element}
    Lists Should Be Equal    ${actual_dropdown_items}    ${expected_dropdown_items}

Verify Element Is Hidden
    [Arguments]    ${element}
    Element Should Not Be Visible    ${element}

Is Element Visible
    [Arguments]    ${element}
    ${is_visible}    Run Keyword And Return Status    Verify Element Is Visible    ${element}
    [Return]    ${is_visible}

# StaleElementReferenceException: Message: stale element reference: element is not attached to the page document
Verify Get WebElements
    [Arguments]    ${elements_locator}
    ${elements_list}=    Get WebElements    ${elements_locator}
    FOR    ${element}    IN    @{elements_list}
        # Try to get text element, if success, then "StaleElementReferenceException" exception will not happen with the element
        Get Text    ${element}
    END
    [Return]    ${elements_list}
    
Get Elements Text
    [Arguments]    ${elements_locator}
    Wait Until Element Is Enabled    ${elements_locator}
    ${return_elements_text_list}=    Create List
    ${elements_list}=    Wait Until Keyword Succeeds    10s    2s    Verify Get WebElements    ${elements_locator}
    FOR    ${element}    IN    @{elements_list}
        ${element_text}=    Get Text    ${element}
        Append To List    ${return_elements_text_list}    ${element_text}    
    END
    [Return]    ${return_elements_text_list}

Get Element Property
    [Arguments]    ${element}    ${property}    
    ${return_property_value}    Get Element Attribute    ${element}    ${property}     
    [Return]    ${return_property_value}

Get Element Text
    [Arguments]    ${element}    
    ${return_element_text}    Get Text    ${element}
    [Return]    ${return_element_text}
               
Select Visible Checkbox
    [Arguments]    ${checkbox_element}    
    Scroll Element Into View    ${checkbox_element}
    Select Checkbox    ${checkbox_element}
    
Unselect Visible Checkbox
    [Arguments]    ${checkbox_element}    
    Scroll Element Into View    ${checkbox_element}
    Unselect Checkbox    ${checkbox_element}
    
Select Dropwdown List By Label
    [Arguments]    ${dropdown_element}    ${label}    
    Select From List By Label    ${dropdown_element}    ${label}

Select Dropwdown List By Value
    [Arguments]    ${dropdown_element}    ${value}    
    Select From List By Value    ${dropdown_element}    ${value}
        
Switch To Non Angular JS Site
    Set Ignore Implicit Angular Wait    ${True}

Switch To Angular JS Site
    Set Ignore Implicit Angular Wait    ${False}        

Switch Browser By Index
    [Arguments]    ${browser_index}
    Switch Browser    ${browser_index}
    
Refresh Page
    Reload Page
    
Wait Element Is Visible
    [Arguments]    ${element}    ${time_out}=None
    Wait Until Element Is Visible    ${element}    ${time_out}
    
Handle Alert Popup
    [Documentation]    validation=assert/verify
    [Arguments]    ${action}=ACCEPT    ${timeout}=${None}    ${validation}=assert
    Run Keyword If    '${validation}'=='assert'    Handle Alert    ${action}    ${timeout}
    ...    ELSE    Run Keyword And Ignore Error    Handle Alert    ${action}    ${timeout}

Hover On Element
    [Arguments]    ${element}
    Mouse Over    ${element}