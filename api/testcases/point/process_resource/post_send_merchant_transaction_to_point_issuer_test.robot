*** Settings ***
Documentation    Tests to verify that sendMerchantTransactionToPointIssuer api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/point/process_resource_keywords.robot

# scope: batch_processor
Test Setup    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_05588
    [Documentation]    [Point][sendMerchantTransactionToPointIssuer] Request with batch_processor scope return 200
    [Tags]    Regression    Medium    Smoke
    Post Send Merchant Transaction To Point Issuer
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_05589
    [Documentation]    [Point][sendMerchantTransactionToPointIssuer] Request without batch_processor scope return 403
    [Tags]    Regression    Medium
    [Setup]    Generate Robot Automation Header    ${POINT_USERNAME}    ${POINT_PASSWORD}   client_id_and_secret=robotautomationclientnoscope
    Post Send Merchant Transaction To Point Issuer
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    error    insufficient_scope
    Response Should Contain Property With Value    error_description    Insufficient scope for this resource
    Response Should Contain Property With Value    scope    batch_processor