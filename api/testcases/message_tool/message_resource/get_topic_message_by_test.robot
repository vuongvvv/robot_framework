*** Settings ***
Documentation    Tests to verify that getTopicMessageBy API works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/message_tool/message_resource_keywords.robot
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_08020
    [Documentation]    Verify that user can get message from all DLQ topics and Error topics of Point Microservices with "point.msg.dlq-l" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=point.msg.dlq-l
    [Template]    Get Message From Kafka Topic With Correct Permission
    ${ENV}.dlq-point-calculation
    ${ENV}.dlq-payment-transaction.merchantPointConsumer
    ${ENV}.dlq-payment-transaction.customerPointConsumer
    ${ENV}.dlq-issue-point
    ${ENV}.error-point-calculation.pointCalculationConsumer
    ${ENV}.error-payment-transaction.merchantPointConsumer
    ${ENV}.error-payment-transaction.customerPointConsumer
    ${ENV}.error-issue-point.pointIssuerConsumer

TC_O2O_08021
    [Documentation]    Verify that user cannot get message from normal topics of Point Microservices with "point.msg.dlq-l" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=point.msg.dlq-l
    [Template]    Get Message From Kafka Topic With Incorrect Permission
    ${ENV}.point-calculation
    ${ENV}.issue-point
    ${ENV}.payment-transaction

TC_O2O_03297
    [Documentation]    Verify that user can get message from all topics of Point Microservices with "point.msg.actAsAdmin" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=point.msg.actAsAdmin
    [Template]    Get Message From Kafka Topic With Correct Permission
    ${ENV}.point-calculation
    ${ENV}.issue-point
    ${ENV}.payment-transaction
    ${ENV}.error-point-calculation.pointCalculationConsumer
    ${ENV}.error-payment-transaction.merchantPointConsumer
    ${ENV}.error-payment-transaction.customerPointConsumer
    ${ENV}.error-issue-point.pointIssuerConsumer
    ${ENV}.dlq-point-calculation
    ${ENV}.dlq-payment-transaction.merchantPointConsumer
    ${ENV}.dlq-payment-transaction.customerPointConsumer
    ${ENV}.dlq-issue-point

TC_O2O_08024
    [Documentation]    Verify that user can get messages from all topics of merchantPublisher microservices with "merchantPublisher.msg.actAsAdmin" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=merchantPublisher.msg.actAsAdmin
    [Template]    Get Message From Kafka Topic With Correct Permission
    ${ENV}.merchantPub-merchant
    ${ENV}.merchantPub-outlet
    ${ENV}.merchantPub-terminal
    ${ENV}.merchantPub-activation

TC_O2O_08027
    [Documentation]    Verify that user cannot get messages from normal topics of merchantPublisher microservices with "merchantPublisher.msg.dlq-l " permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=merchantPublisher.msg.dlq-l
    [Template]    Get Message From Kafka Topic With Incorrect Permission
    ${ENV}.merchantPub-merchant
    ${ENV}.merchantPub-outlet
    ${ENV}.merchantPub-terminal
    ${ENV}.merchantPub-activation

TC_O2O_08029
    [Documentation]    Verify that user can get messages from all topics of merchantSubscriber microservice with "merchantSubscriber.msg.actAsAdmin" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=merchantSubscriber.msg.actAsAdmin
    [Template]    Get Message From Kafka Topic With Correct Permission
    ${ENV}.merchantSub-outlet.approve
    ${ENV}.merchantSub-activation-notification
    ${ENV}.merchantSub-merchant
    ${ENV}.merchantSub-outlet-trueyou
    ${ENV}.merchantSub-merchant-trueyou
    ${ENV}.tmn-merchant-approved
    ${ENV}.tmn-outlet-inprogress
    ${ENV}.error-merchantSub-activation.updateActivationStatusInProgress
    ${ENV}.error-merchantSub-activation.updateStatusWaitingActivate
    ${ENV}.merchantSub-outlet-trueyou.retry
    ${ENV}.merchantSub-merchant-trueyou.retry
    ${ENV}.error-tmn-outlet-inprogress
    ${ENV}.error-tmn-merchant-approved
    ${ENV}.error-merchantSub-activation-notification.sentSms
    ${ENV}.error-merchantSub-activation-notification.sentEmail
    ${ENV}.error-merchantSub-outlet-trueyou.trueYouOutletProcessConsumer
    ${ENV}.error-merchantSub-merchant-trueyou.trueYouMerchantProcessConsumer
    ${ENV}.error-tmn-outlet-inprogress-dlq
    ${ENV}.dlq-error-tmn-merchant-approved

TC_O2O_08031
    [Documentation]    Verify that user can get messages from all DLQ topics and Error topics of merchantSubscriber microservices with "merchantSubscriber.msg.dlq-l" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=merchantSubscriber.msg.dlq-l
    [Template]    Get Message From Kafka Topic With Correct Permission
    ${ENV}.error-merchantSub-activation-notification.sentSms
    ${ENV}.error-merchantSub-activation-notification.sentEmail
    ${ENV}.error-merchantSub-outlet-trueyou.trueYouOutletProcessConsumer
    ${ENV}.error-merchantSub-merchant-trueyou.trueYouMerchantProcessConsumer
    ${ENV}.error-tmn-outlet-inprogress-dlq
    ${ENV}.dlq-error-tmn-merchant-approved
    ${ENV}.error-merchantSub-activation.updateActivationStatusInProgress
    ${ENV}.error-merchantSub-activation.updateStatusWaitingActivate
    ${ENV}.merchantSub-outlet-trueyou.retry
    ${ENV}.merchantSub-merchant-trueyou.retry
    ${ENV}.error-tmn-outlet-inprogress
    ${ENV}.error-tmn-merchant-approved

TC_O2O_08032
    [Documentation]    Verify that user cannot get messages from normal topics of merchantSubscriber microservices with "merchantSubscriber.msg.dlq-l" permission
    [Tags]    Regression    High    Smoke    UnitTest    Sanity
    [Setup]    Generate Gateway Header With Scope and Permission    ${MESSAGE_TOOL_USERNAME}    ${MESSAGE_TOOL_PASSWORD}    permission_name=merchantSubscriber.msg.dlq-l
    [Template]    Get Message From Kafka Topic With Incorrect Permission
    ${ENV}.merchantSub-outlet.approve
    ${ENV}.merchantSub-activation-notification
    ${ENV}.merchantSub-merchant
    ${ENV}.merchantSub-outlet-trueyou
    ${ENV}.merchantSub-merchant-trueyou
    ${ENV}.tmn-merchant-approved
    ${ENV}.tmn-outlet-inprogress