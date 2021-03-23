*** Settings ***
Library     JSONLibrary
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp_mtransaction/mtrans_merchant_keyword.robot

Test Setup    Create RPP Gateway Header

*** Test Cases ***
TC_O2O_10319
    [Documentation]   Verify Getting Merchant Description by Merchant ID respond correct merchant
    [Tags]    Regression    Smoke    Sanity
    Get Merchant Mongo ID From Created Merchant
    Get Merchant By Merchant Mongo ID  ${MERCHANT_MONGO_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data[0].id    ${MERCHANT_MONGO_ID}
