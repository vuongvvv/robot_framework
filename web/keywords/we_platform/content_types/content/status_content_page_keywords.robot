*** Settings ***
Resource    ../../../../../web/resources/locators/we_platform/content_types/content/status_content_page_locators.robot

*** Keywords ***
Verify Id Exist On Content Table Id Column
    [Arguments]    ${content_id}
    Wait Until Page Contains    ${content_id}
    ${column_content_id} =    Get WebElements    ${cln_content_id}
    ${is_found_id_status} =    Set Variable    ${FALSE}
    FOR    ${element}    IN    @{column_content_id}
        ${id} =    Get Text    ${element}
        ${is_found_id_status} =    Set Variable If    '${id}'=='${content_id}'    ${TRUE}
        Run Keyword If    '${id}'=='${content_id}'    Exit For Loop
    END
    Should Be Equal    ${is_found_id_status}    ${TRUE}

Verify Page Content Types Name
    [Arguments]  ${content_types_name}
    ${lbl_content_type_name_locator} =    Generate Element From Dynamic Locator      ${lbl_content_type_name}   ${content_types_name}
    Wait Until Page Contains Element   ${lbl_content_type_name_locator}

Get First Row On Content Table Id Column
    Wait Until Element Is Visible    ${lbl_first_row_content_id}
    ${TEST_VARIABLE_CONTENT_ID} =    Get Text    ${lbl_first_row_content_id}
    Set Test Variable  ${TEST_VARIABLE_CONTENT_ID}

Press Button By Content ID 
    [Arguments]   ${content_id}   ${button_wording}
    ${cln_type_button_locator}=     Generate Element From Dynamic Locator   ${cln_type_button}   ${content_id}  ${button_wording}
    Wait Until Element Is Visible    ${cln_type_button_locator}
    Click Element  ${cln_type_button_locator}  
    Run Keyword If  '${button_wording}'=='Delete'    Wait Until Element Is Visible    ${btn_cofirm_delete}
    Run Keyword If  '${button_wording}'=='Delete'   Click Element    ${btn_cofirm_delete}
    
Verify Id Not Exist On Content Table Id Column
    Wait Until Element Is Not Visible    ${lbl_first_row_content_id}

Verify Content Id Does Not Exist
    [Arguments]  ${content_id}
    ${lbl_content_id_locator}=     Generate Element From Dynamic Locator   ${lbl_content_id}   ${content_id}
    Wait Until Element Is Not Visible    ${lbl_content_id_locator}