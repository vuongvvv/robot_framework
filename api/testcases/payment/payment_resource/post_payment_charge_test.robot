*** Settings ***
Documentation    Tests to verify that PaymentCharge api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/wallet_otp_resource_keywords.robot
Resource    ../../../keywords/payment/payment_resource_keywords.robot
Resource    ../../../keywords/payment/transaction_resource_keywords.robot
Resource    ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.write,payment.payment.read

*** Variables ***
${valid_otp_code}    111111
${name}    Automate script for payment online
${amount}    901
@{list_object_error}    chargeRequest
@{list_field_error}    paymentMethod    otpCode    authCode    otpRef
@{list_message_error}    True You Card service is not available    OtpCode is required    AuthCode is required    OtpRef is required

*** Test Cases ***
TC_O2O_04647
    [Documentation]    [Payment][PaymentCharge] Payment charges by txRefId data duplicate fill in data and All Parameter fill in data correct (Payment already)
    [Tags]    Medium    Regression    Smoke    payment
    Get Existing Transaction Reference
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "${EXISTING_TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online txRefId data duplicate fill in", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    duplicate_txRefId
    Response Should Contain Property With Value    message    txRefId have already used

TC_O2O_04644
    [Documentation]    [PaymentOnline][PaymentCharge] System allow to charge when paymentMethod is WALLET and input txRefId (txRefId is less than 20 digit)
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    19
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_12868
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System allow to charge when paymentMethod is TRUECARD and input txRefId (txRefId is less than 20 digit)
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    19
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    TRUECARD
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_04646
    [Documentation]    [PaymentOnline][PaymentCharge] System allow to charge when paymentMethod is WALLET and txRefId don't fill in and All Parameter fill in data correct
    [Tags]    Medium    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_12943
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System allow to charge when paymentMethod is TRUECARD and txRefId don't fill in and All Parameter fill in data correct
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    TRUECARD
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_04648
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod is WALLET and merchantId don't fill in data and All fill in data correct
    [Tags]    Medium    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    merchantId
    Response Should Contain Property With Value    fieldErrors..message    merchant id is required

TC_O2O_12862
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod is WALLET and merchantId is null and All fill in data correct
    [Tags]    Medium    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": null, "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    merchantId
    Response Should Contain Property With Value    fieldErrors..message    merchant id is required

TC_O2O_04649
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when merchantId dosen't truly exist and All fill in data correct
    [Tags]    Medium    Regression    Smoke    payment
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    Post Payment Charge    { "txRefId": "", "merchantId": "00000", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    Bad Request
    Response Should Contain Property With Value    message    Merchant does not exist

TC_O2O_14285
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when outletId dosen't truly exist and All fill in data correct
    [Tags]    Medium    Regression    Smoke    payment
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "00000", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    Bad Request
    Response Should Contain Property With Value    message    Merchant does not exist.

TC_O2O_04650
    [Documentation]    [PaymentOnline][PaymentCharge] system not allow to charge when paymentMethod is WALLET and outletId don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    outletId
    Response Should Contain Property With Value    fieldErrors..message    outlet id is required

TC_O2O_13387
    [Documentation]    [PaymentOnline][PaymentCharge] system not allow to charge when paymentMethod is TRUECARD and outletId don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    outletId
    Response Should Contain Property With Value    fieldErrors..message    outlet id is required

TC_O2O_04651
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when terminalId don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    terminalId
    Response Should Contain Property With Value    fieldErrors..message    terminal id is required

TC_O2O_04652
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when amount don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    amount
    Response Should Contain Property With Value    fieldErrors..message    amount is required

TC_O2O_04654
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when input amount more than 9 digit
    [Tags]    Medium    Regression    UnitTest    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "1234567890", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    amount
    Response Should Contain Property With Value    fieldErrors..message     length must be less than 10

TC_O2O_04655
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when channel don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    channel
    Response Should Contain Property With Value    fieldErrors..message    channel is required

TC_O2O_04656
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when currency don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    currency
    Response Should Contain Property With Value    fieldErrors..message    currency is required

TC_O2O_04657
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod is WALLET and mobile number don't fill in
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    mobile is required

TC_O2O_12945
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod is WALLET but mobile no. is null
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": null, "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    mobile is required

TC_O2O_12878
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but mobile no. is null or empty
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    mobile is required

TC_O2O_04658
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod don't fill in data and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    paymentMethod
    Response Should Contain Property With Value    fieldErrors..message    paymentMethod is required

TC_O2O_12946
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when tmnToken don't fill in data and All fill in data correct
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    tmnToken
    Response Should Contain Property With Value    fieldErrors..message    TmnToken is required

TC_O2O_12949
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when input paymentmethod ="WALLET" but input otpCode, otpRef, authCode instead of tmnToken in request body
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    linkingAgreement    https://www.truemoney.com/terms-conditions/?utm_source=inapp&online_merchant
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "WALLET", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    tmnToken
    Response Should Contain Property With Value    fieldErrors..message    TmnToken is required

TC_O2O_12880
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod not in (WALLET, TRUECARD)
    [Tags]    Medium    Regression    Smoke    UnitTest    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "CREDIT_CARD" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    ChargeRequest
    Response Should Contain Property With Value    fieldErrors..field    paymentMethod
    Response Should Contain Property With Value    fieldErrors..message    Not support payment method

TC_O2O_13386
    [Documentation]    System not allow to charge when input paymentMethod more than 20 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "THB", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "TestingpaymentMethodMoreThan20Digits" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    paymentMethod
    Response Should Contain Property With Value    fieldErrors..message    Payment Method is invalid.

TC_O2O_12859
    [Documentation]    [PaymentOnline][PaymentCharge] System allow to charge success when txRefId is fill in and All Parameter fill in data correct (txRefId is equal 20 digit)
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    20
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_12860
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when paymentMethod is WALLET and input txRefId (txRefId is more than 20 digits)
    [Tags]    Medium    Regression    UnitTest    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    21
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    txRefId
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 20

TC_O2O_12869
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD and input txRefId (txRefId is more than 20 digit)
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    21
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    txRefId
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 20

TC_O2O_13380
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when input outletId more than 20 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "111111111111111111111111111111111111111111111111111111111111111111111111111111111", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    outletId
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 20

TC_O2O_13381
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when input terminalId more than 20 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "111111111111111111111111111111111111111111111111111111111111111111111111111111111", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    terminalId
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 20

TC_O2O_12863
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when amount is not positive interger and All fill in data correct
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "-200", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    amount
    Response Should Contain Property With Value    fieldErrors..message    Amount is invalid.

TC_O2O_12864
    [Documentation]    [PaymentOnline][TrueDigitalCard: off][PaymentCharge] System not allow to charge when input mobile no. more than 10 digit
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "09123456789", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Invalid Format: Mobile No. must be in 10 digit

TC_O2O_12865
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when tmnToken is expire
    [Tags]    Low    Regression    payment
    #Step 1: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "eb93ad1365701b7c52d8e4616b34d098", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_access_token
    Response Should Contain Property With Value    message    Invalid access token or access token expired

TC_O2O_12948
    [Documentation]    [PaymentOnline][PaymentCharge] System not allow to charge when input invalid tmnToken and valid otpCode, otpRef, authCode in request body
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Post Request Otp Of Truemoney Wallet    { "mobile": "${TMN_WALLET_MOBILE}" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    linkingAgreement    https://www.truemoney.com/terms-conditions/?utm_source=inapp&online_merchant
    Get Otp Reference Of Truemoney Wallet
    Get Authorized Code Of Truemoney Wallet
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "eb93ad1365701b7c52d8e4616b34d098", "paymentMethod": "WALLET", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_access_token
    Response Should Contain Property With Value    message    Invalid access token or access token expired

#This testcase :TC_O2O_12866 should valid when TrueDigitalCard: Off
TC_O2O_12866
    [Documentation]    [PaymentOnline][TrueDigitalCard: off][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD
    [Tags]    Medium    ExcludeRegression
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "TRUECARD" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain All Property Values Include In List    fieldErrors..objectName    ${list_object_error}
    Response Should Contain All Property Values Include In List    fieldErrors..field    ${list_field_error}
    Response Should Contain All Property Values Include In List    fieldErrors..message    ${list_message_error}

TC_O2O_12870
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD and input dupplicate txRefId
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Request Otp Of True Digital Card (round1)
    Generate Transaction Reference    10
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    #Step 3: Request Otp Of True Digital Card (round2)
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 4: Post For Create Payment And Verify Response (round2)
    Post Payment Charge    { "txRefId": "${TRANSACTION_REFERENCE}", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    duplicate_txRefId
    Response Should Contain Property With Value    message    txRefId have already used

TC_O2O_12871
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but otpRef is not valid
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "NNNN", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_otp
    Response Should Contain Property With Value    message    The requested otp is invalid.

TC_O2O_12872
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but otpCode is not valid
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "123456", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_otp
    Response Should Contain Property With Value    message    The requested otp is invalid.

TC_O2O_12873
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but authCode is not valid
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "testNotInValid" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_auth_code
    Response Should Contain Property With Value    message    The requested auth code is invalid.

TC_O2O_12874
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but mobile no. is not valid
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "0912345678", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    code    invalid_account
    Response Should Contain Property With Value    message    Tmn account does not exist.

TC_O2O_12875
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but otpRef is empty
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "", "otpCode": "${valid_otp_code}", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    otpRef
    Response Should Contain Property With Value    fieldErrors..message    OtpRef is required

TC_O2O_12876
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but otpCode is null or empty
    [Tags]    Medium    Regression    UnitTest    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "", "authCode": "${AUTH_CODE}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    otpCode
    Response Should Contain Property With Value    fieldErrors..message    OtpCode is required

TC_O2O_12877
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD but authCode is null or empty
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request Otp Of True Digital Card
    Request Otp By Truecard And Get Reference Information    ${TRUE_DIGITAL_CARD}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": null, "paymentMethod": "TRUECARD", "otpRef": "${OTP_REF}", "otpCode": "${valid_otp_code}", "authCode": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    authCode
    Response Should Contain Property With Value    fieldErrors..message    AuthCode is required

TC_O2O_12879
    [Documentation]    [PaymentOnline][TrueDigitalCard: On][PaymentCharge] System not allow to charge when paymentMethod is TRUECARD and input tmnToken instead of otpRef,otpCode, authCode
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "TRUECARD", "otpRef": "", "otpCode": "", "authCode": "" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    authCode
    Response Should Contain Property With Value    fieldErrors..message    AuthCode is required

TC_O2O_13379
    [Documentation]    System not allow to charge when input merchantId more than 50 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    51
    Post Payment Charge    { "txRefId": "", "merchantId": "${TRANSACTION_REFERENCE}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    merchantId
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 50

TC_O2O_13382
    [Documentation]    System not allow to charge when input channel more than10 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "TESTCHANNELMORETHAN10DIGITS", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    channel
    Response Should Contain Property With Value    fieldErrors..message    Channel is invalid.

TC_O2O_13383
    [Documentation]    System not allow to charge when input currency more than10 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "TESTcurrencyMorethan10Digits", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    currency
    Response Should Contain Property With Value    fieldErrors..message    Currency is invalid.

TC_O2O_13384
    [Documentation]    System not allow to charge when input description more than 255 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    256
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "THB", "description": "${TRANSACTION_REFERENCE}", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    description
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 255

TC_O2O_13385
    [Documentation]    System not allow to charge when input name more than 255 digit
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    256
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${TRANSACTION_REFERENCE}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    name
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 255

TC_O2O_13388
    [Documentation]    System allow to charge when description is null
    [Tags]    Low    Regression    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": null, "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    ${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_13389
    [Documentation]    System not allow to charge when currency is invalid
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "baht", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    currency
    Response Should Contain Property With Value    fieldErrors..message    Currency is invalid.

TC_O2O_13363
    [Documentation]    System not allow to input HTML tag in "txRefId" field
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    18
    Post Payment Charge    { "txRefId": "<${TRANSACTION_REFERENCE}>", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "baht", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    txRefId
    Response Should Contain Property With Value    fieldErrors..message    The HTML tag are not allowed

TC_O2O_13364
    [Documentation]    System not allow to input HTML tag in "description" field
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "baht", "description": "</>", "mobile": "${TMN_WALLET_MOBILE}", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    description
    Response Should Contain Property With Value    fieldErrors..message    The HTML tag are not allowed

TC_O2O_13371
    [Documentation]    System not allow to input HTML tag in "mobile" field
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "baht", "description": "payment online", "mobile": "<12345678>", "name": "${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    mobile
    Response Should Contain Property With Value    fieldErrors..message    Invalid Format: Mobile No. must be in 10 digit

TC_O2O_13365
    [Documentation]    System not allow to input HTML tag in "name" field
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "edc", "currency": "baht", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "</>", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    name
    Response Should Contain Property With Value    fieldErrors..message    The HTML tag are not allowed

TC_O2O_13366
    [Documentation]    System allow to input "< " in "name" field
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    254
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "payment online", "mobile": "${TMN_WALLET_MOBILE}", "name": "<${TRANSACTION_REFERENCE}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    <${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS

TC_O2O_13367
    [Documentation]    Payment charges fail when input description more than 255 digits
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    256
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": "${TRANSACTION_REFERENCE}", "mobile": "${TMN_WALLET_MOBILE}", "name": "<${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    path    /api/charge
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    chargeRequest
    Response Should Contain Property With Value    fieldErrors..field    description
    Response Should Contain Property With Value    fieldErrors..message    length must be less than or equal to 255

TC_O2O_13425
    [Documentation]    Payment charges success when input description equal 250 digits
    [Tags]    Medium    Regression    Smoke    payment
    #Step 1: Request & Verity Otp Of Truemoney Wallet
    Request Otp And Verify Otp    ${TMN_WALLET_MOBILE}    ${valid_otp_code}
    #Step 2: Post For Create Payment And Verify Response
    Generate Transaction Reference    249
    Post Payment Charge    { "txRefId": "", "merchantId": "${BRAND_ID}", "outletId": "${BRANCH_ID}", "terminalId": "${TERMINAL_ID}", "amount": "${amount}", "channel": "EDC", "currency": "thb", "description": ">${TRANSACTION_REFERENCE}", "mobile": "${TMN_WALLET_MOBILE}", "name": "<${name}", "tmnToken": "${TMN_TOKEN}", "paymentMethod": "WALLET" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    name    <${name}
    Response Should Contain Property With Value    mobile    ${TMN_WALLET_MOBILE}
    Response Should Contain Property With Value    amount    ${amount}
    Response Should Contain Property With Value    currency    thb
    Response Should Contain Property With Value    paymentMethod    WALLET
    Response Should Contain Property With Value    status    SUCCESS
