*** Settings ***
Resource    ../common/api_common.robot
Resource    ../uaa/user_keywords.robot
Resource    ../merchant/binding_keywords.robot
Resource    ../merchant/merchant_register_merchant_keywords.robot
Resource    ../common/json_common.robot

*** Variables ***
${notification_type_id}    ${1}

*** Keywords ***
Get All Merchant Notification Types
    [Arguments]    ${type_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Messages
    [Arguments]    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/messages    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get All Messages With Sorting
    [Arguments]    ${sort_string}    ${response_property}    ${sort_option}
    Get All Messages    ${sort_string}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    ${response_property}    ${sort_option}

Post Register Merchant Notification Type
    [Arguments]    ${type_id}    ${data}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/register    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Approver Update Merchant Info
    [Arguments]    ${type_id}    ${merchant_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/${merchant_id}    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Put Update Merchant Notification Status
    [Arguments]    ${type_id}    ${merchant_id}    ${data}
    ${RESP}=    Put Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/${merchant_id}/update-status    data=${data}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Merchant By Notification Type
    [Arguments]    ${type_id}    ${merchant_id}    ${params_uri}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/${merchant_id}    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Merchant Remain Quota By Notification Type
    [Arguments]    ${type_id}    ${merchant_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/${merchant_id}/remain-quota    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Suggestion Sender Name
    [Arguments]    ${type_id}    ${merchant_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /notification/api/types/${type_id}/merchants/${merchant_id}/suggest-name    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
# Template keywords
Get All Merchant Notification Types With Filter
    [Arguments]    ${type_id}    ${filter_field}    ${filter_comparasion}    ${filter_value}
    Get All Merchant Notification Types    ${type_id}    ${filter_field}.${filter_comparasion}=${filter_value}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Equal To Value    .typeId    ${type_id}    
    Response Should Contain All Property Values Equal To Value    .${filter_field}    ${filter_value}

Get All Merchant Notification Types With Empty Filter
    [Arguments]    ${type_id}    ${empty_filter_string}
    Get All Merchant Notification Types    ${type_id}    ${empty_filter_string}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty

# Data preparation
Prepare Test Date For Notification
    [Arguments]    ${user_login}
    Generate Gateway Header    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Get User    ${user_login}
    ${user_id}=    Get Value From Json    ${RESP.json()}    $..id
    Get All Messages    notificationTypeId.in=${notification_type_id}    
    ${list_merchant_id}=    Get Value From Json     ${RESP.json()}    $..merchantId
    ${list_merchant_notification_type_id}=    Get Value From Json     ${RESP.json()}    $..merchantNotificationTypeId
    ${list_status}=    Get Value From Json     ${RESP.json()}    $..status
    ${merchant_id}=    Set Variable    @{list_merchant_id}[0]
    ${list_messages}=    Get Value From Json     ${RESP.json()}    $..id
    ${list_created_date}=    Get Value From Json     ${RESP.json()}    $..createdDate
    Post Create User Merchant    { "merchantId": "${merchant_id}", "role": "MERCHANT_ADMIN", "userId": @{user_id}[0] }
    ${user_merchant_id}=    Get Value From Json    ${RESP.json()}    $..id
    Set Test Variable    ${CREATED_USER_MERCHANT_ID}    @{user_merchant_id}[0]    
    Put Update Merchant Notification Status    ${notification_type_id}    ${merchant_id}    { "status": "REQUESTED", "statusMessage": "API AUTOMATION UPDATE" }
    #Create new notification type
    ${unique_string_generated}=    Get Current Date    time_zone=local    increment=0    result_format=%d%S%f    exclude_millis=False
    Post Create Notification Type    { "name": "${unique_string_generated}", "quotaLimit": 1000, "terms": "${unique_string_generated}", "rule":"EGG_SMS" }
    ${created_notification_type_id}=    Get Value From Json     ${RESP.json()}    $.id
    Set Test Variable    ${UNIQUE_STRING}    ${unique_string_generated}
    Set Test Variable    ${CREATED_NOTIFICATION_TYPE}    @{created_notification_type_id}[0]
    Set Test Variable    ${EXIST_TYPE_ID}    ${notification_type_id}
    Set Test Variable    ${EXIST_MERCHANT_ID}    @{list_merchant_id}[0]
    Set Test Variable    ${EXIST_MERCHANT_NOTIFICATION_TYPE_ID}    @{list_merchant_notification_type_id}[0]
    Set Test Variable    ${EXIST_STATUS}    @{list_status}[0]
    Set Test Variable    ${EXIST_USER_ID}    @{user_id}[0]
    Set Test Variable    ${EXIST_MESSAGE_ID}    @{list_messages}[0]
    Set Test Variable    ${EXIST_CREATED_DATE}    @{list_created_date}[0]

Clean Notification Test Data
    Generate Gateway Header    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Delete User Merchant    ${CREATED_USER_MERCHANT_ID}