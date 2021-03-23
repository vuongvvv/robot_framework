*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/content_types/content_type_page_locators.robot
Library    String

*** Keywords ***
Get Content Type Id Page From Header
    Wait Until Element Is Enabled    ${spn_content_type_information}    5
    ${content_type_information} =    Get Text    ${spn_content_type_information}
    ${content_type_id} =    Fetch From Right    ${content_type_information}    ${SPACE}
    Set Test Variable    ${CONTENT_TYPE_ID}    ${content_type_id}