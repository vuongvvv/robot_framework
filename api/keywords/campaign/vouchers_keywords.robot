*** Settings ***
Library    Collections
Resource    ../common/api_common.robot
Resource    promotions_keywords.robot

*** Keywords ***
Post Generate List Of Voucher Code
    [Arguments]    ${campaign_id}    ${voucher_data}=${json_dummy_data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}/${campaign_id}/vouchers    data=${voucher_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Verify Voucher
    [Arguments]    ${voucherCode}    ${verify_voucher_data}=${json_dummy_data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /campaign/api/promotions/vouchers/${voucherCode}/verify    data=${verify_voucher_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get List Campaign Promotion Vouchers
    [Arguments]    ${param_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${add_campaign_promotion_api}/vouchers    params=${param_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Extract BatchID From Response
    ${batch_id_list}=    Get Value From Json    ${RESP.json()}    $.batchId
    ${batch_id}=    Get From List    ${batch_id_list}    0
    Set Test Variable    ${batch_id}

Extract VoucherCode From Response
    ${voucherCode_list}=    Get Value From Json    ${RESP.json()[0]}    $.code
    ${voucherCode}=    Get From List    ${voucherCode_list}    0
    Set Test Variable    ${voucher_code}

Get Specific Voucher By Code
    [Arguments]    ${voucherCode}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /campaign/api/promotions/vouchers/${voucherCode}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Redeem Voucher
    [Arguments]    ${voucher_code}    ${redeem_voucher_data}=${json_dummy_data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /campaign/api/promotions/vouchers/${voucher_code}    data=${redeem_voucher_data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Verify The Response Of Redeem Voucher
    [Arguments]    ${json_dummy_data}    ${created_by_user}    ${voucher_type}=REGULAR
    Response Should Contain Property With Value    voucherDetail.code    ${voucher_code}
    Response Should Contain Property With Value    voucherDetail.status    ACTIVE
    Response Should Contain Property With Value    voucherDetail.campaignId    ${campaign_id}
    Response Should Contain Property With Value    voucherDetail.type    ${voucher_type}
    Response Should Contain Property With Value    voucherDetail.name    Tet_Holiday
    Response Should Contain Property With Value    voucherDetail.voucherGroup    TETVUI
    Response Should Contain Property With Value    voucherDetail.specificConsumerId    ${json_dummy_data["customerId"]}
    Response Should Contain Property Matches Regex    voucherDetail.lastModifiedDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property Matches Regex    voucherDetail.lastModifiedBy    ${created_by_user}
    Response Should Contain Property Matches Regex    voucherDetail.createdDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Response Should Contain Property Matches Regex    voucherDetail.createdBy    ${created_by_user}
    Response Should Contain Property With Value    voucherDetail.batchId    ${batch_id}
    Response Should Contain Property With Value    voucherDetail.used    ${TRUE}
    Response Should Contain Property Matches Regex    voucherDetail.id    \\w{24}
    Response Should Contain Property With Value    status    REDEEM_SUCCESS
    Run Keyword If    '${voucher_type}' == 'COLLECTION'    Response Should Contain Property Matches Regex    voucherDetail.collectibleStartDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z
    Run Keyword If    '${voucher_type}' == 'COLLECTION'    Response Should Contain Property Matches Regex    voucherDetail.collectibleEndDate    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(|\\.\\d{0,3})Z

Prepare Vouchers For Test
    [Arguments]    ${data_file}=${dummy_data_file}    ${voucher_dummy_data_file}=${regular_voucher_dummy_data_file}
    Prepare Campaign For Test    ${data_file}
    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.create
    Read Dummy Json From File    ${voucher_dummy_data_file}
    ${today}=    Run Keyword If    'collectible' in $voucher_dummy_data_file   Get Current Date
    ${redeemable_start_date}=    Run Keyword If    'collectible' in $voucher_dummy_data_file    Subtract Time From Date    ${today}    1 day    result_format=%Y-%m-%dT%H:%M:%SZ
    ${redeemable_end_date}=    Run Keyword If    'collectible' in $voucher_dummy_data_file    Subtract Time From Date    ${today}    -7 days    result_format=%Y-%m-%dT%H:%M:%SZ
    Run Keyword If    'collectible' in $voucher_dummy_data_file    Modify Dummy Data    $.redeemableStartDate    ${redeemable_start_date}
    Run Keyword If    'collectible' in $voucher_dummy_data_file    Modify Dummy Data    $.redeemableEndDate    ${redeemable_end_date}
    Post Generate List Of Voucher Code    ${campaign_id}
    Response Correct Code    ${CREATED_CODE}
    Extract BatchID From Response
    Delete Created Client And User Group
    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.voucher.list
    Get List Campaign Promotion Vouchers    batchId=${batch_id}
    Extract VoucherCode From Response
    Delete Created Client And User Group

Verify The Response Of Verify Voucher
    [Arguments]    ${benefit_type}    ${item_id}    ${voucher_type}=REGULAR
    Response Should Contain Property With Value    benefit.data[0].type    ${benefit_type}
    Response Should Contain Property With Value    benefit.data[0].itemData.items[0].id    ${item_id}
    Response Should Contain Property With Value    status    REDEEMABLE
    Response Should Contain Property With Value    benefit.data[0].itemData.items[0].quantity    ${1}
    Response Should Contain Property With Value    benefit.data[0].itemData.option    OR
    Response Should Contain Property With Value    benefit.option    AND
    Response Should Contain Property With Value    errorMessage    ${NULL}