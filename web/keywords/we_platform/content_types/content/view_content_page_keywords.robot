*** Settings ***
Resource    ../../../../../web/resources/locators/we_platform/content_types/content/view_content_page_locators.robot

*** Keywords ***
Click Back Button
    Click Visible Element    ${btn_view_back}
   
Verify Value Of Attributes On Textbox Filed
    [Arguments]   &{attributes_name_filed_and_expect_value}
    FOR  ${attributes_name_filed}    IN   @{attributes_name_filed_and_expect_value.keys()}
        ${expect_value} =    Set Variable     ${attributes_name_filed_and_expect_value}[${attributes_name_filed}]
        ${attributes_name_locator} =    Generate Element From Dynamic Locator    ${txt_create_edit_content_field}   ${attributes_name_filed}
        Wait Until Element Is Visible    ${attributes_name_locator}
        ${value_attribute_name_locator}=    Get Value   ${attributes_name_locator}
        Should Be Equal   ${value_attribute_name_locator}   ${expect_value}
    END

Verify Image Attributes Is Exist
    [Arguments]   @{img_attribute_name}
    FOR  ${img_attribute_name_list}    IN   @{img_attribute_name}
        ${img_attribute_locator} =    Generate Element From Dynamic Locator    ${img_attribute}    ${img_attribute_name_list}
        Wait Until Element Is Visible  ${img_attribute_locator}
    END

Verify Value On Markdown Attribute Is Empty
    [Arguments]   ${markdown_attribute_name}
    ${mdn_attribute_name_locator} =    Generate Element From Dynamic Locator    ${lbl_mardown_attribute}    ${markdown_attribute_name}
    Element Text Should Be   ${mdn_attribute_name_locator}   ${EMPTY}

Verify Value On Markdown Attribute Is Not Empty
    [Arguments]   ${markdown_attribute_name}
    ${mdn_attribute_locator} =    Generate Element From Dynamic Locator    ${lbl_mardown_attribute}    ${markdown_attribute_name}
    Element Text Should Not Be   ${mdn_attribute_locator}   ${EMPTY}