*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/members/members_page_locators.robot

*** Keywords ***
Add Member To Projects
    [Arguments]  ${member_username}    ${member_role}
    Input Text   ${txt_user}   ${member_username}
    Select From List By Label  ${dropdown_role}   ${member_role}
    Click Element  ${btn_add}
