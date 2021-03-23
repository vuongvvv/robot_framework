*** Settings ***
Documentation    User Journey test suite for payment accross O2O to verify elastic mapping when even type is P2P(#29) for success transaction
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/payment_transaction/merchant_payment_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/raw_payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource    ../../../api/keywords/merchant_subscriber/topic_message_management.robot

Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/merchant_dashboard/common/common_keywords.robot
Resource    ../../../web/keywords/merchant_dashboard/summary/summary_keywords.robot
Resource    ../../../web/keywords/merchant_dashboard/transaction/transaction_keywords.robot

# scope: paymentTx.read,paymentRawTx.create,payment.payment.write
# permission: paymentTransaction.msg.actAsAdmin,notification.message.actAsAdmin
Test Setup    Run Keywords    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}
...    AND    Open Browser With Option    ${MERCHANT_DASHBOARD_URL}    width=466    hight=679    headless_mode=${False}
Test Teardown    Run Keywords    Delete All Sessions
...    AND    Clean Environment

*** Variables ***
${raw_payment_transaction_topic_url}    /messagetool/api/topics/${ENV}.raw-payment-transaction/messages?page=1&size=25&sort=desc&partitionNumber=
${merchant_payment_transaction_topic_url}    /messagetool/api/topics/${ENV}.merchant-payment-transaction/messages?page=1&size=25&sort=desc&partitionNumber=

*** Test Cases ***
TC_O2O_20840
    [Documentation]    [Consumer] User Journey test case for payment accross O2O to verify elastic mapping when even type is P2P(#29) for success transaction
    [Tags]    Regression   Smoke   Sanity   E2E    ASCO2O-24937
    Get Sales Amount Today From Merchant Dashboard
    Store First Sales Amount Today From Merchant Dashboard    ${TODAY_SALES_AMOUNT}
    #Step1 Create Transaction and verify response body, kafka messages
    Generate Transaction Reference    20
    Generate Transaction Date With Format    -7 hours    %Y-%m-%dT%H:%M:%S.%fZ
    Generate Raw Payment Money Amount
    Post Create Raw Payment Transaction    { "tmnId": "tmn.10001433751", "transactionReference": "${TRANSACTION_REFERENCE}", "customerMobileNumber": "${CUSTOMER_MOBILE}", "transactionDate": "${TRANSACTION_DATE}", "customerThaiIdHash": "7b443f8409f4914057eb44f962", "merchantMobileNumber": "0969797944", "paymentData": "Automate for verify TrueTouch data sharing (P2P)", "eventType": "P2P", "moneyAmount": ${SATANG_MONEY_AMOUNT}, "kycVerifyStatus": true }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty Body
    Verify Topic Message    ${raw_payment_transaction_topic_url}    .payload:contains("transactionReference : ${TRANSACTION_REFERENCE}")
    Verify Topic Message    ${merchant_payment_transaction_topic_url}    .payload:contains("transactionReference : ${TRANSACTION_REFERENCE}")
    #Step2 Verify The Information On Elastic Search
    Get Search Transaction    ${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    .amount    ${SATANG_MONEY_AMOUNT}
    Response Should Contain Property With Value    .payer.mobile    ${CUSTOMER_MOBILE}
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.channel    QR
    Response Should Contain Property With Value    .paymentMethod.digitalWallet.qrTagId    29
    #Step2 Verify transaction in Elastic Search
    Get Search Payment Transaction From Elastic Search    query=transaction_reference:${TRANSACTION_REFERENCE}
    Response Should Contain Property With Value    .amount    ${SATANG_MONEY_AMOUNT}
    Response Should Contain Property With Value    .payee.mobile    0969797944
    Response Should Contain Property With Value    .payer.mobile    ${CUSTOMER_MOBILE}
    Response Should Contain Property With Value    .paymentStatus    SUCCESS
    #Step3 Verify Merchant Dashboard website should be show amount of today transaction correctly
    Reload Page
    Verify Sales Amount Today Should Be Increase Correctly    ${1ST_SALES_AMOUNT_TODAY}    ${BATH_MONEY_AMOUNT}
    Select Transaction Top Menu Bar
    Verify Last Transaction Amount Is As Expected    ${BATH_MONEY_AMOUNT}
