*** Settings ***
Resource    ../../../../web/keywords/common/list_common.robot
Resource    ../../../../web/keywords/common/locator_common.robot
Resource    ../../../../web/resources/locators/we_platform/projects/projects_page_locators.robot
Resource    ../../../../web/resources/locators/we_platform/content/content_types_locators.robot

*** Keywords ***
Access The Content Type By Name
    [Arguments]    ${content_type_name}
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    ${content_type_name_locator} =    Format String    ${lnkContentTypeName}    ${content_type_name}
    Wait Until Element Is Visible    ${content_type_name_locator}
    Click Element    ${content_type_name_locator}