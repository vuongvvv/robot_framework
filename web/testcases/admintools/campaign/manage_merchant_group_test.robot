*** Settings ***
Documentation     To verify create and update merchant group via Admintools

Resource    ../../../../api/resources/init.robot
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/web_common.robot
Resource    ../../../keywords/admintools/main_page/login_keywords.robot
Resource    ../../../keywords/admintools/campaign/merchant_group_keywords.robot

# permission_name=campaign.campaign.actAsAdmin,merchant.campaign.actAsAdmin
Test Setup    Run keywords    Generate Robot Automation Header    ${MANAGE_CAMPAIGN_USERNAME}    ${MANAGE_CAMPAIGN_PASSWORD}
...    AND    Open Browser With Option    ${ADMIN_TOOLS_URL}
Test teardown    Clean Environment

*** Test Cases ***
TC_O2O_04106
    [Documentation]    User can create a new merchant and update merchant group successfully
    [Tags]    Regression    Smoke    E2E    Robot    High
    Login Backoffice   ${MANAGE_CAMPAIGN_USERNAME}    ${MANAGE_CAMPAIGN_PASSWORD}
    Click the Hamburger Menu
    Navigate On Right Menu Bar    Campaign    Manage Merchant Group
    Create New Random Merchant Group
    Search Merchant Group    ${MERCHANT_GROUP_NAME}
    Verify Merchant Group Is Created Successfully    ${MERCHANT_GROUP_NAME}
    Update Merchant Groups
