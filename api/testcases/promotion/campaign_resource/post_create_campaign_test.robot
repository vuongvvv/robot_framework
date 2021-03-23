*** Settings ***
Documentation    Tests to verify that create campaign api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/project/project_resource_keywords.robot
Resource    ../../../keywords/promotion/campaign_resource_keywords.robot

Test Setup    Generate Gateway Header With Scope and Permission   ${PROMOTION_USERNAME}    ${PROMOTION_PASSWORD}    scope=camp.camp.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${create_campaign_gencoupon_json_data}    ../../../api/resources/testdata/promotion/create_campaign_gencoupon.json
${create_campaign_usecoupon_json_data}    ../../../api/resources/testdata/promotion/create_campaign_usecoupon.json
${refcode_length}    12
${customerId_length}   10
${refCode_usecoupon}   usecoupon4
${project_name}    Test campaign
${project_code}    Test_campaign
${project_description}     Test for Campaign

*** Test Cases ***
TC_O2O_07087
    [Documentation]  To verify response and result when user create campaign by API
    [Tags]    Regression    High    Smoke
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Get Created ProjectID From Response
    ${refCode} =	Generate Random String	${refcode_length}
    Read Json From File   ${create_campaign_gencoupon_json_data}
    Update Json Data     $.refCode   ${refCode}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value  $.name  gencoupon
    Response Should Contain Property With Value  $.description  generate coupon
    Response Should Contain Property With Value  $.startDate   2019-03-30T17:00:00Z
    Response Should Contain Property With Value  $.endDate    2030-12-31T16:59:00Z
    Response Should Contain Property With Value  $.refCode   ${refCode}
    Response Should Contain Property With Value  $.projectId    ${project_id}
    Get Created Gencoupon CampaignID From Response
    Delete Campaign    ${gen_campaign_id}  ${project_id}
    Delete Project  ${project_id}

TC_O2O_07088
    [Documentation]  To verify response and result when user create campaign incase: duplicate refcode
    [Tags]    Regression    High
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Get Created ProjectID From Response
    ${refCode} =	Generate Random String	${refcode_length}
    Read Json From File   ${create_campaign_gencoupon_json_data}
    Update Json Data     $.refCode   ${refCode}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Get Created Campaign RefCode From Response
    Get Created Gencoupon CampaignID From Response
    Update Json Data     $.refCode   ${campaign_refcode}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Delete Campaign    ${gen_campaign_id}  ${project_id}
    Delete Project  ${project_id}