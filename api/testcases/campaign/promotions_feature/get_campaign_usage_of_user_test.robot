*** Settings ***
Documentation    Tests to verify that the "Get campaign usage of user" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Resource    ../../../keywords/campaign/campaign_promotion_usage_keywords.robot
Test Setup    Run Keywords    Prepare Usage For Get Usage Data Testing    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.usage.list
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_04822
    [Documentation]    Verify that user cannot get the campaign usage by user without scope "campaign.usage.list"
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Usage For Get Usage Data Testing    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get List Campaign Promotion Usages
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/usages
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_04823
    [Documentation]    Verify that user can get the campaign usage by user with valid customerId, campaignId and merchantId
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion Usages    campaignId=${campaign_id}&customerId=C001&merchantId=merchant_001
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .campaignId    ${campaign_id}
    Response Should Contain All Property Values Equal To Value    .customerId    C001
    Response Should Contain All Property Values Equal To Value    .merchantId    merchant_001
    Get List Campaign Promotion Usages    campaignId=${123}&customerId=ABC&merchantId=merchant_iris_abc
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty