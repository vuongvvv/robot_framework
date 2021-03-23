*** Settings ***
Documentation    Tests to verify that the reprocess can work on "error.payment-transaction-{env}.merchantPointConsumer-{env}" as expected.
Resource    ../../../../resources/init.robot
Resource    ../../../../keywords/point/dlq_handling_keywords.robot
Test Setup    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${failed_payment_transaction_merchant_api}    /point/api/process/failed-payment-transaction-merchant

*** Test Cases ***
TC_O2O_03290
    [Documentation]    Verify that API can return 403 if user does not have 'batch_processor' permission
    [Tags]    regression    High    DLQHandling
    [Setup]    Generate Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Reprocess Messages On Error Topic Of Kafka    ${failed_payment_transaction_merchant_api}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    scope    batch_processor
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    error    insufficient_scope