*** Settings ***
Library    Collections
Library    JSONLibrary
Resource    ../common/api_common.robot
Resource    ../common/gateway_common.robot

*** Variables ***
${dummy_data_file}    ../../resources/testdata/component/feature/campaign/campaign_promotions_data.json
${dummy_update_data_file}    ../../resources/testdata/component/feature/campaign/update_campaign_promotions_data.json
${quantity_dummy_data_file}    ../../resources/testdata/component/feature/campaign/quantity_campaign_promotions_data.json
${add_campaign_promotion_api}    /campaign/api/promotions

*** Keywords ***
Read Dummy Json From File
    [Arguments]    ${data_file}=${dummy_data_file}
    ${dummy_data_file_path}=     Catenate    SEPARATOR=/    ${CURDIR}    ${data_file}
    ${json_dummy_data}=    Load JSON From File    ${dummy_data_file_path}
    Set Test Variable    ${json_dummy_data}

Read Update Dummy Json From File
    ${dummy_data_file_path}=     Catenate    SEPARATOR=/    ${CURDIR}    ${dummy_update_data_file}
    ${json_update_dummy_data}=    Load JSON From File    ${dummy_data_file_path}
    Set Test Variable    ${json_update_dummy_data}

Modify Dummy Data
    [Arguments]    ${json_path}    ${value}
    ${json_dummy_data}=    Update Value To Json    ${json_dummy_data}    ${json_path}    ${value}
    Set Test Variable    ${json_dummy_data}

Add Campaign Promotion
    [Arguments]    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Extract CampaignID From Response
    ${campaign_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${campaign_id}=    Get From List    ${campaign_id_list}    0
    Set Test Variable    ${campaign_id}

Extract Campaign Version From Response
    ${version_list}=    Get Value From Json    ${RESP.json()}    $.version
    ${version}=    Get From List    ${version_list}    0
    Set Test Variable    ${version}

Get Detail Campaign Promotion
    [Arguments]    ${campaign_id}
    ${get_campaign_detail_url}=    Catenate    SEPARATOR=/    ${add_campaign_promotion_api}    ${campaign_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${get_campaign_detail_url}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Update Campaign Promotion
    [Arguments]    ${campaign_id}    ${json_data}
    ${full_api_update}=    Catenate    SEPARATOR=/    ${add_campaign_promotion_api}    ${campaign_id}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${full_api_update}    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Update Campaign Promotion Status
    [Arguments]    ${campaign_id}    ${json_data}
    ${full_api_update}=    Catenate    SEPARATOR=/    ${add_campaign_promotion_api}    ${campaign_id}    status
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    ${full_api_update}    data=${json_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get List Campaign Promotion
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Read Quantity Dummy Json From File
    [Documentation]    Read Quantity Dummy Json From File
    ${dummy_data_file_path}=     Catenate    SEPARATOR=/    ${CURDIR}    ${quantity_dummy_data_file}
    ${json_quantity_dummy_data}=    Load JSON From File    ${dummy_data_file_path}
    Set Test Variable    ${json_quantity_dummy_data}

Get Specific Promotion Snapshot By Campaign Promotion Id And Version
    [Arguments]    ${campaign_id}    ${version}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /campaign/api/promotions/snapshots?campaignPromotionId=${campaign_id}&version=${version}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Verify The Successful Response Of Add Campaign API
    [Arguments]    ${version}    ${json_dummy_data}    ${created_by_user}    ${is_snapshot}=${FALSE}
    Response Should Contain Property With Value    status    ${json_dummy_data["status"]}
    Response Should Contain Property Matches Regex    startDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property Matches Regex    endDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property With Value    name    ${json_dummy_data["name"]}
    Response Should Contain Property With Value    platform    ${json_dummy_data["platform"]}
    Response Should Contain Property With Value    maximumUsePerUser    ${json_dummy_data["maximumUsePerUser"]}
    Response Should Contain Property Matches Regex    lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property With Value    campaignData    ${NONE}
    Response Should Contain Property With Value    image    ${NONE}
    Response Should Contain Property With Value    lastModifiedBy    ${created_by_user}
    Response Should Contain Property With Value    externalCampaignId    ${NONE}
    Response Should Contain Property With Value    version    ${version}
    Response Should Contain Property With Value    createdBy    ${created_by_user}
    Response Should Contain Property Matches Regex    createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property With Value    type    ${json_dummy_data["type"]}
    Response Should Contain Property With Value    description    ${NONE}
    Run Keyword If    '${is_snapshot}' == '${FALSE}'    Response Should Contain Property Matches Regex    id    \\w{24}
    Response Should Contain Property With Value    financing[0].type    ${json_dummy_data["financing"][0]["type"]}
    Response Should Contain Property With Value    financing[0].name    ${json_dummy_data["financing"][0]["name"]}
    Response Should Contain Property With Value    financing[1].type    ${json_dummy_data["financing"][1]["type"]}
    Response Should Contain Property With Value    financing[1].name    ${json_dummy_data["financing"][1]["name"]}
    Response Should Contain Property With Value    financing[2].type    ${json_dummy_data["financing"][2]["type"]}
    Response Should Contain Property With Value    financing[2].name    ${json_dummy_data["financing"][2]["name"]}
    Response Should Contain Property With Value    participants[0].merchantId    ${json_dummy_data["participants"][0]["merchantId"]}
    Response Should Contain Property With Value    participants[0].outletId    ${json_dummy_data["participants"][0]["outletId"]}
    Response Should Contain Property With Value    participants[0].terminalId    ${json_dummy_data["participants"][0]["terminalId"]}
    Response Should Contain Property With Value    participants[1].merchantId    ${json_dummy_data["participants"][1]["merchantId"]}
    Response Should Contain Property With Value    participants[1].outletId    ${json_dummy_data["participants"][1]["outletId"]}
    Response Should Contain Property With Value    participants[1].terminalId    ${json_dummy_data["participants"][1]["terminalId"]}
    Response Should Contain Property With Value    rules[0].onTopPromotionPrice    ${json_dummy_data["rules"][0]["onTopPromotionPrice"]}
    Response Should Contain Property With Value    rules[0].isFeatured    ${json_dummy_data["rules"][0]["isFeatured"]}
    Response Should Contain Property With Value    rules[0].trigger.option    ${json_dummy_data["rules"][0]["trigger"]["option"]}
    Response Should Contain Property With Value    rules[0].trigger.exclusions[0].level    ${json_dummy_data["rules"][0]["trigger"]["exclusions"][0]["level"]}
    Response Should Contain Property With Value    rules[0].trigger.exclusions[0].items    ${json_dummy_data["rules"][0]["trigger"]["exclusions"][0]["items"]}
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].level    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["level"]}
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].type    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["type"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["type"]}' != 'COUPON'    Response Should Contain Property With Value    rules[0].trigger.criteria[0].spending    ${NONE}    ELSE    Response Should Not Contain Property    rules[0].trigger.criteria[0].spending
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].itemData.option    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["itemData"]["option"]}
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].itemData.items    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["itemData"]["items"]}
    Response Should Contain Property With Value    rules[0].benefit.option    ${json_dummy_data["rules"][0]["benefit"]["option"]}
    Response Should Contain Property With Value    rules[0].benefit.data[0].type    ${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}
    Response Should Contain Property With Value    rules[0].benefit.data[0].level    ${json_dummy_data["rules"][0]["benefit"]["data"][0]["level"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'FREE_ITEM'    Response Should Contain Property With Value    rules[0].benefit.data[0].itemData    ${json_dummy_data["rules"][0]["benefit"]["data"][0]["itemData"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'FREE_ITEM'    Response Should Not Contain Property    rules[0].benefit.data[0].amount
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'FREE_ITEM'    Response Should Not Contain Property    rules[0].benefit.data[0].discountType
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'DISCOUNT'    Response Should Contain Property With Value    rules[0].benefit.data[0].amount    ${json_dummy_data["rules"][0]["benefit"]["data"][0]["amount"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'DISCOUNT'    Response Should Contain Property With Value    rules[0].benefit.data[0].discountType    ${json_dummy_data["rules"][0]["benefit"]["data"][0]["discountType"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["benefit"]["data"][0]["type"]}' == 'DISCOUNT'    Response Should Not Contain Property    rules[0].benefit.data[0].itemData
    Run Keyword If    '${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["type"]}' == 'COUPON'    Response Should Contain Property With Value    rules[0].trigger.criteria[0].couponGroup    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["couponGroup"]}
    Run Keyword If    '${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["type"]}' == 'COUPON'    Response Should Contain Property With Value    rules[0].trigger.criteria[0].minAmount    ${json_dummy_data["rules"][0]["trigger"]["criteria"][0]["minAmount"]}

Prepare Campaign For Test
    [Arguments]    ${data_file}=${dummy_data_file}
    Read Dummy Json From File    ${data_file}
    Add Campaign Promotion    ${json_dummy_data}
    Extract CampaignID From Response
    Extract Campaign Version From Response