*** Settings ***
Documentation    Tests to verify that the "Get Detail Campaign Promotions" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.promotion.detail
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation

*** Test Cases ***
TC_O2O_03735
    [Documentation]    Verify that user will get 403 when call Get Detail Campaign API if user does not have "campaign.promotion.detail" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get Detail Campaign Promotion    ${campaign_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/${campaign_id}
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03738
    [Documentation]    Verify that user will get  detail campaign promtion when call Get Detail Campaign API with [campaignId] exist on database and return code is 200
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Get Detail Campaign Promotion    ${campaign_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${campaign_id}
    Verify The Successful Response Of Add Campaign API    ${0}    ${json_dummy_data}    ${SUPER_ADMIN_USER}