*** Settings ***
Documentation    Tests to verify that the "Kepp usage of user" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/campaign_promotion_usage_keywords.robot

# scopes: campaign.promotion.create,campaign.usage.create
Test Setup    Run Keywords    Generate Robot Automation Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
...    AND    Prepare Campaign For Test
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_04682
    [Documentation]    Verify that user cannot call API without "campaign.usage.create" scope
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Update Usage With New CampaignID   ${campaign_id}
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/usage
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_04683
    [Documentation]    Verify that user can call API with "campaign.usage.create" scope and correct params successfully
    [Tags]    BE-Campaign    RegressionExclude    High    Smoke
    Update Usage With New CampaignID    ${campaign_id}
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Keep Usage

TC_O2O_04684
    [Documentation]    Verify that user cannot call API with invalid CampaignID and correct other parameters
    [Tags]    BE-Campaign    RegressionExclude    High
    Update Usage With New CampaignID    ${123}
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    title    Data not found.
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/campaign-promotion-not-found
    Update Usage With New CampaignID    !123a@
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    title    Data not found.
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/campaign-promotion-not-found
    Update Usage With New CampaignID    ${EMPTY}
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    fieldErrors[0].field    campaignId
    Response Should Contain Property With Value    fieldErrors[0].message    NotEmpty
    Response Should Contain Property With Value    fieldErrors[0].objectName    campaignPromotionUsageDTO
    Response Should Contain Property Matches Regex    path    /api/promotions/usage
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation

TC_O2O_04689
    [Documentation]    Verify that user cannot call API with missing merchantID and correct other parameters
    [Tags]    BE-Campaign    RegressionExclude    High
    Update Usage With New CampaignID    ${campaign_id}
    Modify Dummy Data    $.merchantId    ${NULL}
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    fieldErrors[0].field    merchantId
    Response Should Contain Property With Value    fieldErrors[0].message    NotEmpty
    Response Should Contain Property With Value    fieldErrors[0].objectName    campaignPromotionUsageDTO
    Response Should Contain Property Matches Regex    path    /api/promotions/usage
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation

TC_O2O_04706
    [Documentation]    Verify that user cannot call API with if usageDate is not greater than startDate of Campaign Promotions
    [Tags]    BE-Campaign    RegressionExclude    High
    Update Usage With New CampaignID    ${campaign_id}
    Modify Dummy Data    $.usageDate    2019-12-01T07:47:41.287Z
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Usage date can not be before start date or after end date of the campaign promotion
    Response Should Contain Property With Value    entityName    campaign_promotion_usage
    Response Should Contain Property With Value    errorKey    usageDate.invalid
    Response Should Contain Property With Value    params    campaign_promotion_usage
    Response Should Contain Property With Value    message    error.usageDate.invalid
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_04707
    [Documentation]    Verify that user cannot call API with if usageDate is greater than endDate of Campaign Promotions
    [Tags]    BE-Campaign    RegressionExclude    High
    Update Usage With New CampaignID    ${campaign_id}
    Modify Dummy Data    $.usageDate    2019-01-12T07:47:41.287Z
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Usage date can not be before start date or after end date of the campaign promotion
    Response Should Contain Property With Value    entityName    campaign_promotion_usage
    Response Should Contain Property With Value    errorKey    usageDate.invalid
    Response Should Contain Property With Value    params    campaign_promotion_usage
    Response Should Contain Property With Value    message    error.usageDate.invalid
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message