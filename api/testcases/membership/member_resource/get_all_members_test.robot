*** Settings ***
Documentation    Tests to verify that getAllMembers api (GET /api/members) returns correct data

Resource    ../../../resources/init.robot
Resource    ../../../keywords/membership/member_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${MEMBERSHIP_USER}    ${MEMBERSHIP_USER_PASSWORD}    permission_name=membership.member.list
Test Teardown    Delete All Sessions

*** Variables ***
${date_regex}    ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d+Z$    

*** Test Cases ***
TC_O2O_01380
    [Documentation]    [API] [Membership] [getAllMembers] Filter by "merchantId.equals" with empty value returns 200 without data
    [Tags]    Regression    O2O-2662    Medium
    Get All Members    merchantId.equals=
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Be Empty    

TC_O2O_01381
    [Documentation]    [API] [Membership] [getAllMembers] Filter by "phoneNumber.contains" with empty value returns all data
    [Tags]    Regression    O2O-2662    Medium
    Get All Members    phoneNumber.contains=
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Integer    .id
    Response Should Contain All Property Values Are String    .merchantId
    Response Should Contain All Property Values Are Number    .phoneNumber
    Response Should Contain All Property Values Match Regex    .createdDate    ${date_regex}
    Response Should Contain All Property Values Are Null    .merchant
    Response Should Contain All Property Values Are Null    .subscriptions