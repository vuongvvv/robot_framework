*** Settings ***
Resource        ../../../resources/init.robot
Resource        ../../../keywords/rpp_point/earn_point_keywords.robot
Resource        ../../../keywords/common/rpp_gateway_common.robot
Test Setup      Run Keywords    Create RPP Gateway Header    AND    Generate ID
Test Teardown    Run Keywords    Delete All Sessions

*** Variables ***
${account_value}    1609900120992

*** Test Cases ***
TC_O2O_10309
    [Documentation]   Verification earn Point by 'tx_ref_id' doesn't use yet and IS_LIMIT = 0
    [Tags]    Smoke    Regression
    Generate AccountId
    Post Api Earn Point     { "terminal_id":"${TERMINAL_ID}", "brand_id":"${BRAND_ID}", "outlet_id":"${BRANCH_ID}", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":"${ACCOUNTID}", "sale_amt":"20" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.rpp_ref_id
    Response Should Contain Property With String Value    data.timestamp
    Response Should Contain Property With Value    data.point    ${0}
    Response Should Contain Property With Value    data.sale_cal_point    ${20}
    Response Should Contain Property With Value    tx_ref_id    ${ID}
    Response Should Contain Property With Value    total    ${1} 

TC_O2O_10310
    [Documentation]   Verification earn Point by 'tx_ref_id' already use, 'sale_amt' change to a new one and IS_LIMIT = 0
    [Tags]    Regression
    Post Api Earn Point     { "terminal_id":"69000153", "brand_id":"1100001", "outlet_id":"00153", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":"9890", "sale_amt":"20640" }
    Post Api Earn Point     { "terminal_id":"69000153", "brand_id":"1100001", "outlet_id":"00153", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":"9890", "sale_amt":"2000" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.rpp_ref_id
    Response Should Contain Property With String Value    data.timestamp
    Response Should Contain Property With Value    data.point    ${688}
    Response Should Contain Property With Value    data.sale_cal_point    20640
    Response Should Contain Property With Value    tx_ref_id    ${ID}        
    Response Should Contain Property With Value    total    ${1} 

TC_O2O_10311 
    [Documentation]   Verification earn Point by 'tx_ref_id' doesn't use yet and IS_LIMIT = 1 by condition : "sale_amt" more than "sale_cal_point" 
    [Tags]    Regression
    Post Api Earn Point     { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":${ID}, "sale_amt":"56890" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.rpp_ref_id
    Response Should Contain Property With String Value    data.timestamp
    Response Should Contain Property With Value    data.point    ${400}
    Response Should Contain Property With Value    data.sale_cal_point    ${10000}
    Response Should Contain Property With Value    tx_ref_id    ${ID}        
    Response Should Contain Property With Value    total    ${1} 
    Post Void Earn Point    { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":"${ID}", "rpp_ref_id":"${RESP.json()['data']['rpp_ref_id']}" }

TC_O2O_10312
    [Documentation]   Verification earn Point by 'tx_ref_id' doesn't use yet and IS_LIMIT = 1 by the system has to return an error msg should be "Customer already got maximun point"
    [Tags]    Regression
    Generate AccountId
    Post Api Earn Point     { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":${ACCOUNTID}, "sale_amt":"56890" }
    Set Variable For Void    ${ID}    ${RESP.json()['data']['rpp_ref_id']}
    Generate ID
    Post Api Earn Point     { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":${ACCOUNTID} , "sale_amt":"56890" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    0714
    Response Should Contain Property With Value    status.message    POINT EXCEED
    Response Should Contain Property With Value    errors.[0].message    Customer already got maximun point
    Post Void Earn Point    { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":"${TXREFIDVOID}", "rpp_ref_id":"${RPPREFIDVOID}" }

TC_O2O_10313 
    [Documentation]   Verification earn Point by 'tx_ref_id' already used and IS_LIMIT = 1 by condition : displaying the same value as "point" and 'sale_cal_point' at that 'tx_ref_id'
    [Tags]    Regression
    Generate AccountId
    Post Api Earn Point     { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":${ID} , "acc_type":"THAIID", "acc_value":${ACCOUNTID}, "sale_amt":"56890" }
    Generate AccountId
    Post Api Earn Point     { "terminal_id":"69000050", "brand_id":"1100001", "outlet_id":"00050", "tx_ref_id":${ID}, "acc_type":"THAIID", "acc_value":${ACCOUNTID}, "sale_amt":"56890" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.rpp_ref_id
    Response Should Contain Property With String Value    data.timestamp
    Response Should Contain Property With Value    data.point    ${400}
    Response Should Contain Property With Value    data.sale_cal_point    10000
    Response Should Contain Property With Value    tx_ref_id    ${ID}
    Response Should Contain Property With Value    total    ${1}
    
TC_O2O_10314
    [Documentation]   Verification earn Point by 'tx_ref_id' doesn't use yet in case 'sale_amt' is invalid
    [Tags]    Regression
    Post Api Earn Point     { "terminal_id":"69000153", "brand_id":"1100001", "outlet_id":"00153", "tx_ref_id":${ID}, "acc_type":"THAIID", "acc_value":"9890", "sale_amt":"" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${400}
    Response Should Contain Property With Value    status.message    Bad Request
    Response Should Contain Property With Value    errors.[0].message    The sale_amt is required
    Response Should Contain Property With Value    errors.[0].property    sale_amt

TC_O2O_10315
    [Documentation]   Verification earn Point by 'tx_ref_id' doesn't use yet in case 'sale_amt' is 0
    [Tags]    Regression
    Post Api Earn Point     { "terminal_id":"69000153", "brand_id":"1100001", "outlet_id":"00153", "tx_ref_id":${ID}, "acc_type":"THAIID", "acc_value":"9890", "sale_amt":"0" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.message    success
    Response Should Contain Property With String Value    data.rpp_ref_id
    Response Should Contain Property With String Value    data.timestamp
    Response Should Contain Property With Value    data.point    ${0}
    Response Should Contain Property With Value    data.sale_cal_point    0
    Response Should Contain Property With Value    tx_ref_id    ${ID}
    Response Should Contain Property With Value    total    ${1}