*** Settings ***
Documentation    Tests to verify that Get Payment Status api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_keywords.robot
Resource    ../../../keywords/apigee/apigee_payment_keywords.robot
Test Setup       Generate Apigee Header
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_08638
    [Documentation]    [API] [Apigee] [Payment] Verify search status when only TrueMoney charge status is success
    [Tags]    High    Smoke    UnitTest      Regression      Sanity
    Get Apigee Payment Status         ${SUCCESS_TX_REF_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    SUCCESS
    Response Should Contain Property With Value          .payment..code      1_success
    Response Should Contain Property With Value          .payment..message   Success
    Response Should Contain Property With Empty Value    .refund

TC_O2O_08639
    [Documentation]    [API] [Apigee] [Payment] Verify search status when TrueMoney charge and cancel status is success
    [Tags]    High    Smoke    UnitTest      Regression      Sanity
    Get Apigee Payment Status         ${SUCCESS_CANCEL_TX_REF_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    SUCCESS
    Response Should Contain Property With Value          .payment..code      1_success
    Response Should Contain Property With Value          .payment..message   Success
    Response Should Contain Property With Value          .refund..status     SUCCESS
    Response Should Contain Property With Value          .refund..code       1_success
    Response Should Contain Property With Value          .refund..message    Success

TC_O2O_08640
    [Documentation]    [API] [Apigee] [Payment] Verify search status when no transaction in rpp_payment
    [Tags]    Medium    Smoke      UnitTest
    Get Apigee Payment Status         ${NOT_FOUND_TX_REF_ID}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value          .code         bad_request
    Response Should Contain Property With Value          .message      Transaction does not exist.

TC_O2O_08643
    [Documentation]    [API] [Apigee] [Payment] Verify search status when  rpp_payment have a transaction but no transaction in TrueMoney
    [Tags]    Medium    Smoke      UnitTest
    Get Apigee Payment Status         ${NO_TRANSACTION_TMN_TX_REF_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    FAIL
    Response Should Contain Property With Value          .payment..code      1_invalid_isv_payment_ref
    Response Should Contain Property With Value          .payment..message   Isv payment reference does not exist.
    Response Should Contain Property With Empty Value    .refund

TC_O2O_08644
    [Documentation]    [API] [Apigee] [Payment] Verify search status when TrueMoney charge status is fail due to request are inconsistent.
    [Tags]    Medium    Smoke
    Get Apigee Payment Status         ${BALANCE_NOT_ENOUGH}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    FAIL
    Response Should Contain Property With Value          .payment..code      1_insufficient_fund
    Response Should Contain Property With Value          .payment..message   User's balance is not enough.
    Response Should Contain Property With Empty Value    .refund

TC_O2O_08645
    [Documentation]    [API] [Apigee] [Payment] Verify search status when TrueMoney charge status is fail due to processing_error
    [Tags]    Medium    Smoke
    Get Apigee Payment Status         ${BALANCE_PROCESS_FAIL}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    FAIL
    Response Should Contain Property With Value          .payment..code      1_processing_error
    Response Should Contain Property With Value          .payment..message   An error occurred while processing balance.
    Response Should Contain Property With Empty Value    .refund

TC_O2O_08646
    [Documentation]    [API] [Apigee] [Payment] Verify search status when TrueMoney charge status is success but refund is fail
    [Tags]    Medium    Smoke      UnitTest
    Get Apigee Payment Status         ${FAIL_CANCEL_TX_REF_ID}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value          .payment..status    SUCCESS
    Response Should Contain Property With Value          .payment..code      1_success
    Response Should Contain Property With Value          .payment..message   Success
    Response Should Contain Property With Value          .refund..status     FAIL
    Response Should Contain Property With Value          .refund..code       1_processing_error
    Response Should Contain Property With Value          .refund..message    An error occurred while processing balance.

TC_O2O_08648
    [Documentation]    [API] [Apigee] [Payment] Verify search status when payment method is NULL
    [Tags]    Medium    Smoke      UnitTest
    Get Apigee Payment Status         ${PAYMENT_METHOD_IS_NULL}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value          .code         bad_request
    Response Should Contain Property With Value          .message      This payment method is not existing in the system.
