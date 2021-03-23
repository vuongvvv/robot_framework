*** Settings ***
Documentation    Only user group TrueYouAdmin should be able to edit, delete, activate (or deactivate) campaign any time without restriction.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot
Suite Setup     Prepare Test Suite Data
Test Teardown       Delete All Sessions

*** Variables ***
${campaign_merchant_type}                   merchant
${campaign_customer_type}                   customer
${campaign_group}                           university
${spending_amount}                          20000
${payment_id_1}                             1
${payment_id_2}                             2
${point}                                    5
${minimum_spending}                         2500
${daily_cap}                                200000
${monthly_cap}                              5000000
${active_status}                            ACTIVE
${update_campaign_group}                    makro
${inactive_status}                          INACTIVE

${forbidden_request_title}                  Forbidden

*** Keywords ***
Prepare Test Suite Data
    Generate Admin Tools Gateway Header    ${TRUEYOU_ADMIN_USER}    ${TRUEYOU_ADMIN_PASSWORD}
    Set Campaign Date Period
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id_1}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${active_status}

*** Test Cases ***
TC_O2O_02122
    [Documentation]     Verify that API returns error when user trueyou admin has edited running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${TRUEYOU_ADMIN_USER}    ${TRUEYOU_ADMIN_PASSWORD}
    Update Campaign By ID       ${created_campaign_id}     ${campaign_customer_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}     ${start_date}    ${end_date}    ${active_status}
    Response Correct Code      ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title     ${forbidden_request_title}

TC_O2O_02123
    [Documentation]     Verify that API returns error when user trueyou admin has deleted running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${TRUEYOU_ADMIN_USER}    ${TRUEYOU_ADMIN_PASSWORD}
    Delete Campaign By ID     ${created_campaign_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title     ${forbidden_request_title}

TC_O2O_02124
    [Documentation]     Verify that API returns success when user trueyou admin has deactivate running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${TRUEYOU_ADMIN_USER}    ${TRUEYOU_ADMIN_PASSWORD}
    Update Campaign Status     ${created_campaign_id}    ${inactive_status}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value             status        ${inactive_status}

TC_O2O_03732
    [Documentation]     Verify that API returns success when user super admin has edited running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Update Campaign By ID       ${created_campaign_id}     ${campaign_customer_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}     ${start_date}    ${end_date}    ${active_status}
    Response Correct Code    ${SUCCESS_CODE}
    Get Campaign By ID       ${created_campaign_id}
    Response Should Contain Property With Value    group             ${update_campaign_group}
    Response Should Contain Property With Value    status            ${active_status}

TC_O2O_03733
    [Documentation]     Verify that API returns success when user super admin has deactivate running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Update Campaign Status     ${created_campaign_id}    ${inactive_status}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value             status        ${inactive_status}

TC_O2O_03734
    [Documentation]     Verify that API returns success when user super admin has deleted running campaign
    [Tags]     Campaign      Regression      High
    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Delete Campaign By ID     ${created_campaign_id}
    Response Correct Code    ${SUCCESS_CODE}