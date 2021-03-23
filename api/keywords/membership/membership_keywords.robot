*** Settings ***
Resource    ../common/api_common.robot
Library    Collections

*** Variables ***
${api_membership}    /membership
${api_member_count}    /api/merchants/_merchantID/members/count
${api_member_subscriptions}    /api/subscriptions
${api_get_all_members}    /api/members

*** Keywords ***
##KEYWORDS FOR MEMBERSHIP COUNTS API
Create Membership Count Header
    &{headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${ACCESS_TOKEN}
    Set Suite Variable    &{member_count_header}    &{headers}

Get Membership Count By Merchant ID
    [Arguments]    ${merchant_id}
    Create Membership Count Header
    ${member_count_uri}=    Replace String    ${api_member_count}    _merchantID    ${merchant_id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    ${api_membership}${member_count_uri}    headers=${member_count_header}
    Set Test Variable    ${RESP}

###KEYWORDS FOR MEMBERSHIP SUBSCRIPTION API
Create Membership Subscription
    [Arguments]    ${membership_id}    ${type_id}
    ${request_body}=   Set Variable    {"memberId":"${membership_id}","typeId":"${type_id}"}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_membership}${api_member_subscriptions}    data=${request_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}




