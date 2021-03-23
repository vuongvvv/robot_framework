*** Settings ***
Documentation    Tests to verify that the Merchant Auto-Binding feature is working properly.
...              Noted that in the reality, we expect to have the MID that passed from Native application.

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant/binding_keywords.robot
Test Setup      Generate Access Token   ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Test Teardown   Delete All Sessions

*** Variables ***
##MERCHANT ACCOUNT FOR BINDING
${valid_mid}              1100001
${valid_trueyou_mid}      101110000100006
${invalid_mid}            9999999
##ERROR MESSAGES FOR BINDING APIS
${title_not_found}              Merchant not found
${title_invalid_validation}     Method argument not valid
${entity_name_response}         bindingManagement
${error_key_response}           merchantnotfound
${type_response}                http://www.jhipster.tech/problem/merchant-not-found
${message_response}             error.merchantnotfound
${params_response}              bindingManagement

*** Test Cases ***
TC_O2O_01560
    [Documentation]    [API] Submit Auto-Binding API for Unbind user with valid information
    [Tags]    Merchant    Regression    High
    [Setup]    Generate Access Token   ${NON_BOUND_USERNAME}       ${NON_BOUND_PASSWORD}
    Submit Auto Binding Request    ${valid_mid}
    Response Correct Code    ${CREATED_CODE}
    [Teardown]  Unbind Merchant Account

TC_O2O_01561
    [Documentation]    [API] Submit Auto-Binding API for Bound user with valid information
    [Tags]    Merchant    Regression    High
    [Setup]   Bound Merchant Account
    Submit Auto Binding Request        ${valid_mid}
    Response Correct Code              ${CREATED_CODE}
    [Teardown]  Unbind Merchant Account

TC_O2O_01562
    [Documentation]    [API] Submit Auto-Binding API with invalid information
    [Tags]    Merchant    Regression    High
    Submit Auto Binding Request     ${invalid_mid}
    Response Correct Code           ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title          ${title_not_found}
    Response Should Contain Property With Value    entityName     ${entity_name_response}
    Response Should Contain Property With Value    errorKey       ${error_key_response}
    Response Should Contain Property With Value    type           ${type_response}
    Response Should Contain Property With Value    message        ${message_response}
    Response Should Contain Property With Value    params         ${params_response}

TC_O2O_01565
    [Documentation]    [API] Submit Auto-Binding API with blank value - MID
    [Tags]    Merchant    Regression    Medium
    Submit Auto Binding Request    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${title_invalid_validation}

TC_O2O_01567
    [Documentation]    [API] Submit Auto-Binding API with whitespace value - MID
    [Tags]    Merchant    Regression    Medium
    Submit Auto Binding Request    ${SPACE}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${title_invalid_validation}

TC_O2O_01568
    [Documentation]    [API] Submit Auto-Binding API with incorrect MID format - Less than 7 Digits
    [Tags]    Merchant    Regression    Medium
    Submit Auto Binding Request    999999
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${title_invalid_validation}

TC_O2O_01569
    [Documentation]    [API] Submit Auto-Binding API with incorrect MID format - Greater than 7 Digits
    [Tags]    Merchant    Regression    Medium
    Submit Auto Binding Request    99999999
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${title_invalid_validation}
