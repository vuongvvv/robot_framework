*** Settings ***
Resource    ../../../web/keywords/common/web_common.robot
Resource    ../../../web/resources/locators/payment/credit_card_resource_locators.robot

*** Keywords ***
Confirm Credit Card Authorize
    [Arguments]    ${authorized_url}
    Open Browser With Option    ${authorized_url}
    Wait Element Is Visible    ${omise_authorize_success}    10s
    Clean Environment

Select Credit Card Installment Confirm Option
    [Arguments]    ${select_option}
    Open Browser With Option    ${OMISE_AUTHORIZE_URI}
    Select Installment Confirm Option    ${select_option}
    Clean Environment

Select Installment Confirm Option
    [Arguments]    ${label}
    ${confirm_option}    Generate Element From Dynamic Locator    ${omise_installment_confirm_option}    ${label}
    Wait Element Is Visible    ${confirm_option}    10s
    Click Element    ${confirm_option}
    Wait Element Is Visible    ${omise_authorize_success}    10s
