*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    promotions_keywords.robot

*** Variables ***
${usage_campaign_promotion_api}    /campaign/api/promotions/usages
${dummy_usage_data_file}    ../../resources/testdata/component/feature/campaign/campaign_promotion_usage_data.json
${void_mark_use_dummy_data_file}    ../../resources/testdata/component/feature/campaign/void_mark_use_data.json

*** Keywords ***
Keep Track Campaign Usage By User
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${usage_campaign_promotion_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Read Dummy Json Of Usage
    Read Dummy Json From File    ${dummy_usage_data_file}
    Set Test Variable    ${json_dummy_data}

Update Usage With New CampaignID
    [Arguments]    ${campaign_id}
    Read Dummy Json Of Usage
    Modify Dummy Data    $.campaignId    ${campaign_id}
    Set Test Variable    ${json_dummy_data}

Get List Campaign Promotion Usages
    [Arguments]    ${get_list_usage_params}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${usage_campaign_promotion_api}    params=${get_list_usage_params}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Prepare Usage For Get Usage Data Testing
    Prepare Campaign For Test
    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.usage.create
    Read Dummy Json From File    ${dummy_usage_data_file}
    Modify Dummy Data    $.campaignId    ${campaign_id}
    Modify Dummy Data    $.merchantId    merchant_001
    Keep Track Campaign Usage By User    ${json_dummy_data}
    Response Correct Code    ${SUCCESS_CODE}
    ${usage_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${usage_id}=    Get From List    ${usage_id_list}    0
    Set Test Variable    ${usage_id}
    Delete Created Client And User Group

Prepare Usage For Void Mark Use Testing
    Prepare Usage For Get Usage Data Testing
    Read Dummy Json From File    ${void_mark_use_dummy_data_file}

Put Update Status
    [Arguments]    ${usage_id}    ${json_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /campaign/api/promotions/usages/${usage_id}/status    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Verify The Successful Response Of Keep Usage
    Response Should Contain Property With Value    status    SUCCESS
    Response Should Contain Property With Value    orderId    ${json_dummy_data["orderId"]}
    Response Should Contain Property With Value    campaignId    ${campaign_id}
    Response Should Contain Property Matches Regex    id    \\w{24}
    Response Should Contain Property With Value    campaignVersion     ${version}
    Response Should Contain Property With Value    customerId    ${json_dummy_data["customerId"]}
    Response Should Contain Property With Value    reason    ${NONE}
    Response Should Contain Property With Value    usageDate    ${json_dummy_data["usageDate"]}
    Response Should Contain Property With Value    usageData    ${json_dummy_data["usageData"]}
    Response Should Contain Property With Value    merchantId    ${json_dummy_data["merchantId"]}
    Response Should Contain Property With Value    channel    ${json_dummy_data["channel"]}