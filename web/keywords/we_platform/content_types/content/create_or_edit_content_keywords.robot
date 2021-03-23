*** Settings ***
Library    OperatingSystem
Resource    ../../../../../web/resources/locators/we_platform/content_types/content/create_or_edit_content_locators.robot

*** Variable ***
${attributes_img_path}       ${CURDIR}/attributes_img.png
${attributes_markdown_path}  ${CURDIR}/content.txt

*** Keywords ***
Input Content Values
    [Arguments]   &{text_create_edit_field_and_values_for_edit}
    FOR  ${create_edit_field}    IN   @{text_create_edit_field_and_values_for_edit.keys()}
        ${value} =    Set Variable     ${text_create_edit_field_and_values_for_edit}[${create_edit_field}]
        ${txt_create_edit_content_type_locator} =    Generate Element From Dynamic Locator    ${txt_create_edit_content_field}    ${create_edit_field}
        Wait Until Element Is Visible    ${txt_create_edit_content_type_locator}
        Input Text   ${txt_create_edit_content_type_locator}   ${value}
    END

Upload Attribute Image
    [Arguments]   ${attribute_name}  ${attribute_img_path}
    ${btn_browse_img_locator} =    Generate Element From Dynamic Locator    ${btn_browse_img}    ${attribute_name}
    Choose File     ${btn_browse_img_locator}     ${attribute_img_path}

Input Content On Markdown 
    [Arguments]     ${attribute_name}   ${content_txt_path}
    ${file_contents}    Get File    ${content_txt_path}
    ${txt_markdown_locator} =    Generate Element From Dynamic Locator    ${txt_markdown}    ${attribute_name}
    Press Keys    ${txt_markdown_locator}   ${file_contents}