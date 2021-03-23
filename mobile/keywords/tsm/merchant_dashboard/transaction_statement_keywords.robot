*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/merchant_dashboard/transaction_statement_locators.robot

*** Keywords ***
Transaction Statement Page Should Be Opened
    Wait Until Element Is Visible        &{transaction_statement}[btn_date_picker]

Total Transaction Statement Show Correctly
    [Arguments]     ${total_transaction}
    Element Text Should Be      &{transaction_statement}[lbl_total_transaction]     ${total_transaction}
    Element Text Should Be      &{transaction_statement}[lbl_total_unit]     &{transaction_statement_text}[lbl_total_unit]

Display Detail Of Transactions Money Received Correctly
    [Arguments]     ${transaction_money}
    Element Text Should Be      &{transaction_statement}[lbl_truemoney]     &{transaction_statement_text}[lbl_truemoney]
    Element Text Should Be      &{transaction_statement}[lbl_total_truemoney]     ${transaction_money}
    Element Text Should Be      &{transaction_statement}[lbl_total_truemoney_unit]     &{transaction_statement_text}[lbl_total_truemoney_unit]