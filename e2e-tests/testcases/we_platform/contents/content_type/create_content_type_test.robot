*** Settings ***
Documentation    Verify user can create content-Types with permission and without permission
Resource    ../../../../../web/resources/init.robot
Resource    ../../../../../web/keywords/we_platform/common/common_keywords.robot
Resource    ../../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
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
${project_name}     Robot Automation
${project_description}    Robot Automation Description
${project_code}    ASC56TY
${alias_name}        content-types
${content_type_name}   content-type-test
${description}         test-create-content-type
${alert_msg_create}  A new Content type is created
${alert_msg_delete}  A Content type is deleted.

*** Test Cases ***
TC_O2O_14213  
    [Documentation]   Verify create Content Type success by Attributes not require
    [Tags]    Regression    High    E2E
    Click Create New Content Type Button
    Input Content Type Values    name=${content_type_name}   description=${description}   alias=${alias_name}
    Create Attribute Of Content Type   TEST-Content-1   String
    Create Attribute Of Content Type   TEST-Content-2   Decimal
    Create Attribute Of Content Type   TEST-Content-3   File
    Create Attribute Of Content Type   TEST-Content-4   Markdown
    Create Attribute Of Content Type   TEST-Content-5   Public File
    Create Attribute Of Content Type   TEST-Content-6   Enum    Test
    Create Attribute Of Content Type   TEST-Content-7   Date Time
    Create Attribute Of Content Type   TEST-Content-8   Point Location
    Click Save Button
    Verify Text Alert Message On Popup      ${alert_msg_create}
    Delete Content Types By Name And Alias  ${content_type_name}  ${alias_name}
    Verify Text Alert Message On Popup      ${alert_msg_delete}
    
TC_O2O_14214
    [Documentation]  Verify create Content Type success by Attributes require
    [Tags]    Regression    High    E2E
    Click Create New Content Type Button
    Input Content Type Values    name=${content_type_name}   description=${description}   alias=${alias_name}
    Create Attribute Of Content Type   TEST-Content-1   String        required_flag=Y
    Create Attribute Of Content Type   TEST-Content-2   Decimal        required_flag=Y
    Create Attribute Of Content Type   TEST-Content-3   File           required_flag=Y
    Create Attribute Of Content Type   TEST-Content-4   Markdown       required_flag=Y
    Create Attribute Of Content Type   TEST-Content-5   Public File    required_flag=Y
    Create Attribute Of Content Type   TEST-Content-6   Enum    Test   required_flag=Y
    Create Attribute Of Content Type   TEST-Content-7   Date Time      required_flag=Y
    Create Attribute Of Content Type   TEST-Content-8   Point Location  required_flag=Y
    Click Save Button
    Verify Text Alert Message On Popup      ${alert_msg_create}
    Delete Content Types By Name And Alias  ${content_type_name}  ${alias_name}
    Verify Text Alert Message On Popup      ${alert_msg_delete}
    
TC_O2O_14215
    [Documentation]   Verify create content type with add all applications and add all permission
    [Tags]    Regression    High    E2E
    Click Create New Content Type Button
    Input Content Type Values    name=${content_type_name}   description=${description}   alias=${alias_name}
    Create Attribute Of Content Type   TEST-Content-1   String
    Click Add Permission Button
    Input Permissions Values   name=All_Permissions   description=Test_All_Permissions
    Select Add Or All Button   All
    Select Authorize Permissions Checkbox   Create  Delete
    Select Read Permissions Checkbox by Attributes Name     All
    Select Update Permissions Checkbox by Attributes Name   All
    Click Save Add Permissions Button
    Click Save Button
    Verify Text Alert Message On Popup     ${alert_msg_create}
    Delete Content Types By Name And Alias   ${content_type_name}  ${alias_name}
    Verify Text Alert Message On Popup       ${alert_msg_delete}