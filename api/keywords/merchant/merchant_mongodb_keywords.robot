*** Settings ***
Resource    ../common/mongodb_common.robot
Resource    ../uaa/uaa_db_keywords.robot

*** Variable ***
${db_merchant}    merchant
${collection_user_merchant}    user_merchant

*** Keywords ***
##KEYWORDS FOR MERCHANT_PROVIDER COLLECTION
Get Merchant Provider ID By Trueyou ID
    [Arguments]    ${trueyou_id}
    ${get_merchant_id}=    Retrieve Mongodb Records With Desired Fields    ${db_merchant}    ${collection_user_merchant}    {"merchant_provider_id": "${trueyou_id}"}    merchant_id    return__id=False
    ${get_merchant_id}=    Get Substring    ${get_merchant_id}    20    -3
    [Return]    ${get_merchant_id}

## KEYWORDS FOR USER_MERCHANT COLLECTION
Get User Merchant Object ID By User ID
    [Arguments]    ${uaa_user_id}
    ${get_object_id}=    Retrieve Mongodb Records With Desired Fields    ${db_merchant}    ${collection_user_merchant}    {"user_id": ${uaa_user_id}}    _id
    ${get_object_id}=    Get Substring    ${get_object_id}    20    -4
    [Return]    ${get_object_id}

Get Bound Merchant ID By User ID
    [Arguments]    ${uaa_user_id}
    ${get_merchant_id}=    Retrieve Mongodb Records With Desired Fields    ${db_merchant}    ${collection_user_merchant}    {"user_id": ${uaa_user_id}}    merchant_id    return__id=False
    ${get_merchant_id}=    Get Substring    ${get_merchant_id}    20    -3
    [Return]    ${get_merchant_id}

Get Bound Merchant ID By User Account
    [Arguments]    ${username}
    ${uaa_id}=    Get User Internal ID    ${username}
    ${merchant_id}=    Get Bound Merchant ID By User ID    ${uaa_id}
    [Return]    ${merchant_id}