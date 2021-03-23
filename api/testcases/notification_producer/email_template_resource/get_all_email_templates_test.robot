*** Settings ***
Documentation    Tests to verify that getAllEmailTemplates api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/email_template_resource_keywords.robot

# permission_name=notification.template.read
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}    
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_09706
    [Documentation]    [API][GetAllTemplate] Verify API returns 200 OK when getting all Email templates
    [Tags]    Regression    High    Smoke
    GET All Email Templates    page=0&size=10&sort=id%2Casc
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Integer    .id
    Response Should Contain All Property Values Are String    .action
    Response Should Contain All Property Values Are String    .title
    Response Should Contain All Property Values Are String    .status
    Response Should Contain All Property Values Are String    .template
    Response Should Contain All Property Values Are Boolean    .html
    Response Should Contain All Property Values Are String    .sender
    Response Should Contain All Property Values Are String Or Null    .cc
    Response Should Contain All Property Values Are String Or Null    .bcc
    Response Should Contain All Property Values Are String Or Null    .registerChannel