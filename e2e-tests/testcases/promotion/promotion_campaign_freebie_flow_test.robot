*** Settings ***
Documentation   Given customers have amount of products in their cart
...             And campaign is matched with products in their cart
...             When customers submit to pay
...             Then customers should get free gifts equal with product's amount in their cart
Resource        ../../../api/resources/init.robot
Resource        ../../../api/keywords/common/dummy_data_common.robot
Resource        ../../../api/keywords/project/project_resource_keywords.robot
Resource        ../../../api/keywords/promotion/campaign_resource_keywords.robot
Resource        ../../../api/keywords/promotion/redemption_tx_resource_keywords.robot

Test Setup     Generate Gateway Header With Scope and Permission   ${ROLE_USER}    ${ROLE_USER_PASSWORD}    scope=proj.proj.w,proj.proj.r,camp.camp.w,camp.capm.r
Test Teardown  Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${create_campaign_freebie_json_data}    ../../../api/resources/testdata/promotion/create_campaign_freebie.json
${search_campaign_freebie_json_data}    ../../../api/resources/testdata/promotion/search_campaign_freebie.json
${redeem_campaign_freebie_json_data}    ../../../api/resources/testdata/promotion/redeem_campaign_freebie.json
${refCode}     TP00001
${project_name}    Freebie campaign Test
${project_code}    Freebie_campaign
${project_description}     Test for freebie campaign
${startDate}     1998-05-08T15:53:00Z

*** Test Cases ***
TC_O2O_09328
    [Documentation]  {API} create campaign incase: Resolve cart sku amount in action data
    [Tags]  Regression    Medium    E2E   Sanity
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.name   ${project_name}
    Response Should Contain Property With Value  $.code   ${project_code}
    Response Should Contain Property With Value  $.description    ${project_description}
    Get Created ProjectID From Response
    Read Json From File   ${create_campaign_freebie_json_data}
    Update Json Data     $.startDate   ${startDate}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value  $.name  FREE_GIFT 2019
    Response Should Contain Property With Value  $.description  FREE_GIFT 2019
    Response Should Contain Property With Value  $.startDate   ${startDate}
    Response Should Contain Property With Value  $.refCode   ${refCode}
    Response Should Contain Property With Value  $.projectId    ${project_id}
    Get Created CampaignID From Response

TC_O2O_09329
    [Documentation]  {API} search campaign incase: Resolve cart sku amount in action data
    [Tags]  Regression    Medium    E2E   Sanity
    Read Json From File   ${search_campaign_freebie_json_data}
    Post Search campaign   ${project_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     $.actions..campaign.name   FREE_GIFT 2019
    Response Should Contain Property With Value     $.actions..campaign.refCode   ${refCode}
    Response Should Contain Property With Value     $.actions..action.data..value    150.0

TC_O2O_09330
    [Documentation]  {API} To verify result and response when user redeems transaction incase: Resolve cart sku amount in action data
    [Tags]  Regression    High    E2E   Sanity
    Read Json From File    ${redeem_campaign_freebie_json_data}
    Post Redeem     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.campaignCode    ${refCode}
    Response Should Contain Property With Value    $.actionTxs..status    COMPLETE
    Response Should Contain Property With Value    $.actionTxs..then.data..value    150.0
    Response Should Contain Property With Value    $.actionTxs..then.data..note    exceed: 0.0

TC_O2O_09332
    [Documentation]  {API} To verify result and response when user redeems transaction incase: exceed quota limit
    [Tags]  Regression    High    E2E   Sanity
    Read Json From File    ${redeem_campaign_freebie_json_data}
    Post Redeem     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.campaignCode    ${refCode}
    Response Should Contain Property With Value    $.actionTxs..status    COMPLETE
    Response Should Contain Property With Value    $.actionTxs..then.data..value    50.0
    Response Should Contain Property With Value    $.actionTxs..then.data..note    exceed: 100.0
    Delete Campaign     ${campaign_id}      ${project_id}
    Delete Project      ${project_id}