*** Settings ***
Resource    ../common/api_common.robot
Resource    ../common/rpp_common.robot

*** Variables ***
${rpp_payment_search}    /payment-api/v1/api/payments/reports?merchantId=_merchantID&createDateStart=_startDate&sort=id
${rpp_redemption_search}    /searchint-api/v1/redeem/report?brand_id=_merchantID&start_date_from=_startDate
${default_payment_date}    2018-01-01T00:00:00
${default_redemption_date}    2018-01-01 00:00:00

*** Keywords ***
Create RPP API Header
    &{headers}=    Create Dictionary    Authorization=${RPP_AUTHORIZATION_KEY}
    Set Suite Variable    &{rpp_api_header}    &{headers}

Get Payment Transaction Search
    [Arguments]    ${merchant_id}    ${start_date}=${default_payment_date}
    Create RPP API Header
    ${payment_search_uri}=    Replace String    ${rpp_payment_search}    _merchantID    ${merchant_id}
    ${payment_search_uri}=    Replace String    ${payment_search_uri}    _startDate    ${start_date}
    ${RESP}=    Get Request    ${RPP_SESSION}    ${payment_search_uri}    headers=&{rpp_api_header}
    Set Test Variable    ${RESP}

Get Redemption Transaction Search
    [Arguments]    ${merchant_id}    ${start_date}=${default_redemption_date}
    Create RPP API Header
    ${redemption_search_uri}=    Replace String    ${rpp_redemption_search}    _merchantID    ${merchant_id}
    ${redemption_search_uri}=    Replace String    ${redemption_search_uri}    _startDate    ${start_date}
    ${RESP}=    Get Request    ${RPP_SESSION}    ${redemption_search_uri}    headers=&{rpp_api_header}
    Set Test Variable    ${RESP}