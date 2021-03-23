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
${create_campaign_freebie_selection_json_data}    ../../../api/resources/testdata/promotion/create_campaign_freebie_selection.json
${search_campaign_freebie_selection_json_data}    ../../../api/resources/testdata/promotion/search_campaign_freebie_selection.json
${redeem_campaign_freebie_selection_json_data}    ../../../api/resources/testdata/promotion/redeem_campaign_freebie_selection.json
${ref_code}     TP00001
${project_name}    Freebie campaign Test
${project_code}    Freebie_campaign
${project_description}     Test for freebie campaign
${start_date}     1998-05-08T15:53:00Z

*** Test Cases ***
TC_O2O_09731
    [Documentation]  {API} Search for matched campaign result incase: multiple rules
    [Tags]    Hawkeye2019S15  High  Regression  Sanity  E2E
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  id
    Response Should Contain Property With Value  name   ${project_name}
    Response Should Contain Property With Value  code   ${project_code}
    Response Should Contain Property With Value  description    ${project_description}
    Get Created ProjectID From Response
    Read Json From File   ${create_campaign_freebie_selection_json_data}
    Update Json Data     startDate   ${start_date}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value  name  FREE GIFT 2019
    Response Should Contain Property With Value  description  FREE GIFT 2019
    Response Should Contain Property With Value  startDate   ${start_date}
    Response Should Contain Property With Value  refCode   ${ref_code}
    Response Should Contain Property With Value  projectId    ${project_id}
    Get Created CampaignID From Response
    Read Json From File   ${search_campaign_freebie_selection_json_data}
    Post Search campaign   ${project_id}    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value     actions..campaign.name   FREE GIFT 2019
    Response Should Contain Property With Value     actions..campaign.refCode   ${ref_code}
    Response Should Contain Property With Value     actions..rule.name   Rule1
    Response Should Contain Property With Value     actions..rule.thenOperator   OR
    Response Should Contain Property With Value     actions..rule.name   Rule2
    Response Should Contain Property With Value     actions..rule.thenOperator   AND
    Response Should Contain Property With Value     actions..action.data..attribute  B001
    Response Should Contain Property With Value     actions..action.data..attribute  B002
    Response Should Contain Property With Value     actions..action.data..attribute  B003
    Response Should Contain Property With Value     actions..action.data..attribute  C001
    Get ActionRefs From Response

TC_O2O_09733
    [Documentation]  {API} Redeem when user pick 1 of choices for free items incase:  choose B
    [Tags]    Hawkeye2019S15  Medium  Regression  Sanity  E2E
    Read Json From File    ${redeem_campaign_freebie_selection_json_data}
    Update Json Data With Array    ${json_dummy_data}   actionRefs     ["${ACTION_REF_LIST[0]}"]
    Post Redeem     ${UPDATED_JSON}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[0]}

TC_O2O_09735
    [Documentation]  {API} Redeem when user select all incase: actionRef is blank
    [Tags]    Hawkeye2019S15  High  Regression  Sanity  E2E
    Read Json From File    ${redeem_campaign_freebie_selection_json_data}
    Post Redeem     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[0]}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[1]}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[2]}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[3]}

TC_O2O_09736
    [Documentation]  {API} Redeem when user pick 2 of choices for free items incase: multiple rule
    [Tags]    Hawkeye2019S15  High  Regression  Sanity  E2E
    Read Json From File    ${redeem_campaign_freebie_selection_json_data}
    Update Json Data With Array    ${json_dummy_data}   actionRefs     ["${ACTION_REF_LIST[1]}", "${ACTION_REF_LIST[3]}"]
    Post Redeem     ${UPDATED_JSON}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[1]}
    Response Should Contain Property With Value    actionTxs..then.actionRef    ${ACTION_REF_LIST[3]}
    Delete Campaign     ${campaign_id}      ${project_id}
    Response Correct Code    ${SUCCESS_CODE}
    Delete Project      ${project_id}
    Response Correct Code    ${SUCCESS_CODE}