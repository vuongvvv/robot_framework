*** Settings ***
Documentation    Verify create or edit content-type page invalid Filed and can't create content-type
Resource    ../../../../../web/resources/init.robot
Resource    ../../../../../web/keywords/we_platform/common/common_keywords.robot
Resource    ../../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/projects/welcome_to_project_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/create_or_edit_content_type_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/content_types_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/projects/create_or_edit_a_project_page_keywords.robot

Test Setup  Run keywords  Open Browser With Option    ${WE_PLATFROM_URL}
...   AND   Login To We Platform Website     ${WE_PLATFORM_CONTENT_USER}     ${WE_PLATFORM_CONTENT_PASSWORD}
...   AND   Navigate To Main Menu And Sub Main Menu    Menu    Project
...   AND   Select To Create Project
...   AND   Generate Project Name    ${project_name}
...   AND   Create Project    ${RANDOM_PROJECT_NAME}    ${project_description}    ${project_code}   
...   AND   Browsing Project Information    ${RANDOM_PROJECT_NAME}
...   AND   Navigate To Left Menu     Contents   ContentTypes
Test Teardown    Run Keywords    Navigate To Main Menu And Sub Main Menu    Menu    Project
...    AND    Delete Project    ${RANDOM_PROJECT_NAME}
...    AND    Clean Environment

*** Variables ***
${project_name}   WeShop Tesco
${project_description}    WeShop Tesco Description
${project_code}    ASC56TY
${dup_alias_name}    content-type-duplicate
${content_type_name}   content-type-test
${list_character}   A!@#$%^&*()+}{:”?><,./‘;[]=/?.๐”฿\
${alert_msg_error_duplicated}   Field `alias` is duplicated.

*** Test Cases ***
TC_O2O_14212
    [Documentation]   Verify Invalid Login To We Platform Website and check content-Type page
    [Tags]    Smoke    High
    Click Create New Content Type Button
    Verify Save Button Is Disabled
    Verify Default Content Type Fields Textbox Turns Red With Invalid Values      Name
    Verify Default Content Type Fields Textbox Turns Red With Invalid Values      Alias
    Verify Content Type Fields Textbox Turns Red With Invalid Values   Alias   ${list_character}
    Input Content Type Values    name=${content_type_name}     alias=${dup_alias_name}
    Click Add Attribute Button
    Click Save Button
    Verify Default Content Type Fields Textbox Turns Red With Invalid Values    Attributes
    Verify Text Alert Message On Popup    not blank
    Click Delete Attribute
    Create Attribute Of Content Type   TEST-Content-1   String
    Click Save Button