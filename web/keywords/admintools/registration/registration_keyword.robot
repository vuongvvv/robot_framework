*** Settings ***
Resource    ../../../resources/locators/admintools/registration/registration_locators.robot

*** Keywords ***
Enter Mobile Login
    [Arguments]    ${mobile}
    Input Text Into Visible Element    ${txt_mobile_login}    ${mobile}

Enter User Login
    [Arguments]    ${login}
    Input Text Into Visible Element    ${txt_user_login}    ${login}
    
Enter Email
    [Arguments]    ${email}
    Input Text Into Visible Element    ${txt_email}    ${email}
    
Enter New Password
    [Arguments]    ${new_password}
    Input Text Into Visible Element    ${txt_password}    ${new_password}

Enter Confirm Password
    [Arguments]    ${confirm_password}
    Input Text Into Visible Element    ${txt_confirm_password}    ${confirm_password}

Click Register Button
    Click Visible Element    ${btn_register}

Register Account
    [Arguments]    ${user_login}    ${mobile_login}    ${email}    ${password}
    Enter User Login    ${user_login}
    Enter Mobile Login    ${mobile_login}    
    Enter Email    ${email}
    Enter New Password    ${password}
    Enter Confirm Password    ${password}
    Click Register Button
            
Verify Mobile Login Error Message
    [Arguments]    ${expected_error_message}
    Check Element Text    ${lbl_mobile_login_error}    ${expected_error_message}

Verify Registration Account Error Displays
    Wait Element Is Visible    ${mdl_registration_error}