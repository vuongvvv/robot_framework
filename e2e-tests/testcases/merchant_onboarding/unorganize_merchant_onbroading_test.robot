*** Settings ***
Documentation    E2E test for Merchant onbroading process for both Unorganize merchant
Resource    ../../../api/keywords/common/api_common.robot
Resource    ../../../web/keywords/common/web_common.robot
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/rpp_merchant/merchant_resource_keywords.robot
Resource    ../../../api/keywords/rpp_merchant/outlet_v_2_resource_keywords.robot
Resource    ../../../api/keywords/rpp_merchant/activation_code_resource_keywords.robot
Resource    ../../../api/keywords/common/date_time_common.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${ROLE_USER}    ${ROLE_USER_PASSWORD}    merchant.merchant.read,activationcode.write,activationcode.read,merchant.terminal.read,merchant.outlet.actAsAdmin    permission_name=merchant.outlet.actAsAdmin
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${merchant_sequence_id}    108039
${outlet_name_en}    PancakeAutomatePool
${outlet_name_th}    ร้านแพนเค้กออโตเมทพูล

*** Test Cases ***
#TC can run on ALPHA only since STAGING environment is not ready
#TC have to use static created merchant data in variable section
TC_O2O_10885
    [Documentation]    Ensure user can create new outlet for exiting merchant (Service Type TY+TMN and Device type QRCODE)
    [Tags]    ExcludeSanity    ExcludeSmoke
    Get Merchant Information    id=${merchant_sequence_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    content..status    APPROVE
    Response Should Contain Property With Value    content..tmnStatus    APPROVE
    Response Should Contain Property With Value    content.."trueyouStatus"    APPROVE
    Get Merchant Sequence ID

    Get Unix Time Stamp From Current Date    timestamp
    Post Create Outlets And Address Ref Merchant Id    { "outlets": [ { "addresses": [ { "address": "TEST New Multi Outlet", "addressType": "store", "contentType": "test e2e", "districtId": 1, "latitude": "53.286518", "longtitude": "-6.416770", "postCode": "10250", "provinceId": 1, "road": "Ascesnd", "subdistrictId": 6 } ], "contactPersons": [ { "birthDate": "1988-10-10", "email": "automation.pool@ascendcorp.com", "firstNameEn": "Ascend", "firstNameTh": "แอสเซนด์", "gender": "Female", "lastNameEn": "Only", "lastNameTh": "ออนลี่", "mobileNo": "66-864403645", "occupation": "Testing", "passportNo": null, "phoneNo": "020000000", "refId": 1234567890123, "refType": "CID", "thaiId": "${ACCOUNT_VALUE}", "titleId": 2, "titleOtherName": null } ], "merchantId": "${MERCHANT_SEQUENCE_ID}", "franchisee": true, "headQuarter": true, "outletDetail": "Test Outlet details", "outletNameEn": "${outlet_name_en}${UNIX_TIME_STAMP}", "outletNameTh": "${outlet_name_th}${UNIX_TIME_STAMP}", "registerChannel": "app_sale_agent", "saleId": "0002", "status": "DRAFT", "tmnOutletId": null, "tmnStatus": "WAITING", "trueyouStatus": "WAITING" }] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    outlets..outletNameEn    ${outlet_name_en}${UNIX_TIME_STAMP}
    Get Outlet Sequence Id

    Wait Until Api Keyword Response Property Change    Get Search Outlet By Id    status    APPROVE    10    ${OUTLET_SEQUENCE_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status    APPROVE
    Response Should Contain Property With Value    tmnStatus    NA
    Response Should Contain Property With Value    "trueyouStatus"    APPROVE

    Put Create Activation Code For Outlet    ${OUTLET_SEQUENCE_ID}    { "amount" : 2, "notification" : { "email" : "patthamaporn.kam@ascendcorp.com", "mobile": "66-864403645", "isGroup": false, "receiver": "CUSTOM"} }
    Get Activation Code ID
    Wait Until Api Keyword Response Property Change    Get Activation Code Information    content..status    WAITING_ACTIVATE    10    activationCode=${ACTIVATION_CODE}
    Response Should Contain Property With Value    content..status    WAITING_ACTIVATE

    Put Activate Activation Code And Create Terminal For Outlet    { "activationCode": "${ACTIVATION_CODE}", "device": "SELLER_APP", "deviceNumber" : "SELLER_0001" }
    Response Correct Code    ${SUCCESS_CODE}
    Get Terminal External ID
    Wait Until Api Keyword Response Property Change    Get Activation Code Information    content..status    USED    10    activationCode=${ACTIVATION_CODE}
    Response Should Contain Property With Value    content..status    USED
    Get Terminal Information    ${ACTIVATION_CODE}
    Response Should Contain Property With Value    .status    ACTIVATE