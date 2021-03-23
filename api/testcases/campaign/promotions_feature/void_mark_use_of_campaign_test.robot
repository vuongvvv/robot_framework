*** Settings ***
Documentation    Tests to verify that the "Void mark use of usage" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/campaign_promotion_usage_keywords.robot
Test Setup    Run Keywords    Prepare Usage For Void Mark Use Testing    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.usage.update
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_05476
    [Documentation]    Verify that user cannot call API without "campaign.usage.update" scope
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Usage For Void Mark Use Testing    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Put Update Status    ${usage_id}    ${json_dummy_data}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions/usage
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_05477
    [Documentation]    Verify that user can call API to void mark use of campaign with correct usageId, status and reason
    [Tags]    BE-Campaign    RegressionExclude    High
    Put Update Status    ${usage_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    VOID
    Response Should Contain Property With Value    reason    I don't like it
    Response Should Contain Property With Value    orderId    WL122
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    id    \\w{24}
    Response Should Contain Property With Value    campaignVersion    ${version}
    Response Should Contain Property With Value    customerId    C001
    Response Should Contain Property Matches Regex    usageDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property With Value    usageData.currency    bath
    Response Should Contain Property With Value    usageData.quantity    ${1}
    Response Should Contain Property With Value    usageData.usageType    PURCHASE
    Response Should Contain Property With Value    usageData.skus[0]    sku01
    Response Should Contain Property With Value    usageData.skus[1]    sku02
    Response Should Contain Property With Value    usageData.spentAmount    ${50}
    Response Should Contain Property With Value    merchantId    merchant_001
    Response Should Contain Property With Value    channel    TSM
