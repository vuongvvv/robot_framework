*** Settings ***
Documentation    Tests to verify that the update campaign status APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot
Suite Setup     Prepare Test Suite Data
Test Setup          Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
Test Teardown       Delete All Sessions

*** Variables ***
${campaign_merchant_type}            merchant
${campaign_customer_type}            customer
${campaign_group}                    university
${spending_amount}                   20000
${payment_id}                        1
${point}                             5
${minimum_spending}                  2500
${daily_cap}                         200000
${monthly_cap}                       5000000
${active_status}                     ACTIVE
${inactive_status}                   INACTIVE
${invalid_status}                    ACTIVATE
${bad_request_title}                 Bad Request

*** Keywords ***
Prepare Test Suite Data
    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Set Campaign Date Period
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${active_status}

*** Test Cases ***
TC_O2O_02111
    [Documentation]    Verify that API return success when updated status from "ACTIVE" to "INACTIVE"
    [Tags]     E-Stamp      Regression      High
    Update Campaign Status     ${created_campaign_id}    ${inactive_status}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value             status        ${inactive_status}

TC_O2O_02112
    [Documentation]    Verify that API return success when updated status from "INACTIVE" to "ACTIVE"
    [Tags]     E-Stamp      Regression      High
    Update Campaign Status     ${created_campaign_id}    ${active_status}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value             status        ${active_status}

TC_O2O_02113
    [Documentation]    Verify that API return error when updated status invalid camapagin status
    [Tags]     E-Stamp      Regression      Medium
    Update Campaign Status     ${created_campaign_id}   ${invalid_status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value             title          ${bad_request_title}
    [Teardown]      Delete Campaign By ID     ${created_campaign_id}
