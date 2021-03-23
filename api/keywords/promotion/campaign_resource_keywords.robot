*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    ../common/json_common.robot

*** Variables ***
${create_campaign_url}   /promotion/api/projects

*** Keywords ***
Post Create Campaign
    [Arguments]    ${data}  ${project_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_url}/${project_id}/campaigns    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Delete Campaign
    [Arguments]    ${id}  ${project_id}
    ${RESP}=    Delete Request    ${GATEWAY_SESSION}    ${create_campaign_url}/${project_id}/campaigns/${id}      headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Search Campaign
    [Arguments]   ${project_id}  ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_url}/${project_id}/search    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Gencoupon CampaignID From Response
    ${gen_campaign_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${gen_campaign_id}=    Get From List    ${gen_campaign_id_list}    0
    Set Suite Variable    ${gen_campaign_id}

Get Created Usecoupon CampaignID From Response
    ${use_campaign_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${use_campaign_id}=    Get From List    ${use_campaign_id_list}    0
    Set Suite Variable    ${use_campaign_id}

Get Created CampaignID From Response
    ${campaign_id_list}=    Get Value From Json    ${RESP.json()}    $.id
    ${campaign_id}=    Get From List    ${campaign_id_list}    0
    Set Suite Variable    ${campaign_id}

Get ActionRefs From Response
    ${ACTION_REF_LIST}=     Get Value From Json    ${RESP.json()}   $.actions..action.actionRef
    Set Suite Variable    ${ACTION_REF_LIST}

Get Search Coupon
    [Arguments]   ${data}  ${project_id}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${create_campaign_url}/${project_id}/search    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created Campaign RefCode From Response
    ${campaign_refcode_list}=    Get Value From Json    ${RESP.json()}    $.refCode
    ${campaign_refcode}=    Get From List    ${campaign_refcode_list}   0
    Set Suite Variable    ${campaign_refcode}

Get All Campaigns
    [Arguments]    ${project_id}  ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}     ${create_campaign_url}/${project_id}/campaigns  params=${params_uri}   headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Created LastModifiedDate From Response
    ${last_Modified_date_list}=    Get Value From Json    ${RESP.json()}    $..lastModifiedDate
    ${LAST_MODIFIED_DATE}=    Get From List    ${last_Modified_date_list}    0
    Set Suite Variable    ${LAST_MODIFIED_DATE}

Generate CustomerId
    [Arguments]   ${customer_id_length}
    ${CUSTOMER_ID} =	Generate Random String	${customer_id_length}  [NUMBERS]
    Set Test Variable   ${CUSTOMER_ID}