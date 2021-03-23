*** Settings ***
Documentation       Verify the dashboard snaphot screen display correctly.
Resource            ../../../../../api/resources/init.robot
Resource            ../../../keywords/payment_transaction/payment_transaction_resource_keywords.robot
Resource            ../../../keywords/payment_transaction/raw_payment_transaction_resource_keywords.robot
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Resource            ../../../../keywords/tsm/QR_merchant_status/check_merchant_status_keywords.robot
Resource            ../../../../keywords/tsm/main_edc/main_edc_keywords.robot
Resource            ../../../../keywords/tsm/merchant_dashboard/dashboard_snapshot_keywords.robot
Resource            ../../../../keywords/tsm/merchant_dashboard/transaction_statement_keywords.robot
Test Setup          Open Apps   TSM
Test Teardown       Close Application

*** Variables ***
${thai_id}                  1509901018351
${merchant_name}            ทดสอบ_ยอดขายรวม
${no_transaction_today}     0.00
${no_total_transaction}     0
${total_transaction}        1

*** Keywords ***
Precondition QR Merchant Go To Merchant Dashbord
    Tutorial Page Should Be Opened
    Tap On Check Merchant Status Menu
    Check Merchant Status Page Should Be Opened
    Input Thai ID       ${thai_id}
    Submit Check Merchant Status
    Select On Any Merchants     ${merchant_name}
    Input OTP Number       ${OTP_NUMBER}
    Submit OTP Number
    Main EDC Screen Should Be Opened
    Tap On Merchant Dashboard

*** Test Cases ***
TC_O2O_07966
    [Documentation]      Verify user can see total today sale correctly when merchant have no any payment transactions recieved
    [Tags]      Regression    Medium
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${no_transaction_today}
    Capture Page Screenshot         filename=TC_O2O_07966.png

TC_O2O_08520
    [Documentation]      Verify user want to see detail of the transactions of total money received by tap on numbers of total today sale as "0.00 บาท" on dashboard snapshot screen
    [Tags]      Regression    Medium
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${no_transaction_today}
    Tap On Total Today Sale Numbers
    Transaction Statement Page Should Be Opened
    Total Transaction Statement Show Correctly     ${no_total_transaction}
    Capture Page Screenshot         filename=TC_O2O_08520.png

TC_O2O_08518
    [Documentation]      Verify user want to see detail of the transactions of total money received but merchant have no any payment transactions recieved
    [Tags]      Regression    Medium
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${no_transaction_today}
    Tap On Transaction Statement
    Transaction Statement Page Should Be Opened
    Total Transaction Statement Show Correctly     ${no_total_transaction}
    Capture Page Screenshot         filename=TC_O2O_08518.png

TC_O2O_07964
    [Documentation]      Verify user can see amount of money for total today sale correctly when user have only one shop account
    [Tags]      Regression    High    Smoke    Sanity      E2E
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${transaction_today}
    Capture Page Screenshot         filename=TC_O2O_07964.png

TC_O2O_08519
    [Documentation]      Verrify user can see detail of the transactions of total money received correctly by tap on numbers of "total today sale" on dashboard snapshot screen
    [Tags]      Regression    High    Smoke    Sanity      E2E
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${transaction_today}
    Tap On Total Today Sale Numbers
    Transaction Statement Page Should Be Opened
    Total Transaction Statement Show Correctly     ${total_transaction}
    Display Detail Of Transactions Money Received Correctly     ${transaction_money}
    Capture Page Screenshot         filename=TC_O2O_08519.png

TC_O2O_08516
    [Documentation]      Verify user can see detail of the transactions of total money received correctly when user have only one shop account
    [Tags]      Regression    High    Smoke    Sanity      E2E
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${transaction_today}
    Tap On Transaction Statement
    Transaction Statement Page Should Be Opened
    Total Transaction Statement Show Correctly     ${total_transaction}
    Display Detail Of Transactions Money Received Correctly     ${transaction_money}
    Capture Page Screenshot         filename=TC_O2O_08516.png

TC_O2O_08521
    [Documentation]      Verify user can see receive transfer from TrueMoney transaction method Wallet correctly
    [Tags]      Regression    High    Smoke    Sanity      E2E
    Precondition QR Merchant Go To Merchant Dashbord
    Dashboard Snapshot Page Should Be Opened
    Total Today Sale Show Correctly     ${transaction_today}
    Tap On Transaction Statement
    Transaction Statement Page Should Be Opened
    Total Transaction Statement Show Correctly     ${total_transaction}
    Display Detail Of Transactions Money Received Correctly     ${transaction_money}
    Capture Page Screenshot         filename=TC_O2O_08521.png