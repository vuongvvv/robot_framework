*** Settings ***
Documentation    Tests to verify that PAYMENT REPORT api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/rpp_payment/report_keywords.robot
Test Setup  Create RPP Gateway Header
Test Teardown   Run Keywords    Delete All Sessions
*** Variables ***

*** Test Cases ***
TC_O2O_12296
    [Documentation]    [API] [Payment] Verify maximum record in 1 request, export without condition
    [Tags]    High    Smoke    Sanity    Regression
    Post Payment Report
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Have Number Of Records    10000    .data.[*]

TC_O2O_12297
    [Documentation]    [API] [Payment] Verify maximum record in 1 request, export with sort condition
    [Tags]    High    Smoke    Sanity    Regression
    Post Payment Report    sort=id,ASC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Have Number Of Records    10000    .data.[*]

TC_O2O_12298
    [Documentation]    [API] [Payment] Verify response when export with valid txRefId
    [Tags]    Medium    Smoke    Regression
    Post Payment Report    txRefId=${SUCCESS_TX_REF_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Have Number Of Records    1    .data.[*]
    Response Should Contain Property With Value    .data..txRefId    ${SUCCESS_TX_REF_ID}

TC_O2O_12299
    [Documentation]    [API] [Payment] Verify response when export with valid txRefId
    [Tags]    Medium    Smoke    Regression
    Post Payment Report    txRefId=${SUCCESS_CANCEL_TX_REF_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Have Number Of Records    2    .data.[*]
    Response Should Contain Property With Value    .data..txRefId    ${SUCCESS_CANCEL_TX_REF_ID}
    Response Should Contain Property With Value    .data..status    SUCCESS

TC_O2O_12301
    [Documentation]    [API] [Payment] Verify response when export with invalid condition (transaction not found)
    [Tags]    Medium    Smoke    Regression
    Post Payment Report    txRefId=1.1
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Have Number Of Records    0    .data.[*]
