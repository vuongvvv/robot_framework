*** Settings ***
Resource        ../../../keywords/rpp-mytruepoint/burnpoint_keywords.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot
Resource        ../../../resources/init.robot
Test Setup      Run Keywords    Create RPP Gateway Header    AND    Generate ID
Test Teardown    Delete All Sessions

*** Test Cases ***
TC_O2O_10304
    [Documentation]    Verification 'redeem by campaign' by "campaign_type":"CUSTOMER"
    [Tags]    ExcludeSmoke    Sanity    Regression   
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2054", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Number String    data.moreinfo.promotion_code 
    Post Void Burn     { "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "tx_ref_id":"${ID}", "action":"redeem_by_campaign" }
    Response Should Contain Property With Value    data.description    success

TC_O2O_10305
    [Documentation]    Verification 'redeem by campaign' by "campaign_type":"MERCHANT"
    [Tags]    ExcludeSmoke    Sanity    Regression    
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"MERCHANT", "campaign_code":"PRO-2054", "action":"redeem_by_campaign" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Number String    data.moreinfo.promotion_code
    Post Void Burn     { "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "tx_ref_id":"${ID}", "action":"redeem_by_campaign" }
    Response Should Contain Property With Value    data.description    success

TC_O2O_10306
    [Documentation]    Verification 'redeem by code' by "campaign_type":"CUSTOMER"    
    [Tags]    ExcludeSmoke    Sanity    Regression
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"1100001", "outlet_id":"01072", "terminal_id":"69000681", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2050", "action":"redeem_by_campaign" }
    Collect Promotion Code
    Generate ID
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"1100001", "outlet_id":"01072", "terminal_id":"69000681", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2050", "action":"redeem_by_code", "reward_code":${PROMOTION_CODE} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    data.service_desc    Truecard::mark_use
    Response Should Contain Property With Value    data.method    mark_use
    Response Should Contain Property With String Value    data.transaction_id
    Response Should Contain Property With Value    data.moreinfo.promotion_code    ${PROMOTION_CODE}
    Post Void Burn     { "brand_id":"1100001", "outlet_id":"01072", "terminal_id":"69000681", "tx_ref_id":"${VOID_TXREF}", "action":"redeem_by_campaign" }
    Response Should Contain Property With Value    data.description    success

TC_O2O_10307
    [Documentation]    Verification 'redeem by code' in case unsuccess by "campaign_type":"CUSTOMER"
    [Tags]    ExcludeSmoke    Sanity    Regression   
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2054", "action":"redeem_by_campaign" }
    Collect Promotion Code  
    Generate ID 
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"1100001", "outlet_id":"01072", "terminal_id":"69000681", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2050", "action":"redeem_by_code", "reward_code":${PROMOTION_CODE} }
    Generate ID
    Post Burn Point     { "tx_ref_id":"${ID}", "brand_id":"0020920", "outlet_id":"01072", "terminal_id":"69000681", "acc_type":"THAIID", "acc_value":"3901000393824", "campaign_type":"CUSTOMER", "campaign_code":"PRO-2050", "action":"redeem_by_code", "reward_code":${PROMOTION_CODE} }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    data.service_desc    Truecard::mark_use
    Response Should Contain Property With Value    data.method    mark_use
    Response Should Contain Property With Value    data.moreinfo.message    This promotion code :${promotion_code}, is not available to use or already used.
    Post Void Burn     { "brand_id":"0020920", "outlet_id":"00122", "terminal_id":"68000199", "tx_ref_id":"${VOID_TXREF}", "action":"redeem_by_campaign" }
    Response Should Contain Property With Value    data.description    success
    

