*** Settings ***
Resource    ../../../resources/locators/admintools/campaign/merchant_group_locators.robot

**** Variables ****
${merchant_group_name}    --- Test automate_

*** Keywords ***
Random Merchant Group Name
    ${numbers}=    Evaluate    random.randint(1, 999)    random
    ${random_merchant_group_name}=    Catenate    SEPARATOR=${numbers}    ${merchant_group_name}    _Merchant group
    Set Test Variable    ${MERCHANT_GROUP_NAME}    ${random_merchant_group_name}
    [Return]    ${random_merchant_group_name}

Create New Random Merchant Group
    Click Visible Element    ${btn_create_merchant_group}
    ${merchant_group_name}=    Random Merchant Group Name
    Send Keys To Element    ${txt_create_merchant_group}    ${merchant_group_name}
    Click Visible Element    ${dbl_first_merchant}
    Click Visible Element    ${dbl_second_merchant}
    Click Visible Element    ${dbl_third_merchant}
    Send Keys To Element    ${txt_merchant_group}    ${merchant_group_name}
    Click Visible Element    ${btn_move_to_right}
    Click Visible Element    ${btn_save_merchant_group}

Search Merchant Group
    [Arguments]    ${merchant_group}
    Input Text Into Visible Element    ${txt_search_merchant_group}    ${merchant_group}
    Wait Until Element Is Disappear    ${spn_loading_pane}
    Click Visible Element    ${btn_search_merchant_group}

Verify Merchant Group Is Created Successfully
    [Arguments]    ${merchant_group}
    ${merchant_group_element}=    Generate Element From Dynamic Locator    ${tbl_information_cell}    ${merchant_group}
    Wait Element Is Visible    ${merchant_group_element}

# Update Merchant Groups to verify merchant is able to edit properly
Update Merchant Groups
    Click Visible Element    ${btn_edit_merchant_group}
    Click Visible Element    ${dbl_first_merchant_right}
    Click Visible Element    ${btn_move_all_to_left}
    Click Visible Element    ${dbl_fifth_merchant}
    Click Visible Element    ${dbl_sixth_merchant}
    Click Visible Element    ${dbl_seventh_merchant}
    Click Visible Element    ${btn_move_to_right}
    Click Visible Element    ${btn_save_merchant_group}
