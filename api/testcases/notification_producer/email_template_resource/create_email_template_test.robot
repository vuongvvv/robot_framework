*** Settings ***
Documentation    Tests to verify that createEmailTemplate api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/notification_producer/email_template_resource_keywords.robot

# permission_name=notification.template.create
Test Setup    Generate Robot Automation Header    ${NOTIFICATION_PRODUCER_USERNAME}    ${NOTIFICATION_PRODUCER_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${create_email_template_data}    ../../resources/testdata/notification_producer/email_template_resource/create_email_template_data.json
${create_email_template_invalid_data}    ../../resources/testdata/notification_producer/email_template_resource/create_email_template_invalid_channel_data.json

*** Test Cases ***
TC_O2O_09709
    [Documentation]    [API][CreateTemplate] Verify API returns 201 Created when creating new template successfully
    [Tags]    Regression    High    Smoke    UnitTest
    POST Create Email Templates With Dummy Data    ${create_email_template_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain All Property Values Are Integer    .id
    Response Should Contain Property With Value    action    ${json_dummy_data["action"]}
    Response Should Contain Property With Value    title    ${json_dummy_data["title"]}
    Response Should Contain Property With Value    status    ${json_dummy_data["status"]}
    Response Should Contain Property With Value    template    ${json_dummy_data["template"]}
    Response Should Contain Property With Value    html    ${json_dummy_data["html"]}
    Response Should Contain Property With Value    sender    ${json_dummy_data["sender"]}
    Response Should Contain Property With Value    cc    ${json_dummy_data["cc"]}
    Response Should Contain Property With Value    bcc    ${json_dummy_data["bcc"]}
    Response Should Contain Property With Value    registerChannel    ${json_dummy_data["registerChannel"]}

TC_O2O_09713
    [Documentation]    [API][CreateTemplate] Verify API returns 400 Bad Request when registerChannel doesn't exist in system
    [Tags]    Regression    High    Smoke    UnitTest    SanityExclude
    POST Create Email Templates With Dummy Data    ${create_email_template_invalid_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    violations[0].field    registerChannel
    Response Should Contain Property With Value    violations[0].message    Register channel must be in [mobile_merchant_register,web_merchant_register,mobile_admin_register,web_admin_register,import_file,app_true_smart_retail,app_sale_agent,app_trueryde,o2o_admintool]
    Response Should Contain Property With Value    message    error.validation