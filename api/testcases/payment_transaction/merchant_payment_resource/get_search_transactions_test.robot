*** Settings ***
Documentation    Tests to verify that search payment transaction from elastic search api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment_transaction/merchant_payment_resource_keywords.robot
Resource    ../../../keywords/edc_app_service/edc_payment_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${PAYMENT_TRAN_USER}    ${PAYMENT_TRAN_PASSWORD}    paymentTx.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
@{payment_status_list}    SUCCESS    FAIL    REVERSE
@{transaction_type_list}    CHARGE    CANCEL_CHARGE
@{payment_type_list}    TRUEMONEY    ALIPAY
@{payment_channel_list}    PAYMENT_CODE    TRUECARD    AUTH_CODE    QR
@{payment_channel_list_for_verify_condition}    PAYMENT_CODE    AUTH_CODE

*** Test Cases ***
TC_O2O_14292
    [Documentation]    Not allow to search when send request with invalid access_token
    [Tags]    Regression    Low    UnitTest
    Set Gateway Header With Invalid Access Token
    Get Search Payment Transaction From Elastic Search
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Cannot convert access token to JSON

TC_O2O_14293
    [Documentation]    Not allow to search when send request with expire access_token
    [Tags]    Regression    Low
    Set Gateway Header With Expired Token
    Get Search Payment Transaction From Elastic Search
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Access token expired: ${expire_tmn_token}

TC_O2O_14294
    [Documentation]    Not allow to search when send request without access_token header
    [Tags]    Regression    Low    UnitTest
    Set Gateway Header Without Authorization
    Get Search Payment Transaction From Elastic Search
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    unauthorized
    Response Should Contain Property With Value    error_description    Full authentication is required to access this resource

TC_O2O_14295
    [Documentation]    Not allow to search when sending a request with invalid client scope
    [Tags]    Regression    Low    UnitTest
    [SETUP]    Generate Gateway Header With Scope and Permission    ${PAYMENT_TRAN_USER}    ${PAYMENT_TRAN_PASSWORD}    paymentTx.write
    Get Search Payment Transaction From Elastic Search
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    status    ${403}
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/merchant-payment/_search/transactions
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_14297
    [Documentation]    Allow to search without any query param
    [Tags]    Regression    Medium    Smoke    UnitTest
    Get Search Payment Transaction From Elastic Search
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionReference
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With String Value    .amount
    Response Should Contain Property With String Value    .payee.merchantId
    Response Should Contain Property With String Value    .payee.outletId
    Response Should Contain Property With String Value    .payee.terminalId
    Response Should Contain Property With String Value    .payee.mobile
    Response Should Contain Property With String Value    .payer.mobile
    Response Should Contain Property Value Include In List    .paymentStatus    ${payment_status_list}
    Response Should Contain Property With String Value    .paymentStatusDescription
    Response Should Contain Property With String Value    .sourceTransactionId
    Response Should Contain Property Value Include In List    .transactionType    ${transaction_type_list}
    Response Should Contain Property With String Value    .paymentChannel
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property Value Include In List    .paymentMethod.digitalWallet.type    ${payment_type_list}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property Value Include In List    .paymentMethod.digitalWallet.channel    ${payment_channel_list}
    Verify Page Size    20

TC_O2O_14298
    [Documentation]    Not allow to search by transaction_date without (double quote)
    [Tags]    Regression    Low
    Get Search Payment Transaction From Elastic Search    query=transaction_date:2020-01-05T01:00:00.000Z
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/merchant-payment/_search/transactions
    Response Should Contain Property With Value    message    Query Invalid Pattern

TC_O2O_14299
    [Documentation]    Not allow to search by amount with minus value
    [Tags]    Regression    Low
    Get Search Payment Transaction From Elastic Search    query=amount:-200
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value    status    ${400}
    Response Should Contain Property With Value    path    /api/merchant-payment/_search/transactions
    Response Should Contain Property With Value    message    Query Invalid Pattern

TC_O2O_14300
    [Documentation]    Not display error when search by amount with character
    [Tags]    Regression    Low
    Get Search Payment Transaction From Elastic Search    query=amount:2.99
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=amount:"A"
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=amount:200%
    Response Should Not Found

TC_O2O_14301
    [Documentation]    Verify response when search null value with wording null
    [Tags]    Regression    Low
    Get Search Payment Transaction From Elastic Search    query=source_transaction_id:null
    Response Should Not Found

TC_O2O_14302
    [Documentation]    [Sensitive Case] Veify response when search by invalid sensitive case ( Case: payment type =TRUEMONEY)
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_status:fail
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND transaction_type:charge
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_channel:edc
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_method.type:Digital_Wallet
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEy
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_method.digital_wallet.funding:Wallet
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_method.digital_wallet.channel:Payment_Code
    Response Should Not Found

TC_O2O_14303
    [Documentation]    [Sensitive Case] Veify response when search by invalid sensitive case ( Case: payment type =ALIPAY)
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND payment_status:Success
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND transaction_type:charge
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND payment_channel:edc
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND payment_method.type:Digital_Wallet
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:Alipay
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND payment_method.digital_wallet.funding:Wallet
    Response Should Not Found
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALIPAY AND payment_method.digital_wallet.channel:Payment_Code
    Response Should Not Found

TC_O2O_14304
    [Documentation]    [Single Search] Allow to search with empty string incase null value
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=source_transaction_id:""
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionReference
    Response Should Contain Property With String Value    .transactionDate
    Response Should Contain Property With String Value    .amount
    Response Should Contain Property With String Value    .payee.merchantId
    Response Should Contain Property With String Value    .payee.outletId
    Response Should Contain Property With String Value    .payee.terminalId
    Response Should Contain Property With String Value    .payee.mobile
    Response Should Contain Property With String Value    .payer.mobile
    Response Should Contain Property Value Include In List    .paymentStatus    ${payment_status_list}
    Response Should Contain Property With String Value    .paymentStatusDescription
    Response Should Contain Property With String Value    .sourceTransactionId
    Response Should Contain Property Value Include In List    .transactionType    ${transaction_type_list}
    Response Should Contain Property With String Value    .paymentChannel
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Response Should Contain Property Value Include In List    .paymentMethod.digitalWallet.type    ${payment_type_list}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Response Should Contain Property Value Include In List    .paymentMethod.digitalWallet.channel    ${payment_channel_list}
    Verify Page Size    20

TC_O2O_14305
    [Documentation]    [Single Search] Allow to search with valid payment_status
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_status:SUCCESS
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Get Search Payment Transaction From Elastic Search    query=payment_status:FAIL
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentStatus    FAIL

TC_O2O_14306
    [Documentation]    [Single Search] Allow to search with valid payment_status
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_status_description:"Metadata length exceeds limit of 250."
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentStatusDescription    Metadata length exceeds limit of 250.
    Get Search Payment Transaction From Elastic Search    query=payment_status_description:"METADATA length exceeds limit of 250."
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentStatusDescription    Metadata length exceeds limit of 250.

TC_O2O_14307
    [Documentation]    [Single Search] Allow to search with valid transaction_type
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=transaction_type:CANC*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .transactionType    CANCEL
    Get Search Payment Transaction From Elastic Search    query=transaction_type:CHARGE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .transactionType    CHARGE

TC_O2O_14308
    [Documentation]    [Single Search] Allow to search with valid payment_channel
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_channel:EDC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentChannel    EDC
    Get Search Payment Transaction From Elastic Search    query=payment_channel:AP*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentChannel    APP

TC_O2O_14309
    [Documentation]    [Single Search] Allow to search with valid payment_method.type
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.type:DIGITAL_WALLET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET
    Get Search Payment Transaction From Elastic Search    query=payment_method.type:DIGI*_WALLET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.type    DIGITAL_WALLET

TC_O2O_14310
    [Documentation]    [Single Search] Allow to search with valid payment_method.digital_wallet.type
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:ALI*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    ALIPAY

TC_O2O_14311
    [Documentation]    [Single Search] Allow to search with valid payment_method.digital_wallet.funding
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.funding:WALLET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.funding:WA*ET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.funding    WALLET

TC_O2O_14312
    [Documentation]    [Single Search] Allow to search with valid payment_method.digital_wallet.channel
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.channel:AUTH_CODE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    AUTH_CODE
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.channel:P*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    PAYMENT_CODE

TC_O2O_14313
    [Documentation]    [Single Search] Allow to search with valid payment_method.digital_wallet.qr_tag_id
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.qr_tag_id:29
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.qrTagId    29
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.qr_tag_id:3*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.qrTagId    39

TC_O2O_14314
    [Documentation]    [Single Search] Allow to search with valid transaction_reference
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=transaction_reference:*STORM*
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionReference

TC_O2O_14315
    [Documentation]    [Single Search] Allow to search with valid transaction_date
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=transaction_date:"2020-02-13"
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionDate

TC_O2O_14316
    [Documentation]    [Single Search] Allow to search with valid range of transaction_date
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=transaction_date:["2020-02-01T04:39:26.000Z"+TO+"2020-02-28T05:51:43.000Z"]
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionDate
    Get Search Payment Transaction From Elastic Search    query=transaction_date:["2020-02-01" TO "2020-02-28"]
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionDate

TC_O2O_14317
    [Documentation]    [Single Search] Allow to search with valid amount
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=amount:100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .amount    ${100}
    Get Search Payment Transaction From Elastic Search    query=amount:100%
    Response Should Not Found

TC_O2O_14318
    [Documentation]    [Single Search] Allow to search with valid range of amount
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    sort=amount&query=amount:[100 TO 2000]
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .amount    ${100}
    Get Search Payment Transaction From Elastic Search    sort=amount&query=amount:[100+TO+2000]
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .amount    ${100}

TC_O2O_14319
    [Documentation]    [Single Search] Allow to search with valid application
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=application:payment
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionReference

TC_O2O_14320
    [Documentation]    [Single Search] Allow to search with valid payee.merchant_id
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payee.merchant_id:${BRAND_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}

TC_O2O_14321
    [Documentation]    [Single Search] Allow to search with valid payee.outlet_id
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payee.outlet_id:${BRANCH_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}

TC_O2O_14322
    [Documentation]    [Single Search] Allow to search with valid payee.terminal_id
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payee.terminal_id:${TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}

TC_O2O_14323
    [Documentation]    [Single Search] Allow to search with valid payee.mobile
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payee.mobile:${MERCHANT_MOBILE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.mobile    ${MERCHANT_MOBILE}

TC_O2O_14324
    [Documentation]    [Single Search] Allow to search with valid payer.mobile
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payer.mobile:${CUSTOMER_MOBILE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payer.mobile    ${CUSTOMER_MOBILE}

TC_O2O_14328
    [Documentation]    [Single Search] Allow to search with size of page
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    size=10
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    .transactionReference
    Verify Page Size    10

TC_O2O_14329
    [Documentation]    [Multiple Search] [valid all] Allow to search with AND condition
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.type:TRUEMONEY AND payment_method.digital_wallet.channel:PAYMENT_CODE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.type    TRUEMONEY
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    PAYMENT_CODE

TC_O2O_14330
    [Documentation]    [Multiple Search] [valid all]  Allow to search with OR condition (all valid value)
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payment_method.digital_wallet.channel:PAYMENT_CODE OR payment_method.digital_wallet.channel:AUTH_CODE&size=100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Include In List    .paymentMethod.digitalWallet.channel    ${payment_channel_list_for_verify_condition}

TC_O2O_14331
    [Documentation]    [Multiple Search] [valid all] Allow to search with NOT condition
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=NOT payment_method.digital_wallet.channel:TRUECARD NOT payment_method.digital_wallet.channel:QR&size=100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Include In List    .paymentMethod.digitalWallet.channel    ${payment_channel_list_for_verify_condition}

TC_O2O_14332
    [Documentation]    [Multiple Search] [valid all] Allow to search with 2 operators condition
    [Tags]    Regression    Medium    Smoke
    Get Search Payment Transaction From Elastic Search    query=payee.merchant_id:${BRAND_ID} AND payee.outlet_id:${BRANCH_ID} AND payee.terminal_id:${TERMINAL_ID}&size=5
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
    Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
    Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
    Verify Page Size    5
    Get Search Payment Transaction From Elastic Search    query=payee.merchant_id:${BRAND_ID} AND payee.outlet_id:${BRANCH_ID} OR payee.mobile:""&size=4
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .payee.merchantId    ${BRAND_ID}
    Response Should Contain Property With Value    .payee.outletId    ${BRANCH_ID}
    Response Should Contain Property With Value    .payee.terminalId    ${TERMINAL_ID}
    Response Should Contain Property With Null Value    .payee.mobile
    Verify Page Size    4
