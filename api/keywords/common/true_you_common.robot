*** Settings ***
Resource    sdk_authentication_common.robot
Library    XML

*** Keywords ***
Create True You Session
    Create Session    ${TRUE_YOU_SESSION}    ${TRUE_YOU_HOST}    verify=true

Post Generate Reward Code
    [Arguments]    ${ssoid}    ${access_token}    ${thai_id}    ${mobile_number}    ${campaign_code}
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${RESP}=    Post Request    ${TRUE_YOU_SESSION}    /services/mobile_api.aspx    data=<Request> <Method>APPLYCAMPAIGN</Method> <OS>ios</OS> <Parameter> <SSOID>${ssoid}</SSOID> <AccessToken>${access_token}</AccessToken> <ThaiID>${thai_id}</ThaiID> <MobileNr>${mobile_number}</MobileNr> <CampaignCode>${campaign_code}</CampaignCode> </Parameter> </Request>    headers=${headers}
    Set Test Variable    ${RESP}

Generate Reward Code By Campaign
    [Arguments]    ${campaign_code}
    Get Test Data Sdk Access Token
    Create True You Session
    Post Generate Reward Code    21982356    ${TEST_DATA_SDK_ACCESS_TOKEN}    0000000012786    0610095616    ${campaign_code}
    ${TEST_DATA_REWARD_CODE}=    Get Element Text    ${RESP.text}    */RewardCode
    Set Test Variable    ${TEST_DATA_REWARD_CODE}