*** Settings ***
Documentation     To verify create, update, and delete campaign via Admintools

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/campaign/campaign_keywords.robot

Test Setup    Run keywords    Generate Gateway Header With Scope and Permission    ${MANAGE_CAMPAIGN_USERNAME}    ${MANAGE_CAMPAIGN_PASSWORD}    permission_name=campaign.campaign.actAsAdmin
...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test teardown    Run Keywords    Delete Created Client And User Group    AND    Clean Environment

*** Variables ***
${customer_type}    customer
${updated_customer_type}    merchant
${group}    QA_Test_Automate
${updated_group}    QA_Test_Automate_updated
${action}    Add More Campaign
${updated_action}    Automation Test Action
${spending_amount}    10
${point}    1
${minimum_spending}    10
${start_date}    2020-03-30
${end_date}    2030-01-30
${status}    ACTIVE
${daily_cap}    10000
${monthly_cap}    50000
${payment_method}    Alipay
${sort_column}    No.

*** Test Cases ***
TC_O2O_10514
    [Documentation]    Able to create, update, and delete campaign with "Alphabet & Numeric & Thai & Special chars" action
    [Tags]    Regression    Smoke    E2E    Robot    High
    Login Backoffice   ${MANAGE_CAMPAIGN_USERNAME}    ${MANAGE_CAMPAIGN_PASSWORD}
    Click the Hamburger Menu
    Navigate On Right Menu Bar    Campaign    Campaign
    Create Campaign    ${customer_type}    ${group}    ${action}    ${spending_amount}    ${point}    ${minimum_spending}    ${start_date}    ${end_date}    ${status}    ${daily_cap}    ${monthly_cap}    ${payment_method}
    Sort Campaigns Table    ${sort_column}
    Verify Data On Campaigns Table With Unique Input    ${group}    ${customer_type}    ${action}
    Click Campaign Status Of Campaign    ${group}
    Click Edit Button Of Campaign    ${group}
    Update Campaign    ${updated_customer_type}    ${updated_group}    ${updated_action}    ${spending_amount}    ${point}    ${minimum_spending}    ${start_date}    ${end_date}    ${status}    ${daily_cap}    ${monthly_cap}    ${payment_method}
    Verify Data On Campaigns Table With Unique Input    ${updated_group}    ${updated_customer_type}    ${updated_action}
    Click Campaign Status Of Campaign    ${updated_group}
    Delete Campaign    ${updated_group}
