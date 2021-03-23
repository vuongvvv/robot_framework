*** Settings ***
Library     JSONLibrary
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp_mtransaction/mtrans_merchant_keyword.robot

Test Setup    Run Keywords    Create RPP Gateway Header    AND    Generate Unique TxRefId

*** Test Cases ***
TC_O2O_10317
    [Documentation]   Verify Creating Merchant API successfully create new merchant
    [Tags]    Regression    Smoke
    Post Create Merchant By TxRefId    ${TX_REF_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With String Value    data.id

TC_O2O_10318
    [Documentation]   Verify Creating Merchant API responds 400 Bad Request when txRefId is duplicate
    [Tags]    Regression    Smoke
    Post Create Merchant By TxRefId    ${TX_REF_ID}
    Post Create Merchant By TxRefId    ${TX_REF_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${400}
    Response Should Contain Property With Value    status.message    Bad Request
    Response Should Contain Property With Value    error.message    insertError