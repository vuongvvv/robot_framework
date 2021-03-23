*** Settings ***
Documentation    Tests to verify that processFailedPaymentTransactionCustomer api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/recover_process_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}    client_id_and_secret=robotautomationclientnoscope
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_03222
    [Documentation]    [point][processFailedPaymentTransactionCustomer] Verify that API can return 403  if user does not have 'batch_processor' permission
    [Tags]    Regression    Medium    Smoke
    Post Process Failed Payment Transaction Customer
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    error    insufficient_scope
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    scope    batch_processor