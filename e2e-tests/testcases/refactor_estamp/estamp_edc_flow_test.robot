*** Settings ***
Documentation    Given Merchants request to create campaign by TSM
...              When System send request create campaign on Campaign Service
...              And Admin reviews and updates information of campaign by AdminTools
...              And Admin updates status to approve the campaigns
...              Then E-Stamp campaign is publish on TrueYou app
...              And User's TrueYou can get campaign and create stamp account
...              And User's TrueYou can issue stamp and redeem reward
...              And EDC Merchant can approve issue stamp and redeem reward
Resource        ../../../api/resources/init.robot
Resource        ../../../api/keywords/estamp/estamp_common_keywords.robot
Resource        ../../../api/keywords/estamp/campaign_keywords.robot
Resource        ../../../api/keywords/estamp/stamp_account_keywords.robot
Resource        ../../../api/keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../api/keywords/estamp/issue_stamp_keywords.robot
Resource        ../../../api/keywords/estamp/redeem_reward_keywords.robot
Suite Teardown       Delete All Sessions

*** Variables ***
${campaign_name}                    E2E Create E-Stamp Campaign Test
${enabled_status}                   ENABLE
${max_stamp}                        ${6}
${main_reward_stamp}                ${6}
${extra_reward_stamp}               ${3}
${brand_code}                       0022281
${outlet_id}                        00001
${terminal_id}                      69000702
${stamp_account_status}             ACTIVE
${stamp_amount}                     ${1}
${multiple_stamp_amount}            ${2}
${main_reward_stamp_amount}         ${3}
${unuse_uniquecode}                 ${False}
${used_uniquecode}                  ${True}
${uniquecode_status}                PENDING
${approved_uniquecode_status}       APPROVED

*** Test Cases ***
TC_O2O_05081
    [Documentation]    Merchants request to create campaign by TSM
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Login As Merchants On TSM
    Set E-Stamp Campaign Date Period
    Create E-stamp Campaign     ${campaign_name}     ${max_stamp}      ${extra_reward_stamp}     ${main_reward_stamp}     ${start_date}      ${end_date}     ${enabled_status}      ${brand_code}    ${outlet_id}    ${terminal_id}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value             type                                            ESTAMP
    Response Should Contain Property With Value             name                                            ${campaign_name}
    Response Should Contain Property With Value             campaignData.maxStampQuantity                   ${max_stamp}
    Response Should Contain Property With Value             status                                          ${enabled_status}
    Response Should Contain Property With Value             rules[1].trigger.criteria..totalAmount          ${extra_reward_stamp}
    Response Should Contain Property With Value             rules[2].trigger.criteria..totalAmount          ${main_reward_stamp}
    Response Should Contain Property With Value             participants..merchantId                        ${brand_code}
    Response Should Contain Property With Value             participants..outletId                          ${outlet_id}
    Response Should Contain Property With Value             participants..terminalId                        ${terminal_id}
    Response Should Contain Property With Value             financing..type                                 MERCHANT
    Response Should Contain Property With Value             financing..name                                 ${brand_code}

TC_O2O_04727
    [Documentation]    Trueyou Users create stamp account for collect the stamp
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Login As Customer On TrueYou
    Create Stamp Account     ${created_campaign_id}      ${brand_code}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value         status             ${stamp_account_status}
    Response Should Contain Property With Value         brandCode          ${brand_code}

TC_O2O_04737
    [Documentation]    Trueyou Users see the detail of their actived stamp account
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Get Stamp Account Detail By ID      ${created_stamp_account_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value         status             ${stamp_account_status}
    Response Should Contain Property With Value         brandCode          ${brand_code}
    Response Should Contain Property With Value         totalStamp         ${0}

TC_O2O_04760
    [Documentation]    Trueyou Users generate uniquecode for issue stamp 1 position
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${stamp_amount}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value              status                     ${uniquecode_status}
    Response Should Contain Property With Value              stampAmount                ${stamp_amount}
    Response Should Contain Property With Value              stampAccount.id            ${created_stamp_account_id}
    Response Should Contain Property With Value              stampAccount.status        ${stamp_account_status}
    Response Should Contain Property With Value              uniqueCode.used            ${unuse_uniquecode}

TC_O2O_05059
    [Documentation]    EDC Merchants approve issued stamp 1 position to user's
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value              code                                    ${generate_uniquecode_code}
    Response Should Contain Property With Value              used                                    ${used_uniquecode}
    Response Should Contain Property With Value              issuedStamp.stampAmount                 ${stamp_amount}
    Response Should Contain Property With Value              issuedStamp.status                      ${approved_uniquecode_status}
    Response Should Contain Property With Value              issuedStamp.stampAccount.status         ${stamp_account_status}
    Response Should Contain Property With Value              issuedStamp.stampAccount.brandCode      ${brand_code}
    Login As Customer On TrueYou
    Get Stamp Account Detail By ID      ${created_stamp_account_id}
    Response Should Contain Property With Value                     totalStamp                              ${stamp_amount}

TC_O2O_04761
    [Documentation]    Trueyou Users generate uniquecode for issue stamp 2 positions
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${multiple_stamp_amount}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value              status                     ${uniquecode_status}
    Response Should Contain Property With Value              stampAmount                ${multiple_stamp_amount}
    Response Should Contain Property With Value              stampAccount.id            ${created_stamp_account_id}
    Response Should Contain Property With Value              stampAccount.status        ${stamp_account_status}
    Response Should Contain Property With Value              uniqueCode.used            ${unuse_uniquecode}

TC_O2O_05060
    [Documentation]    EDC Merchants approve issued stamp 2 positions to user's
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value              code                                    ${generate_uniquecode_code}
    Response Should Contain Property With Value              used                                    ${used_uniquecode}
    Response Should Contain Property With Value              issuedStamp.stampAmount                 ${multiple_stamp_amount}
    Response Should Contain Property With Value              issuedStamp.status                      ${approved_uniquecode_status}
    Response Should Contain Property With Value              issuedStamp.stampAccount.status         ${stamp_account_status}
    Response Should Contain Property With Value              issuedStamp.stampAccount.brandCode      ${brand_code}
    Login As Customer On TrueYou
    Get Stamp Account Detail By ID      ${created_stamp_account_id}
    Total Stamp Collected For Extra Reward Should Returns Correctly       ${multiple_stamp_amount}    ${stamp_amount}
    Response Should Contain Property With Value                     totalStamp                              ${issued_extra_reward}

TC_O2O_04795
    [Documentation]    Trueyou Users generate uniquecode for redeem extra reward
    [Tags]      EStamp      Regression      High        ExcludeE2E     SanityExclude      ExcludeSmoke
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward     ${created_extra_reward_id}    ${created_stamp_account_id}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value                     status                                  ${uniquecode_status}
    Response Should Contain Property With Value                     stampAccount.status                     ${stamp_account_status}
    Response Should Contain Property With Value                     stampAccount.brandCode                  ${brand_code}
    Response Should Contain Property With Value                     uniqueCode.code                         ${generate_redeem_code}
    Response Should Contain Property With Value                     uniqueCode.used                         ${unuse_uniquecode}

TC_O2O_05075
    [Documentation]    EDC Merchants approve redeemed extra reward to user's
    [Tags]      EStamp      Regression      High        ExcludeE2E     SanityExclude      ExcludeSmoke
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value                     used                                    ${used_uniquecode}
    Response Should Contain Property With Value                     redeemedReward.status                   ${approved_uniquecode_status}
    Response Should Contain Property With Value                     redeemedReward.stampAccount.status      ${stamp_account_status}
    Response Should Contain Property With Value                     redeemedReward.stampAccount.brandCode   ${brand_code}

TC_O2O_05082
    [Documentation]    Trueyou Users generate uniquecode for issue stamp 3 positions to get main reward
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Login As Customer On TrueYou
    Generate Unique Code To Issue Stamp     ${created_stamp_account_id}      ${main_reward_stamp_amount}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value                     status                     ${uniquecode_status}
    Response Should Contain Property With Value                     stampAmount                ${main_reward_stamp_amount}
    Response Should Contain Property With Value                     stampAccount.id            ${created_stamp_account_id}
    Response Should Contain Property With Value                     stampAccount.status        ${stamp_account_status}
    Response Should Contain Property With Value                     uniqueCode.used            ${unuse_uniquecode}

TC_O2O_05086
    [Documentation]    EDC Merchants approve issued stamp 3 positions to user's get main reward
    [Tags]      EStamp      Regression      High      ExcludeE2E       SanityExclude      ExcludeSmoke
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Issued Stamp    ${generate_uniquecode_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value                     code                                    ${generate_uniquecode_code}
    Response Should Contain Property With Value                     used                                    ${used_uniquecode}
    Response Should Contain Property With Value                     issuedStamp.stampAmount                 ${main_reward_stamp_amount}
    Response Should Contain Property With Value                     issuedStamp.status                      ${approved_uniquecode_status}
    Response Should Contain Property With Value                     issuedStamp.stampAccount.status         ${stamp_account_status}
    Response Should Contain Property With Value                     issuedStamp.stampAccount.brandCode      ${brand_code}
    Login As Customer On TrueYou
    Get Stamp Account Detail By ID      ${created_stamp_account_id}
    Total Stamp Collected For Main Reward Should Returns Correctly       ${issued_extra_reward}    ${main_reward_stamp_amount}
    Response Should Contain Property With Value                     totalStamp                              ${issued_main_reward}

TC_O2O_04796
    [Documentation]    Trueyou Users generate uniquecode for redeem main reward
    [Tags]      EStamp      Regression      High        ExcludeE2E     SanityExclude      ExcludeSmoke
    Login As Customer On TrueYou
    Generate RedeemCode To Redeem Reward     ${created_main_reward_id}    ${created_stamp_account_id}
    Response Correct Code      ${CREATED_CODE}
    Response Should Contain Property With Value                     status                                  ${uniquecode_status}
    Response Should Contain Property With Value                     stampAccount.status                     ${stamp_account_status}
    Response Should Contain Property With Value                     stampAccount.brandCode                  ${brand_code}
    Response Should Contain Property With Value                     uniqueCode.code                         ${generate_redeem_code}
    Response Should Contain Property With Value                     uniqueCode.used                         ${unuse_uniquecode}

TC_O2O_05076
    [Documentation]    EDC Merchants approve redeemed main reward to user's
    [Tags]      EStamp      Regression      High        ExcludeE2E     SanityExclude      ExcludeSmoke
    Generate EDC Header
    EDC Merchant Use Unique Code To Approve Redeem Reward    ${generate_redeem_code}     ${brand_code}      ${outlet_id}     ${terminal_id}
    Response Correct Code      ${SUCCESS_CODE}
    Response Should Contain Property With Value                     used                                    ${used_uniquecode}
    Response Should Contain Property With Value                     redeemedReward.status                   ${approved_uniquecode_status}
    Response Should Contain Property With Value                     redeemedReward.stampAccount.status      INACTIVE
    Response Should Contain Property With Value                     redeemedReward.stampAccount.brandCode   ${brand_code}