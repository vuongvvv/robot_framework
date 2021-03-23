*** Settings ***
Documentation    Tests to verify API for generate the datakeypairs for each merchant
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/payment/merchant_payment_resource_keyword.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_admin
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.actAsAdmin

*** Test Cases ***
TC_O2O_17819
   [Documentation]    Allow to generate datakeypair when access client has admin scope and client is in allow list
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID_KEYPAIR}", "trueyouOutletId":"${SCB_OUTLET_ID_KEYPAIR}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID_KEYPAIR}
   Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_OUTLET_ID_KEYPAIR}
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17820
   [Documentation]    Allow to generate datakeypair when access client has admin scope and client is not in allow list
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID_KEYPAIR}", "trueyouOutletId":"${SCB_OUTLET_ID_KEYPAIR}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID_KEYPAIR}
   Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_OUTLET_ID_KEYPAIR}
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17821
   [Documentation]    Not allow to generate datakeypair when access client not admin scope
   [Tags]    Medium    Regression    payment
   [Setup]    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment_creditcard
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID_KEYPAIR}", "trueyouOutletId":"${SCB_OUTLET_ID_KEYPAIR}"}
   Response Correct Code    ${FORBIDDEN_CODE}
   Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
   Response Should Contain Property With Value    title    Forbidden
   Response Should Contain Property With Value    status    ${403}
   Response Should Contain Property With Value    detail    Access is denied
   Response Should Contain Property With Value    path    /api/v1/dataKeyPairs
   Response Should Contain Property With Value    message    error.http.403

TC_O2O_17822
   [Documentation]    Allow to generate datakeypair when merchant and outlet are invalid
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"1111111", "trueyouOutletId":"11111"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    1111111
   Response Should Contain Property With Value    'trueyouOutletId'    11111
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17823
   [Documentation]    Allow to generate datakeypair when invalid merchant but valid outlet
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"1111111", "trueyouOutletId":"${SCB_OUTLET_ID_KEYPAIR}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    1111111
   Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_OUTLET_ID_KEYPAIR}
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17824
   [Documentation]    Allow to generate datakeypair when valid merchant but invalid outlet
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID_KEYPAIR}", "trueyouOutletId":"11111"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID_KEYPAIR}
   Response Should Contain Property With Value    'trueyouOutletId'    11111
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17825
   [Documentation]    Allow to generate datakeypair when scb merchant status is inactive
   [Tags]    Medium    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID}", "trueyouOutletId":"${SCB_INACTIVE_OUTLET}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
   Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_INACTIVE_OUTLET}
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17826
   [Documentation]    Allow to generate datakeypair when scb merchant status is null
   [Tags]    Low    Regression    payment
   Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID}", "trueyouOutletId":"${SCB_NO_STATUS_OUTLET}"}
   Response Correct Code    ${SUCCESS_CODE}
   Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
   Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_NO_STATUS_OUTLET}
   Response Should Contain Property With String Value    publicKey
   Response Should Contain Property With String Value    cipherPrivateKey

TC_O2O_17827
    [Documentation]    Not allow to generate datakeypair when trueyouMerchantId is null
    [Tags]    Low    Regression    payment
    Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":null, "trueyouOutletId":"${SCB_OUTLET_ID_KEYPAIR}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/dataKeyPairs
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouMerchantId must not be empty

TC_O2O_17828
    [Documentation]    Not allow to generate datakeypair when trueyouOutletId is empty
    [Tags]    Low    Regression    payment
    Post Generate Data Keypair For Merchant To Support 2C2P Payment    {"trueyouMerchantId":"${SCB_MERCHANT_ID_KEYPAIR}", "trueyouOutletId":""}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    ${API_HOST}/payment
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/v1/dataKeyPairs
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    errors..code    0_request_validation
    Response Should Contain Property With Value    errors..message    trueyouOutletId must not be empty
