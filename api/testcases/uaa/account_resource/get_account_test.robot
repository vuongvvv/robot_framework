*** Settings ***
Documentation    Tests to verify that getAccount api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/account_resource_keywords.robot
Resource    ../../../keywords/uaa/social_resource_keywords.robot
Resource    ../../../keywords/common/truemoney_common.robot

Test Teardown     Delete All Sessions

*** Variables ***
${date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[Z]$

*** Test Cases ***
TC_O2O_01166
    [Documentation]    [uaa][getAccount] /api/account api returns ROLE_USER account's information correctly
    [Tags]    Regression    High    Smoke
    [Setup]    Generate Robot Automation Header    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}
    Get Account
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    id
    Response Should Contain Property With String Value    login
    Response Should Contain Property With Number String    mobile
    Response Should Contain Property With String Or Null    firstName
    Response Should Contain Property With String Or Null    lastName
    Response Should Contain Property With String Or Null    email
    Response Should Contain Property With String Or Null    imageUrl
    Response Should Contain Property With Boolean    activated
    Response Should Contain Property With String Value    langKey
    Response Should Contain Property With String Value    createdBy
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain Property With String Value    lastModifiedBy
    Response Should Contain Property Matches Regex    lastModifiedDate    ${date_regex}
    Response Should Contain Property With String Value    authorities

TC_O2O_16677
    [Documentation]     [uaa][getAccount] /api/account api returns ROLE_USER account's information correctly
    [Tags]      Regression     High    SmokeExclude
    [Setup]    Generate Gateway Header For Client    scope=signin.truemoney
    Generate Header With Truemoney Access Token    nameThEn-email:test@gmail.com-mobile:0811111111-tmn_id:tmnTest
    Get Account
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number String    id
    Response Should Contain Property With String Value    login
    Response Should Contain Property With Null Value    mobile
    Response Should Contain Property With Null Value    firstName
    Response Should Contain Property With Null Value    lastName
    Response Should Contain Property With Null Value    email
    Response Should Contain Property With Null Value    imageUrl
    Response Should Contain Property With Boolean    activated
    Response Should Contain Property With String Value    langKey
    Response Should Contain Property With String Value    createdBy
    Response Should Contain Property Matches Regex    createdDate    ${date_regex}
    Response Should Contain Property With String Value    lastModifiedBy
    Response Should Contain Property Matches Regex    lastModifiedDate    ${date_regex}
    Response Should Contain Property With String Value    authorities
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].providerId    truemoney
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].providerUserId    tmnTest
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].profileData.firstName    เจม
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].profileData.lastName    Doe
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].profileData.email    test@gmail.com
    Response Should Contain Property With Value    identities[?(@.providerId == "truemoney")].profileData.mobile    66811111111