*** Settings ***
Documentation    To make sure that RPP API is still working with the design condition
...              for preventing the failure during retrieving data process

Resource    ../../../resources/init.robot
Resource    ../../../keywords/dataplatform/rpp_keywords.robot
Suite Setup    Create RPP Session
Suite Teardown    Delete All Sessions

*** Variables ***
${valid_merchant_id}    1100001

*** Test Cases ***
TC_O2O_01367
    [Documentation]    [API] Verify that EDC Transaction Search API on RPP is working properly
    [Tags]    DataPlatform    RegressionExclude    High
    Get Payment Transaction Search    ${valid_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .merchantId    ${valid_merchant_id}

TC_O2O_01368
    [Documentation]    [API] Verify that Redemption Search API on RPP is working properly
    [Tags]    DataPlatform    RegressionExclude    High
    Get Redemption Transaction Search    ${valid_merchant_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    .brand_id    ${valid_merchant_id}