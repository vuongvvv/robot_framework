*** Settings ***
Resource    ../../resources/locators/line_access/login/login_page_locators.robot
Resource    ../../../api/resources/testdata/uaa/line_signin/line_signin.robot
Resource    ../../../api/keywords/common/line_access_common.robot

*** Keywords ***
Login Line Access
    [Arguments]    ${line_email}    ${line_password}
    Switch To Non Angular JS Site
    Input Text Into Visible Element    ${txt_email_address}    ${line_email}
    Input Text Into Visible Element    ${txt_password}    ${line_password}
    Click Visible Element    ${btn_signin}
    Run Keyword And Ignore Error     Click Visible Element    ${btn_allow}

Fetch Authorization Code From Url
    Wait Until Page Contains Element    ${lbl_cannot_process}
    ${url}=    Get Location
    ${return_authorization_code}=    Fetch From Right    ${url}    code=
    ${return_authorization_code}=    Fetch From Left    ${return_authorization_code}    &
    Set Test Variable    ${LINE_AUTHORIZATION_CODE}    ${return_authorization_code}

Get Line Authorization Token From Line Access
    [Arguments]    ${line_email}    ${line_password}
    Open Browser With Option    ${line_access_url}
    Login Line Access    ${line_email}    ${line_password}
    Fetch Authorization Code From Url
    Clean Environment

Get Line Token Id
    [Arguments]    ${line_email}    ${line_password}
    Get Line Authorization Token From Line Access    ${line_email}    ${line_password}
    Post Verify Id Token    ${LINE_AUTHORIZATION_CODE}    ${valid_line_channel_id}
    Fetch Line Id Token