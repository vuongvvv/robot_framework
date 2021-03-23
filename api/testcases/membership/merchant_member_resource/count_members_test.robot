*** Settings ***
Documentation    Tests to verify that the API for count the number of memberships in various conditions is working fine

Resource    ../../../resources/init.robot
Resource    ../../../keywords/membership/member_resource_keywords.robot
Resource    ../../../keywords/membership/merchant_member_resource_keywords.robot

# permission_name=merchant.merchant.actAsAdmin,membership.member.list
Test Setup    Run Keywords    Generate Robot Automation Header    ${MEMBERSHIP_USER}    ${MEMBERSHIP_USER_PASSWORD}    
...    AND    Get Test Data Merchant Id For Membership
Test Teardown    Delete All Sessions

*** Variables ***
${invalid_merchant_id}    999999

*** Test Cases ***
TC_O2O_00655
    [Documentation]    [Search] Able to get the member counts by using valid "merchantId" only
    [Tags]    Regression    Smoke    High
    Get Count Members    ${TEST_DATA_MERCHANT_ID_FOR_MEMBERSHIP}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Integer Value    count

TC_O2O_00668
    [Documentation]    [Format] Unable to get the member counts if sending an invalid "merchantId" value
    [Tags]    Regression    Medium
    Get Count Members    ${invalid_merchant_id}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    Merchant ID does not existed