*** Settings ***
Documentation    UPDATE_CMS_CONFIG

Resource    ../../../api/resources/init.robot
Resource    ../../../api/resources/testdata/alpha/merchant/merchant_data.robot
Resource    ../../../api/keywords/cms/content_type_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    client_id_and_secret=robotautomationclientcms    
Test Teardown     Delete All Sessions

*** Variables ***

*** Test Cases ***
UPDATE_CMS_CONFIG
    [Documentation]    UPDATE_CMS_CONFIG
    [Template]    Update Cms Config
    brand-callverification    brandContactPhone    pattern    ^66-\\d{8,10}$
    
*** Keywords ***
Update Cms Config
    [Arguments]    ${content_type_name}    ${source_property}    ${update_property}    ${update_value}
    Get All Content Types    ${TEST_DATA_CMS_PROJECT_ID}
    Fetch Property By Another Property Value    .name    ${content_type_name}    .id    CONTENT_TYPE_ID
    Get Content Type    ${TEST_DATA_CMS_PROJECT_ID}    ${CONTENT_TYPE_ID}
    ${new_body}    Update Json By Another Property    attributes    attributes..attribute    ${source_property}    ${update_property}    ${update_value}
    Put Update Content Type    ${TEST_DATA_CMS_PROJECT_ID}    ${new_body}