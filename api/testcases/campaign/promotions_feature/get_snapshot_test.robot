*** Settings ***
Documentation    Tests to verify that the "Get Snapshot By Campaign ID and Version" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.snapshot.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation

*** Test Cases ***
TC_O2O_05093
    [Documentation]    Verify that user will get 403 when call Get Snapshot By Campaign ID and Version if user does not have "campaign.snapshot.read" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get Specific Promotion Snapshot By Campaign Promotion Id And Version    ${campaign_id}    ${version}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/snapshots
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_05094
    [Documentation]    Verify that user can call API successfully to get snapshot with scope, correct campaignID and correct version
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Get Specific Promotion Snapshot By Campaign Promotion Id And Version    ${campaign_id}    ${version}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    campaignPromotionId    ${campaign_id}
    Verify The Successful Response Of Add Campaign API    ${version}    ${json_dummy_data}    ${SUPER_ADMIN_USER}    ${TRUE}