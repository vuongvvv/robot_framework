*** Settings ***
Documentation     Tests to verify that DLQ Message Page is working correctly or not
Resource          ../../../../../api/resources/init.robot
Resource          ../../../../resources/init.robot
Resource          ../../../../keywords/admintools/dlq_message/dlq_message_keywords.robot
Resource          ../../../../keywords/admintools/main_page/login_keywords.robot
Resource          ../../../../keywords/admintools/main_page/menu_keywords.robot
Test Setup          Run Keywords     Generate Gateway Header With Scope and Permission    ${ADMIN_TOOLS_DLQ_MESSAGE_USER}
                    ...   ${ADMIN_TOOLS_DLQ_MESSAGE_PASSWORD}    permission_name=merchantSubscriber.msg.actAsAdmin
                    ...   AND    Open Browser With Chrome Headless Mode    ${ADMIN_TOOLS_URL}
Test Teardown       Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions    AND    Clean Environment

*** Variables ***
@{expected_dlq_topic_name_for_add_env}    .error-merchantSub-activation-notification.sentSms
                                      ...    .error-merchantSub-activation-notification.sentEmail
                                      ...    .error-merchantSub-outlet-trueyou.trueYouOutletProcessConsumer
                                      ...    .error-merchantSub-merchant-trueyou.trueYouMerchantProcessConsumer
                                      ...    .error-tmn-outlet-inprogress-dlq
                                      ...    .dlq-error-tmn-merchant-approved
                                      ...    .error-merchantSub-merchant-weShop.weShopMerchantConsumer
                                      ...    .error-merchantSub-outlet-weShop.weShopOutletConsumer

*** Test Cases ***
TC_O2O_09151
    [Documentation]    [UI] - Verify user can see all DLQ topic of Merchant Subscribe on 1st dropdownlist
                       ...   on the "Merchant Subscriber DLQ messages" page
    [Tags]    Regression    High    Smoke
    Login Backoffice    ${ADMIN_TOOLS_DLQ_MESSAGE_USER}    ${ADMIN_TOOLS_DLQ_MESSAGE_PASSWORD}
    Go to DLQ Messages Main Page
    Verify Correction DLQ Topic On Merchant Subscriber Page    ${expected_dlq_topic_name_for_add_env}