*** Settings ***
Documentation    Tests to verify that the "Get List Campaign Promotions" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.promotion.search
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation

*** Test Cases ***
TC_O2O_03949
    [Documentation]    Verify that user cannot get campaign promotion list without "campaign.promotion.search" scope
    [Tags]    BE-Campaign    RegressionExclude    High
    [Setup]    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Get List Campaign Promotion
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    Forbidden
    Response Should Contain Property With Value    detail    Access is denied
    Response Should Contain Property Matches Regex    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.403

TC_O2O_03950
    [Documentation]    Verify that user can get Campaign promotion list with correct page and correct size
    [Tags]    BE-Campaign    RegressionExclude    High    Smoke
    Get List Campaign Promotion    sort=id,ASC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC
    Get List Campaign Promotion    page=1&size=10&sort=id,ASC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC

TC_O2O_03953
    [Documentation]    Verify that user can get Campaign promotion list with correct page, correct size and ascending sort by ID
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion    page=1&size=20&sort=id,ASC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    ASC

TC_O2O_03954
    [Documentation]    Verify that user can get Campaign promotion list with correct  age, correct size and descending sort by ID
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion    page=1&size=10&sort=id,DESC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].id    DESC

TC_O2O_03957
    [Documentation]    Verify that user can get Campaign promotion list with correct page, correct size and sort with "ascending/descending" by name
    [Tags]    BE-Campaign    RegressionExclude    High
    Get List Campaign Promotion    sort=name,asc
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].name    ASC
    Response Should Contain All Property Values Are Sorted    [*].name    ASC
    Get List Campaign Promotion    sort=name,desc
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are Sorted    [*].name    DESC