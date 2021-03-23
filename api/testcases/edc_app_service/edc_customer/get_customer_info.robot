*** Settings ***
Documentation    [EDC] API for Get Customer Info

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/edc_app_service/edc_customer_keywords.robot

Suite Setup    Create RPP Gateway Header
Suite Teardown     Delete All Sessions

*** Variables ***
${brand_id}    0022162
${outlet_id}    00001
${terminal_id}    69000674
${acc_type}    THAIID
${acc_value}    1111111111119

*** Test Cases ***
TC_O2O_28594
    [Documentation]    EDC - Get Customer Info
    [Tags]    Regression    High    Smoke
    Get Customer Info    ${brand_id}    ${outlet_id}    ${terminal_id}    ${acc_type}    ${acc_value}
    Response Correct Code    ${SUCCESS_CODE}