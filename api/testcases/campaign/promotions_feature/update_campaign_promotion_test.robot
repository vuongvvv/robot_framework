*** Settings ***
Documentation    Tests to verify that the "Update Campaign Promotions" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot

# scope: campaign.promotion.update
Test Setup    Run Keywords    Generate Robot Automation Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
...    AND    Prepare Campaign For Test
Test Teardown    Delete All Sessions

*** Variables ***
${method_not_allowed_title}    Method Not Allowed
${bad_request_title}    Bad Request
${constraint_violation_title}    Constraint Violation

*** Test Cases ***
TC_O2O_03842
    [Documentation]    Verify that user will get 403 when calling update Campaign API if user does not have "campaign.promotion.update" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    [Setup]    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Read Update Dummy Json From File
    Update Campaign Promotion    ${campaign_id}    ${json_update_dummy_data}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property With Value    path    /api/promotions/${campaign_id}
    Response Should Contain Property With Value    message    error.http.403
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03843
    [Documentation]    Verify that user can update the campaign successfully when calling update Campaign API with correct name, correct type, correct platform, correct start date, correct end date
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    Smoke
    Read Update Dummy Json From File
    Update Campaign Promotion    ${campaign_id}    ${json_update_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_update_dummy_data}    ${SUPER_ADMIN_USER}

TC_O2O_04670
    [Documentation]    Verify that API can update FREEBIE campaign promotions with QUANTITY Campaign successfully
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Read Quantity Dummy Json From File
    Update Campaign Promotion    ${campaign_id}    ${json_quantity_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_quantity_dummy_data}    ${SUPER_ADMIN_USER}

TC_O2O_04671
    [Documentation]    Verify that API can update COMBO campaign promotions with QUANTITY Campaign successfully
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Read Quantity Dummy Json From File
    Update Campaign Promotion    ${campaign_id}    ${json_quantity_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_quantity_dummy_data}    ${SUPER_ADMIN_USER}

TC_O2O_05857
    [Documentation]    Verify that we can add the campaign promotions with campaign type = "COUPON" and trigger type = "COUPON"
    [Tags]    BE-Campaign    RegressionExclude    High
    Modify Dummy Data    $.type    COUPON
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    COUPON
    Modify Dummy Data    $.rules[0].trigger.criteria[0].couponGroup    TETVUI
    Modify Dummy Data    $.rules[0].trigger.criteria[0].minAmount    ${1000}
    Update Campaign Promotion    ${campaign_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_dummy_data}    ${SUPER_ADMIN_USER}
