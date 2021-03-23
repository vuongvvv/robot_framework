*** Settings ***
Documentation    Tests to verify that clearMerchantCache api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/cache_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
TC_O2O_07801
    [Documentation]    [payment][clearMerchantCache] Request with public user returns 200
    [Tags]    Regression    Medium    Smoke
    Delete Clear Merchant Cache
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
