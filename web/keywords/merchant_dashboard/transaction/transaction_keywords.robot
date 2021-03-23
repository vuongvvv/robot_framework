*** Settings ***
Resource    ../../../resources/locators/merchant_dashboard/transaction/transaction_page_locators.robot

*** Keywords ***
Verify Last Transaction Amount Is As Expected
    [Arguments]    ${expected_amount}
    Wait Until Element Contains   ${spn_last_transaction_amount}    ${expected_amount}.00
