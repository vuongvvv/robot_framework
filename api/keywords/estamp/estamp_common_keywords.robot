*** Settings ***
Resource        ../common/api_common.robot
Resource        ../estamp/campaign_keywords.robot
*** Variables ***
${campaign_expired_name}                Automate Create E-Stamp Campaign Expired
${campaign_not_published_name}          Automate Create E-Stamp Campaign Is Not Published
${campaign_name}                        Automate Create E-Stamp Campaign Test
${campaign_no_total_amount}             Automate Create Total amount not found E-Stamp Campaign Test
${campaign_no_reward}                   Automate Create E-Stamp Campaign Reward Is Not Found Test
${campaign_incorrect_reward_benefit}    Automate Create E-Stamp Campaign Incorrect Reward Benefit Test
${brand_id}                             0022281
${outlet_id}                            00001
${terminal_id}                          69000702
${max_stamp}                            ${6}
${main_reward_stamp}                    ${6}
${extra_reward_stamp}                   ${3}
${enabled_status}                       ENABLE
${disabled_status}                      DISABLE

*** Keywords ***
Login With TrueID User
    [Arguments]        ${username}      ${password}     ${auth_key}
    Get True ID Credential    ${username}    ${password}
    Create Gateway Session
    ${headers}=             Create Dictionary       Authorization=${auth_key}
    ${trueid_login_uri}=    Replace String          ${trueid_login_verify}      _loginCode            ${code_id}
    ${trueid_login_uri}=    Replace String          ${trueid_login_uri}         _loginState           ${state_id}
    ${RESP}=                Get Request             ${GATEWAY_SESSION}          ${trueid_login_uri}   headers=${headers}
    Set Suite Variable       ${RESP}
    ${ACCESS_TOKEN}=   Set Variable If   '${RESP}'=='<Response [${SUCCESS_CODE}]>'    ${RESP.json()['access_token']}
    Set Suite Variable        ${ACCESS_TOKEN}

Generate Login TrueID Header
    [Arguments]        ${username}      ${password}     ${auth_key}
    Login With TrueID User       ${username}      ${password}      ${auth_key}
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
    Set Suite Variable    &{GATEWAY_HEADER}

Login As Merchants On TSM
    Generate Login TrueID Header     ${TRUE_ID_MERCHANT_USERNAME}        ${TRUE_ID_MERCHANT_PASSWORD}       ${AUTHORIZATION_KEY}

Login As Customer On TrueYou
    Generate Login TrueID Header     ${TRUE_ID_CUSTOMER_USERNAME}        ${TRUE_ID_CUSTOMER_PASSWORD}       ${TRUEYOU_AUTHORIZATION_KEY}

Get Access Token For EDC
    Create Gateway Session
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded      Authorization=${EDC_AUTHORIZATION_KEY}
    &{data}=    Create Dictionary    grant_type=client_credentials
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    ${api_uaa}/oauth/token    data=${data}    headers=${headers}
    &{resp_body}=    To Json    ${RESP.text}
    Set Suite Variable    ${ACCESS_TOKEN}    ${resp_body.access_token}

Generate EDC Header
    Get Access Token For EDC
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${ACCESS_TOKEN}    Content-Type=application/json
    Set Suite Variable    &{GATEWAY_HEADER}

Prepare E-Stamp Campaign Test Data
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-stamp Campaign                 ${campaign_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign Is Disabled Test Data
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-stamp Campaign                 ${campaign_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${disabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign Is Not Published Test Data
    Login As Merchants On TSM
    Set E-Stamp Campaign Start Date Is Not Published
    Create E-stamp Campaign                 ${campaign_not_published_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign Is Expired Test Data
    Login As Merchants On TSM
    Set E-Stamp Campaign End Date Is Expired
    Create E-stamp Campaign                 ${campaign_expired_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign With No Reward Total Amount
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-Stamp Campaign With No Reward Total Amount      ${campaign_no_total_amount}     ${max_stamp}      ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign Reward Is Not Found
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-Stamp Campaign Reward Is Not Found     ${campaign_no_reward}     ${max_stamp}      ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}

Prepare E-Stamp Campaign Incorrect Reward Benefit
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-Stamp Campaign Incorrect Reward Benefit     ${campaign_incorrect_reward_benefit}     ${max_stamp}      ${start_date}      ${end_date}     ${enabled_status}      ${brand_id}    ${outlet_id}    ${terminal_id}