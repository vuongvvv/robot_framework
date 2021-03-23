*** Settings ***
Resource    ../../../keywords/common/mobile_common.robot
Resource    ../../../resources/locators/tsm/merchant_dashboard/dashboard_snapshot_locators.robot

*** Keywords ***
Dashboard Snapshot Page Should Be Opened
    Wait Until Page Contains        &{dashboard_snapshot_text}[lbl_title]
    Wait Until Element Is Visible        &{total_today_sale}[lbl_total_sales_today]

Display Dashboard Snapshot Show Correctly
    Element Text Should Be      &{dashboard_snapshot}[tab_summary]     &{dashboard_snapshot_text}[lbl_summary]
    Element Text Should Be      &{dashboard_snapshot}[tab_transaction_statement]     &{dashboard_snapshot_text}[lbl_transaction_statement]

Total Today Sale Show Correctly
    [Arguments]     ${total_sale_numbers}
    Element Text Should Be      &{total_today_sale}[lbl_total_sales_today]     &{total_today_sale_text}[lbl_today_sale]
    Element Text Should Be      &{total_today_sale}[lbl_total_today_sales]     ${total_sale_numbers}
    Element Text Should Be      &{total_today_sale}[lbl_total_today_sales_unit]     &{dashboard_snapshot_text}[lbl_unit]
    Element Text Should Be      &{total_today_sale}[lbl_update_on]     &{total_today_sale_text}[lbl_update]

Total Yesterday Sale Show Correctly
    Element Text Should Be      &{total_yesterday_sale}[lbl_yesterday]     &{total_yesterday_sale_text}[lbl_yesterday]
    Element Text Should Be      &{total_yesterday_sale}[lbl_total_revenue]     &{total_yesterday_sale_text}[lbl_total_revenue]
    Element Text Should Be      &{total_yesterday_sale}[lbl_total_revenue_remark]     &{total_yesterday_sale_text}[lbl_total_revenue_remark]

Total Transfer Show Correctly
    Element Text Should Be      &{total_yesterday_sale}[lbl_total_sale]     &{total_yesterday_sale_text}[lbl_total_sale]
    Element Text Should Be      &{total_yesterday_sale}[lbl_yesterday_sales_unit]     &{dashboard_snapshot_text}[lbl_unit]

Total Subsidy Show Correctly
    Element Text Should Be      &{total_yesterday_sale}[lbl_summary_list]     &{total_yesterday_sale_text}[lbl_summary_list]
    Element Text Should Be      &{total_yesterday_sale}[lbl_value_summary_list_unit]     &{dashboard_snapshot_text}[lbl_unit]
    Element Text Should Be      &{total_yesterday_sale}[lbl_subsidy_remark]     &{total_yesterday_sale_text}[lbl_subsidy_remark]

Total Reward Show Correctly
    Element Text Should Be      &{total_yesterday_sale}[lbl_true_reward]     &{total_yesterday_sale_text}[lbl_true_reward]
    Element Text Should Be      &{total_yesterday_sale}[lbl_reward_yesterday_unit]     &{dashboard_snapshot_text}[lbl_unit]
    Element Text Should Be      &{total_yesterday_sale}[lbl_true_reward_remark]     &{total_yesterday_sale_text}[lbl_true_reward_remark]

Total TruePoint Show Correctly
    Page Should Contain Text     &{total_yesterday_sale_text}[lbl_truepoint_1]
    Page Should Contain Text     &{total_yesterday_sale_text}[lbl_truepoint_2]

Total Revenue Show Correctly
    Element Text Should Be      &{total_revenue}[lbl_revenue_header]     &{total_revenue_text}[lbl_revenue_header]
    Element Text Should Be      &{total_revenue}[lbl_revenue_detail]     &{total_revenue_text}[lbl_revenue_detail]

Tap On Transaction Statement
    Click Element    &{dashboard_snapshot}[tab_transaction_statement]

Tap On Total Today Sale Numbers
    Click Element    &{total_today_sale}[lbl_total_today_sales]

Tap On Total Today Sale Information Icon
    Click Element    &{total_today_sale}[btn_total_sale_information]

Tap On Total Yesterday Sale Information Icon
    Click Element    &{total_yesterday_sale}[btn_total_revenue_information]

Tap On Total Sale Information Icon
    Click Element    &{total_yesterday_sale}[btn_total_sale_information_on_total_sale]

Tap On Total Subsidy Information Icon
    Click Element    &{total_yesterday_sale}[icon_info_gray]

Tap On Total Reward Information Icon
    Click Element    &{total_yesterday_sale}[btn_true_reward_information]

Tap On Total TruePoint Information Icon
    Click Element    &{total_yesterday_sale}[btn_truepoint_information]