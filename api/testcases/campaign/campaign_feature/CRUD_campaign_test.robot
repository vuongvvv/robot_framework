*** Settings ***
Documentation    Tests to verify that the campaign APIs is working properly
...              as expected. There are 4 methods that supported.
...              GET: Get the campaign detail and campaign list under groups
...              POST: Create new campaign
...              PUT: Update the campaign details
...              DELETE: Delete the campaign
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot

# user group: TrueYou Campaign Admin, TrueYou Campaign Super Admin
Suite Setup    Run Keywords    Generate Robot Automation Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
...    AND    Set Campaign Date Period
Suite Teardown    Delete All Sessions

*** Variables ***
${campaign_merchant_type}                   merchant
${campaign_customer_type}                   customer
${campaign_group}                           Default
${spending_amount}                          20000
${payment_id_1}                             1
${payment_id_2}                             2
${point}                                    5
${minimum_spending}                         2500
${daily_cap}                                200000
${monthly_cap}                              5000000
${status}                                   ACTIVE

${update_campaign_group}                    makro
${update_status}                            INACTIVE

*** Test Cases ***
TC_O2O_01754
    [Documentation]    [Campaign][API][CreateCampaign] Verify that customer campaign is created successfully with single paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id_1}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${CREATED_CODE}

TC_O2O_01733
    [Documentation]    [Campaign][API][UpdateCampaign] Verify that customer campaign is updated successfully with single paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Update Campaign By ID       ${created_campaign_id}     ${campaign_customer_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}     ${start_date}    ${end_date}    ${update_status}
    Response Correct Code    ${SUCCESS_CODE}
    Get Campaign By ID       ${created_campaign_id}
    Response Should Contain Property With Value    group             ${update_campaign_group}
    Response Should Contain Property With Value    status            ${update_status}
    [Teardown]      Delete Campaign By ID     ${created_campaign_id}

TC_O2O_01755
    [Documentation]    [Campaign][API][CreateCampaign] Verify that customer campaign is created successfully with multiple paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Create Campaign With Multiple Payment Method     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id_1}    ${payment_id_2}    ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}      ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${CREATED_CODE}

TC_O2O_01734
    [Documentation]    [Campaign][API][UpdateCampaign] Verify that customer campaign is updated successfully with multiple paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Update Campaign With Multiple Payment Method       ${created_campaign_id}     ${campaign_customer_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${payment_id_2}    ${point}    ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${update_status}
    Response Correct Code    ${SUCCESS_CODE}
    Get Campaign By ID       ${created_campaign_id}
    Response Should Contain Property With Value    group             ${update_campaign_group}
    Response Should Contain Property With Value    status            ${update_status}
    [Teardown]      Delete Campaign By ID     ${created_campaign_id}

TC_O2O_01756
    [Documentation]    [Campaign][API][CreateCampaign] Verify that merchant campaign is created successfully with single paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Create Campaign     ${campaign_merchant_type}   ${campaign_group}    ${spending_amount}     ${payment_id_1}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}     ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${CREATED_CODE}

TC_O2O_01735
    [Documentation]    [Campaign][API][UpdateCampaign] Verify that merchant campaign is updated successfully with single paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Update Campaign By ID      ${created_campaign_id}     ${campaign_merchant_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}      ${start_date}   ${end_date}     ${update_status}
    Response Correct Code    ${SUCCESS_CODE}
    Get Campaign By ID       ${created_campaign_id}
    Response Should Contain Property With Value    group             ${update_campaign_group}
    Response Should Contain Property With Value    status            ${update_status}
    [Teardown]      Delete Campaign By ID     ${created_campaign_id}

TC_O2O_01757
    [Documentation]    [Campaign][API][CreateCampaign] Verify that merchant campaign is created successfully with multiple paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Create Campaign With Multiple Payment Method     ${campaign_merchant_type}   ${campaign_group}    ${spending_amount}     ${payment_id_1}    ${payment_id_2}    ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}     ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${CREATED_CODE}

TC_O2O_01736
    [Documentation]    [Campaign][API][UpdateCampaign] Verify that merchant campaign is updated successfully with multiple paymentMethod via API
    [Tags]     Campaign      Regression      High      Smoke
    Update Campaign With Multiple Payment Method       ${created_campaign_id}     ${campaign_merchant_type}    ${update_campaign_group}   ${spending_amount}    ${payment_id_1}     ${payment_id_2}    ${point}    ${point}    ${minimum_spending}     ${daily_cap}    ${monthly_cap}    ${start_date}     ${end_date}     ${update_status}
    Response Correct Code    ${SUCCESS_CODE}
    Get Campaign By ID       ${created_campaign_id}
    Response Should Contain Property With Value    group             ${update_campaign_group}
    Response Should Contain Property With Value    status            ${update_status}

TC_O2O_01761
    [Documentation]    [Campaign][API][GetCampaignDetails] Request with user permission as campaign.campaign.actAsAdmin returns 200
    [Tags]     Campaign      Regression      High      Smoke
    Get Campaign By ID       ${created_campaign_id}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01773
    [Documentation]    [Campaign][API][GetCampaignList] Verify that API returns 200 when get campaign with customer type
    [Tags]     Campaign      Regression      High      Smoke
    Get All Campaign Under Customer Type     ${campaign_group}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01774
    [Documentation]    [Campaign][API][GetCampaignList] Verify that API returns 200 when get campaign with merchant type
    [Tags]     Campaign      Regression      High      Smoke
    Get All Campaign Under Merchant Type     ${campaign_group}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_01778
    [Documentation]    [Campaign][API][DeleteCampaign] Request with user permission as campaign.campaign.actAsAdmin returns 200
    [Tags]     Campaign      Regression      High      Smoke
    Delete Campaign By ID     ${created_campaign_id}
    Response Correct Code    ${SUCCESS_CODE}
