*** Settings ***
Resource    ../../../resources/locators/merchant_dashboard/summary/summary_page_locators.robot

*** Keywords ***
Get Sales Amount Today From Merchant Dashboard
    Wait Until Element Is Visible   ${spn_today_sales_amount}
    ${TODAY_SALES_AMOUNT} =    Get Text    ${spn_today_sales_amount}
    ${TODAY_SALES_AMOUNT} =	   Remove String    ${TODAY_SALES_AMOUNT}    ,
    ${TODAY_SALES_AMOUNT} =	   Remove String    ${TODAY_SALES_AMOUNT}    .00
    Set Test Variable    ${TODAY_SALES_AMOUNT}

Store First Sales Amount Today From Merchant Dashboard
    [Arguments]    ${1st_sales_amount_today}
    Set Test Variable    ${1ST_SALES_AMOUNT_TODAY}    ${1st_sales_amount_today}

Verify Sales Amount Today Should Be Increase Correctly
    [Arguments]    ${1st_sales_amount_today}   ${money_amount_increasing}
    Wait Until Element Is Visible   ${spn_today_sales_amount}
    Wait Until Element Does Not Contain   ${spn_today_sales_amount}    ${SPACE} 0.00
    ${today_sales_amount} =    Get Text    ${spn_today_sales_amount}
    ${expected_sales_amount}=    Evaluate    ${1st_sales_amount_today}+${money_amount_increasing}    
    Should Be True    ${${expected_sales_amount}} == ${${today_sales_amount}}