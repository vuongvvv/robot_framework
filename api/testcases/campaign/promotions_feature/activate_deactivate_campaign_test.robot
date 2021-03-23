*** Settings ***
Documentation    Tests to verify that the campaign status can be activated/deactivated accordingly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Run Keywords    Prepare Campaign For Test    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.promotion.update
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Test Cases ***
TC_O2O_04594
    [Documentation]    Verify that user can activate the status of any campaign (status = DISABLE) when calling update Campaign API if user has "campaign.promotion.update" scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High
    Modify Dummy Data    $.status    DISABLE
    Update Campaign Promotion Status    ${campaign_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_dummy_data}    ${SUPER_ADMIN_USER}

TC_O2O_04600
    [Documentation]    Verify that user can deactivate the status of any campaign (status = ENABLE) when calling update Campaign API if user has correct scope
    [Tags]    BE-CampaignPromotion    RegressionExclude    High    SmokeExclude
    Modify Dummy Data    $.status    DISABLE
    Update Campaign Promotion Status    ${campaign_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${1}    ${json_dummy_data}    ${SUPER_ADMIN_USER}
    Modify Dummy Data    $.status    ENABLE
    Update Campaign Promotion Status    ${campaign_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Verify The Successful Response Of Add Campaign API    ${2}    ${json_dummy_data}    ${SUPER_ADMIN_USER}