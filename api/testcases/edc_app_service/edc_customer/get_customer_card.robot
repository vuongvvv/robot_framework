*** Settings ***
Documentation    [EDC] API for Get Customer Card

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/rpp_gateway_common.robot
Resource    ../../../keywords/edc_app_service/edc_customer_keywords.robot

Suite Setup    Create RPP Gateway Header
Suite Teardown     Delete All Sessions

*** Variables ***
${brand_id}    0418377
${outlet_id}    00001
${terminal_id}    68222795
${acc_type}    THAIID
${acc_value}    3110101376336

*** Test Cases ***
TC_O2O_28593
    [Documentation]    EDC - Get Customer Card
    [Tags]    Regression    High    Smoke
    Get Customer Card    ${brand_id}    ${outlet_id}    ${terminal_id}    ${acc_type}    ${acc_value}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value    card_no
    Response Should Contain Property With String Value    card_type