*** Settings ***
Documentation    Tests to verify Query Outlet Payment Information API
Resource    ../../../resources/init.robot
Resource    ../../../resources/testdata/payment/merchant_list.robot
Resource    ../../../keywords/merchant_v2/outlet_payment_info_resource_keywords.robot
Resource    ../../../keywords/edc_app_service/edc_payment_keywords.robot
Test Setup        Generate Gateway Header With Scope and Permission    ${MERCHANT_V2_USERNAME}    ${MERCHANT_V2_PASSWORD}    payment.payment.actAsAdmin
Test Teardown     Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
@{validation_param}    trueyouMerchantId    trueyouOutletId

*** Test Cases ***
TC_O2O_16678
    [Documentation]    Not allow to get merchant information when access with merchant scope and no permission to access merchant and outlet
    [Tags]    Medium    Regression
    [Setup]    Generate Gateway Header With Scope and Permission    ${MERCHANT_V2_USERNAME}    ${MERCHANT_V2_PASSWORD}    payment.payment.read
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    No authority for merchant: ${SCB_MERCHANT_ID} outlet: ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    No authority for merchant: ${SCB_MERCHANT_ID} outlet: ${SCB_ACTIVE_OUTLET}

TC_O2O_16679
    [Documentation]    Allow to get merchant information when access with merchant scope and has permission to access merchant and outlet
    [Tags]    Medium    Regression
    [Setup]    Generate Gateway Header With Scope and Permission    ${MERCHANT_V2_USERNAME}    ${MERCHANT_V2_PASSWORD}    payment.payment.read
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    rppOutletId
    Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With String Value    scbCreditCardMid
    Response Should Contain Property With Value    scbCreditCardStatus    ACTIVE
    Response Should Contain Property With String Value    scbCreditCardRemark
    Response Should Contain Property With String Value    scbCreditCardAscendRate
    Response Should Contain Property With String Value    scbCreditCardMerchantRate
    Response Should Contain Property With String Value    scbCreditCardCreatedBy
    Response Should Contain Property With String Value    scbCreditCardCreatedDate
    Response Should Contain Property With String Value    scbCreditCardModifiedBy
    Response Should Contain Property With String Value    scbCreditCardModifiedDate
    Response Should Contain Property With String Value    scbCreditCardMerchantSecretKey
    Response Should Contain Property With String Value    o2oCreditCardPublicKey
    Response Should Contain Property With String Value    o2oCreditCardCipherPrivateKey
    Response Should Contain Property With String Value    scbCreditCardMerchantName
    Response Should Contain Property With Value    creditCardGateway    SCB
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMerchantSecretKey
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMid
    Response Should Contain Property With String Value    gateway2c2pCreditCardStatus

TC_O2O_16680
    [Documentation]    Allow to get merchant information when access with admin scope and no permission to access merchant and outlet
    [Tags]    Medium    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    rppOutletId
    Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With String Value    scbCreditCardMid
    Response Should Contain Property With Value    scbCreditCardStatus    ACTIVE
    Response Should Contain Property With String Value    scbCreditCardRemark
    Response Should Contain Property With String Value    scbCreditCardAscendRate
    Response Should Contain Property With String Value    scbCreditCardMerchantRate
    Response Should Contain Property With String Value    scbCreditCardCreatedBy
    Response Should Contain Property With String Value    scbCreditCardCreatedDate
    Response Should Contain Property With String Value    scbCreditCardModifiedBy
    Response Should Contain Property With String Value    scbCreditCardModifiedDate
    Response Should Contain Property With String Value    scbCreditCardMerchantSecretKey
    Response Should Contain Property With String Value    o2oCreditCardPublicKey
    Response Should Contain Property With String Value    o2oCreditCardCipherPrivateKey
    Response Should Contain Property With String Value    scbCreditCardMerchantName
    Response Should Contain Property With Value    creditCardGateway    SCB
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMerchantSecretKey
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMid
    Response Should Contain Property With String Value    gateway2c2pCreditCardStatus

TC_O2O_16681
    [Documentation]    Allow to get merchant information when access with admin scope and has permission to access merchant and outlet
    [Tags]    Medium    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    rppOutletId
    Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_ACTIVE_OUTLET}
    Response Should Contain Property With String Value    scbCreditCardMid
    Response Should Contain Property With Value    scbCreditCardStatus    ACTIVE
    Response Should Contain Property With String Value    scbCreditCardRemark
    Response Should Contain Property With String Value    scbCreditCardAscendRate
    Response Should Contain Property With String Value    scbCreditCardMerchantRate
    Response Should Contain Property With String Value    scbCreditCardCreatedBy
    Response Should Contain Property With String Value    scbCreditCardCreatedDate
    Response Should Contain Property With String Value    scbCreditCardModifiedBy
    Response Should Contain Property With String Value    scbCreditCardModifiedDate
    Response Should Contain Property With String Value    scbCreditCardMerchantSecretKey
    Response Should Contain Property With String Value    o2oCreditCardPublicKey
    Response Should Contain Property With String Value    o2oCreditCardCipherPrivateKey
    Response Should Contain Property With String Value    scbCreditCardMerchantName
    Response Should Contain Property With Value    creditCardGateway    SCB
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMerchantSecretKey
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMid
    Response Should Contain Property With String Value    gateway2c2pCreditCardStatus

TC_O2O_15783
    [Documentation]    Get payment info success when search by valid merchant and outlet_id and scbCreditCardStatus is inactive
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_INACTIVE_OUTLET}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    rppOutletId
    Response Should Contain Property With Value    'trueyouMerchantId'    ${SCB_MERCHANT_ID}
    Response Should Contain Property With Value    'trueyouOutletId'    ${SCB_INACTIVE_OUTLET}
    Response Should Contain Property With String Value    scbCreditCardMid
    Response Should Contain Property With Value    scbCreditCardStatus    INACTIVE
    Response Should Contain Property With String Value    scbCreditCardRemark
    Response Should Contain Property With String Value    scbCreditCardAscendRate
    Response Should Contain Property With String Value    scbCreditCardMerchantRate
    Response Should Contain Property With String Value    scbCreditCardCreatedBy
    Response Should Contain Property With String Value    scbCreditCardCreatedDate
    Response Should Contain Property With String Value    scbCreditCardModifiedBy
    Response Should Contain Property With String Value    scbCreditCardModifiedDate
    Response Should Contain Property With String Value    scbCreditCardMerchantSecretKey
    Response Should Contain Property With String Value    o2oCreditCardPublicKey
    Response Should Contain Property With String Value    o2oCreditCardCipherPrivateKey
    Response Should Contain Property With String Value    scbCreditCardMerchantName
    Response Should Contain Property With Value    creditCardGateway    SCB
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMerchantSecretKey
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardMid
    Response Should Contain Property With Empty Value    gateway2c2pCreditCardStatus

TC_O2O_15785
    [Documentation]    Get payment info fail when trueyouMerchantId is invalid
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=101110000100000&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15786
    [Documentation]    Get payment info fail when trueyouMerchantId is null
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=null&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15787
    [Documentation]    Get payment info fail when trueyouMerchantId is null
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=""&trueyouOutletId=${SCB_ACTIVE_OUTLET}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15788
    [Documentation]    Get payment info fail when trueyouOutletId is invalid
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=2431
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15789
    [Documentation]    Get payment info fail when trueyouOutletId is null
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=null
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15790
    [Documentation]    Get payment info fail when trueyouOutletId is empty
    [Tags]    Low    Regression
    Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=""
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Not Found
    Response Should Contain Property With Value    status    ${404}
    Response Should Contain Property With Value    detail    Data not found
    Response Should Contain Property With Value    path    /api/outlets/paymentInfo
    Response Should Contain Property With Value    message    Data not found

TC_O2O_15791
     [Documentation]    Get payment info fail when trueyouMerchantId is not in search param
     [Tags]    Low    Regression
     Get Outlet Payment Infomation    trueyouOutletId=${SCB_ACTIVE_OUTLET}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
     Response Should Contain Property With Value    title    Constraint Violation
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    path    /api/outlets/paymentInfo
     Response Should Contain Property With Value    violations..field    trueyouMerchantId
     Response Should Contain Property With Value    violations..message    must not be blank

TC_O2O_15792
     [Documentation]    Get payment info fail when trueyouMerchantId is not in search param
     [Tags]    Low    Regression
     Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
     Response Should Contain Property With Value    title    Constraint Violation
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    path    /api/outlets/paymentInfo
     Response Should Contain Property With Value    violations..field    trueyouOutletId
     Response Should Contain Property With Value    violations..message    must not be blank

TC_O2O_15793
     [Documentation]    Get payment info fail when trueyouMerchantId and trueyouOutletId are not in search param
     [Tags]    Low    Regression
     Get Outlet Payment Infomation
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
     Response Should Contain Property With Value    title    Constraint Violation
     Response Should Contain Property With Value    status    ${400}
     Response Should Contain Property With Value    message    error.validation
     Response Should Contain Property With Value    path    /api/outlets/paymentInfo
     Response Should Contain Property Value Include In List    violations..field    ${validation_param}
     Response Should Contain Property With Value    violations..message    must not be blank

TC_O2O_15804
     [Documentation]    Get payment info fail when access token is expire
     [Tags]    Low    Regression
     Set Gateway Header With Expired Token
     Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
     Response Correct Code    ${UNAUTHORIZED}
     Response Should Contain Property With Value    error    invalid_token
     Response Should Contain Property With Value    error_description    Access token expired: ${expire_tmn_token}

TC_O2O_15805
     [Documentation]    Get payment info fail when access token is invalid
     [Tags]    Low    Regression
     Set Gateway Header With Invalid Access Token
     Get Outlet Payment Infomation    trueyouMerchantId=${SCB_MERCHANT_ID}&trueyouOutletId=${SCB_ACTIVE_OUTLET}
     Response Correct Code    ${UNAUTHORIZED}
     Response Should Contain Property With Value    error    invalid_token
     Response Should Contain Property With Value    error_description    Cannot convert access token to JSON
