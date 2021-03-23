*** Settings ***
Documentation    Tests to verify that the "Add Campaign Promotions" can work as expected.
Resource    ../../../resources/init.robot
Resource    ../../../keywords/campaign/promotions_keywords.robot
Test Setup    Run Keywords    Read Dummy Json From File    AND    Generate Gateway Header With Scope and Permission    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}    campaign.promotion.create
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${bad_request_title}    Bad Request
${contraint_violation_title}    Constraint Violation

*** Test Cases ***
TC_O2O_03743
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, invalid end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.endDate    aaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    endDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.endDate    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.endDate    ${12.12}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.endDate    T00:00:00+08:00
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    endDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.endDate    2019-01-10
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    endDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.endDate    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03744
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, missing end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.endDate    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    violations[1].field    endDate
    Response Should Contain Property With Value    violations[1].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03745
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, invalid start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.startDate    aaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    startDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.startDate    T00:00:00+08:00
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    startDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.startDate    2019-01-10
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    startDate
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.startDate    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    violations[1].field    startDate
    Response Should Contain Property With Value    violations[1].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation


TC_O2O_03746
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, missing start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.startDate    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    violations[1].field    startDate
    Response Should Contain Property With Value    violations[1].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03747
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, invalid platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.platform    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    platform
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.platform    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    platform
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.platform    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    platform
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03748
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, missing platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.platform    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    platform
    Response Should Contain Property With Value    violations[0].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03749
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, invalid type, correct platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.type    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.type    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.type    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03750
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, missing platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.type    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    type
    Response Should Contain Property With Value    violations[0].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03751
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with invalid name, correct type, correct platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.name    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Verify The Successful Response Of Add Campaign API    ${0}    ${json_dummy_data}    ${SUPER_ADMIN_USER}
    Modify Dummy Data    $.name    123
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Verify The Successful Response Of Add Campaign API    ${0}    ${json_dummy_data}    ${SUPER_ADMIN_USER}
    Modify Dummy Data    $.name    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    name
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03752
    [Documentation]    Verify that user cannot add the campaign successfully with missing name, correct type, correct platform, correct start date, correct end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.name   ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    name
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03753
    [Documentation]    Verify that user cannot add the campaign successfully with missing name, missing type, missing platform, missing start date, missing end date
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.name    ${NULL}
    Modify Dummy Data    $.type    ${NULL}
    Modify Dummy Data    $.platform    ${NULL}
    Modify Dummy Data    $.startDate    ${NULL}
    Modify Dummy Data    $.endDate    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].message    Start date should be before end date
    Response Should Contain Property With Value    violations[1].field    endDate
    Response Should Contain Property With Value    violations[1].message    may not be null
    Response Should Contain Property With Value    violations[2].field    name
    Response Should Contain Property With Value    violations[2].message    may not be empty
    Response Should Contain Property With Value    violations[3].field    platform
    Response Should Contain Property With Value    violations[3].message    may not be null
    Response Should Contain Property With Value    violations[4].field    startDate
    Response Should Contain Property With Value    violations[4].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03755
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct data, correct status, invalid maximumUsePerUser
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.maximumUsePerUser    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    maximumUsePerUser
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.maximumUsePerUser    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    maximumUsePerUser    ${NULL}

TC_O2O_03756
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct data, correct status, missing maximumUsePerUser
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.maximumUsePerUser    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    maximumUsePerUser    ${NULL}

TC_O2O_03757
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct data, invalid status, correct maximumUsePerUser
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.status    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    status
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.status    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property Matches Regex    detail    status
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03758
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct data, missing status, correct maximumUsePerUser
    [Tags]    BE-Campaign    RegressionExclude    Medium
    #Fail
    Modify Dummy Data    $.status    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    status    ENABLE

TC_O2O_03759
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and invalid rule
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules    123
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    rules
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules    !a!
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    rules
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    rules
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03762
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is correct trigger, correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, incorrect isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].isFeatured    aaaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    isFeatured
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].isFeatured    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].isFeatured    ${TRUE}
    Modify Dummy Data    $.rules[0].isFeatured    ${-1}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].isFeatured    ${TRUE}
    Modify Dummy Data    $.rules[0].isFeatured    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].isFeatured    ${FALSE}
    Modify Dummy Data    $.rules[0].isFeatured    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].isFeatured    ${FALSE}
    Modify Dummy Data    $.rules[0].isFeatured    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].isFeatured    ${FALSE}

TC_O2O_03764
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is correct trigger, correct participants, correct financings, correct benefit, incorrect OnTopPromotionPrice, correct isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].onTopPromotionPrice    aaaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    onTopPromotionPrice
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].onTopPromotionPrice    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].onTopPromotionPrice    ${TRUE}
    Modify Dummy Data    $.rules[0].onTopPromotionPrice    ${-1}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].onTopPromotionPrice    ${TRUE}
    Modify Dummy Data    $.rules[0].onTopPromotionPrice    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].onTopPromotionPrice    ${FALSE}
    Modify Dummy Data    $.rules[0].onTopPromotionPrice    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].onTopPromotionPrice    ${TRUE}

TC_O2O_03766
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is correct trigger, correct participants, correct financings, invalid benefit, correct OnTopPromotionPrice, correct isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    benefit
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    benefit
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    benefit
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03768
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is correct trigger, correct participants, invalid financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.financing    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    financing
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.financing    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    financing
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.financing    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    financing
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03770
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is correct trigger, invalid participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.participants    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    participant
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.participants    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    participant
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.participants    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    participant
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03772
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, and rules which is invalid trigger, correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    trigger
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    trigger
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    trigger
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03775
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, invalid criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    criteria
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    criteria
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    criteria
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03776
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, missing criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03777
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, invalid exclusions, correct criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.exclusions    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    exclusions
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    exclusions
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.exclusions    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    exclusions
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03778
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, invalid exclusions, correct criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.exclusions    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].trigger.exclusions    ${NULL}

TC_O2O_03779
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has invalid option, correct exclusions, correct criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.option    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.option    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.option    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03780
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has missing option, correct exclusions, correct criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.option    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].trigger.option    AND

TC_O2O_03781
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has missing option, missing exclusions, missing criterias
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.option    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.exclusions    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.criteria    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03782
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct criterias, and exclusion which has correct level, invalid items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].items    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].items    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].items    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03784
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct criterias, and exclusion which has invalid level, correct items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].level    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].level    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.exclusions.[*].level    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03787
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, invalid itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03788
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, missing itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].itemData    ${NULL}

TC_O2O_03789
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, invalid level, correct itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].level    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].level    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].level    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03790
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, missing level, correct itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].level    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].level
    Response Should Contain Property With Value    violations[0].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03791
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, missing level, correct itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03792
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has missing type, correct level, correct itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03793
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has missing type, missing level, missing itemData
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.criteria[0].level    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03794
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and invalid items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03795
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and missing items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03796
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has invalid option, and correct items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.option    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.option    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.option    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03797
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has missing option, and correct items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.option    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].trigger.criteria[0].itemData.option    AND

TC_O2O_03798
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has missing option, and missing items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.option    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03799
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, rules which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and items which has correct id, and invalid quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[0].quantity    ${-1}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items[0].quantity
    Response Should Contain Property With Value    violations[0].message    must be greater than or equal to 1
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[0].quantity    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items[0].quantity
    Response Should Contain Property With Value    violations[0].message    must be greater than or equal to 1
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    quantity
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    ${1}

TC_O2O_03800
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and items which has correct id, and missing quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    ${1}

TC_O2O_03801
    [Documentation]    Verify that user can add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and items which has invalid id, and correct quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].id    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.rules[0].trigger.criteria[0].itemData.items[*].id    123
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].id    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items[0].id
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03802
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and items which has missing id, and correct quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].id    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items[0].id
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03803
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct participants, correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured and trigger which has correct option, correct exclusions, and correct criterias which has correct type, correct level, and itemData which has correct option, and items which has missing id, and missing quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].id    ${NULL}
    Modify Dummy Data    $.rules[0].trigger.criteria[0].itemData.items[*].quantity    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].trigger.criteria[0].itemData.items[0].id
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    violations[1].field    rules[0].trigger.criteria[0].itemData.items[1].id
    Response Should Contain Property With Value    violations[1].message    may not be empty
    Response Should Contain Property With Value    violations[2].field    rules[0].trigger.criteria[0].itemData.items[2].id
    Response Should Contain Property With Value    violations[2].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03804
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct financings, correct benefit, correct OnTopPromotionPrice, correct isFeatured, correct trigger, and participants which has invalid merchant
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.participants[0].merchantId    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    participants[0].merchantId
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03806
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with invalid financing's name
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.financing[0].type    SUBSIDY
    Modify Dummy Data    $.financing[0].name    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0]
    Response Should Contain Property With Value    violations[0].message    Financing name is invalid when financing type is SUBSIDY
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.financing[0].name    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0]
    Response Should Contain Property With Value    violations[0].message    Financing name is invalid when financing type is SUBSIDY
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.financing[0].type   MERCHANT
    Modify Dummy Data    $.financing[0].name    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0].name
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03807
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has  correct benefit, correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants and correct financings which has correct type and missing name
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.financing[0].type    SUBSIDY
    Modify Dummy Data    $.financing[0].name    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0]
    Response Should Contain Property With Value    violations[0].message    Financing name is invalid when financing type is SUBSIDY
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.financing[0].type    MERCHANT
    Modify Dummy Data    $.financing[0].name    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0].name
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03808
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has  correct benefit, correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants and correct financings which has invalid type and correct name
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.financing[0].type    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.financing[0].type    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.financing[0].type    aaa!aaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03809
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has  correct benefit, correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants and correct financings which has missing type and correct name
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.financing[0].type    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    financing[0].type
    Response Should Contain Property With Value    violations[0].message    may not be null
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03813
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has correct option and invalid data
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    data
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    data
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data    aaa!aaa
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    data
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03815
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has invalid option and correct data
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.option    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.option    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.option    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03819
    [Documentation]    Verify that user can add the FREEBIE campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "FREE_ITEM" type, correct level, correct itemData, correct discountType, correct amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    FREE_ITEM
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    ${123}
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    rules[0].benefit.data[*].type    FREE_ITEM
    Response Should Not Contain Property    rules[0].benefit.data[0].discountType[0]
    Response Should Not Contain Property    rules[0].benefit.data[0].amount[0]
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    a!a
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Not Contain Property    rules[0].benefit.data[0].discountType[0]
    Response Should Not Contain Property    rules[0].benefit.data[0].amount[0]
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    ${EMPTY}
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Not Contain Property    rules[0].benefit.data[0].discountType[0]
    Response Should Not Contain Property    rules[0].benefit.data[0].amount[0]

TC_O2O_03821
    [Documentation]    Verify that user cannot add the FREEBIE campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "FREE_ITEM" type, correct level, correct itemData, missing discountType, missing amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    FREE_ITEM
    Modify Dummy Data    $.rules[0].benefit.data[*].level    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].level    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].level    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    level
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03823
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "FREE_ITEM" type, correct level, invalid itemData, missing discountType, missing amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    FREE_ITEM
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03826
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "DISCOUNT" type, incorrect level, incorrect itemData, correct discountType, correct amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    DISCOUNT
    Modify Dummy Data    $.rules[0].benefit.data[*].level    ${123}
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].level    a!a
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    a!A
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].level    ${EMPTY}
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    itemData
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03827
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "DISCOUNT" type, missing level, missing itemData, incorrect discountType, correct amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    DISCOUNT
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    discountType
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    cAsh
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    discountType
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].discountType    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    discountType
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03829
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with "DISCOUNT" type, missing level, missing itemData, correct discountType, invalid amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    DISCOUNT
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${-1}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0]
    Response Should Contain Property With Value    violations[0].message    Benefit amount must greater than 0 and Benefit discount type are required when promotion type is DISCOUNT.
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].benefit.data[*].type    DISCOUNT
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0]
    Response Should Contain Property With Value    violations[0].message    Benefit amount must greater than 0 and Benefit discount type are required when promotion type is DISCOUNT.
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].benefit.data[*].type    DISCOUNT
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${1.2}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.rules[0].benefit.data[*].amount    ${1.2}
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    cAsh
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    amount
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].amount    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0]
    Response Should Contain Property With Value    violations[0].message    Benefit amount must greater than 0 and Benefit discount type are required when promotion type is DISCOUNT.
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03832
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with invalid type, correct level, correct itemData, correct discountType, correct amount
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].type    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].type    cAsh
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].type    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    type
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03833
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with invalid type, correct level, correct discountType, correct amount and itemData which has correct option and invalid items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items    cAsh
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    items
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03834
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with invalid type, correct level, correct discountType, correct amount and itemData which has correct option and missing items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items    ${NULL}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0].itemData.items
    Response Should Contain Property With Value    violations[0].message    may not be empty
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation

TC_O2O_03835
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with valid type, correct level, correct discountType, correct amount and itemData which has invalid option and correct items
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.option    ${123}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.option    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.option    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property Matches Regex    detail    option
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    message    error.http.400
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/problem-with-message

TC_O2O_03839
    [Documentation]    Verify that user cannot add the campaign successfully if call add Campaign API with correct name, correct type, correct platform, correct start date, correct end date, correct status, correct maximumUsePerUser, data which has correct OnTopPromotionPrice, correct isFeatured, correct trigger, correct participants, correct financings, and benefit which has benefitData with valid type, correct level, correct discountType, correct amount and itemData which has correct option and items which has correct id and invalid quantity
    [Tags]    BE-Campaign    RegressionExclude    Medium
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items[*].quantity    ${-1}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0].itemData.items[0].quantity
    Response Should Contain Property With Value    violations[0].message    must be greater than or equal to 1
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items[*].quantity    ${0}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${contraint_violation_title}
    Response Should Contain Property With Value    path    /api/promotions
    Response Should Contain Property With Value    violations[0].field    rules[0].benefit.data[0].itemData.items[0].quantity
    Response Should Contain Property With Value    violations[0].message    must be greater than or equal to 1
    Response Should Contain Property With Value    type    https://zalando.github.io/problem/constraint-violation
    Response Should Contain Property With Value    message    error.validation
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items[*].quantity    a!a
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Modify Dummy Data    $.rules[0].benefit.data[*].itemData.items[*].quantity    ${EMPTY}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value    $.rules[0].benefit.data[*].itemData.items[*].quantity    ${1}

TC_O2O_05843
    [Documentation]    Verify that we can add the campaign promotions with campaign type = "COUPON" and trigger type = "COUPON"
    [Tags]    BE-Campaign    RegressionExclude    High
    Modify Dummy Data    $.type    COUPON
    Modify Dummy Data    $.rules[0].trigger.criteria[0].type    COUPON
    Modify Dummy Data    $.rules[0].trigger.criteria[0].couponGroup    TETVUI
    Modify Dummy Data    $.rules[0].trigger.criteria[0].minAmount    ${1000}
    Add Campaign Promotion    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Verify The Successful Response Of Add Campaign API    ${0}    ${json_dummy_data}    ${SUPER_ADMIN_USER}