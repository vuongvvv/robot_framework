*** Settings ***
Documentation    Tests to verify that processFailedPaymentTransactionMerchant api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/recover_process_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}    client_id_and_secret=robotautomationclientnoscope
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05911
    [Documentation]    [point][processFailedPaymentTransactionMerchant] API return 403 when request POST /api/process/failed-payment-transaction-merchant API without batch_processor scope
    [Tags]    Regression    Medium    Smoke
    Post Process Failed Payment Transaction Merchant
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    error    insufficient_scope
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    scope    batch_processor