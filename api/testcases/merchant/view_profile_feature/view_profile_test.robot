*** Settings ***
Documentation    Tests to verify that the View Merchant Profile feature is working properly
...              for both bound and unbind users.

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant/view_profile_keywords.robot
Resource    ../../../keywords/merchant/binding_keywords.robot
Suite Setup       Generate Access Token   ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
Suite Teardown   Delete All Sessions

*** Variables ***
${mismatch_merchant_id}    5b344ad296a16200061b354c
${incorrect_merchant_id}   111111111111111111111111
${access_denied_detail}    Access is denied
${valid_mid}               1100001
${store_name}              Eggdigital for test
${unbound_merchant_id}     5c6529f8527dbd0001dbce4b
${access_denied_title}     Forbidden
${access_denied_message}   error.http.403
${unbound_merchant_path}      /api/merchants/${unbound_merchant_id}/details
${mismatch_merchant_path}     /api/merchants/${mismatch_merchant_id}/details
${incorrect_merchant_path}    /api/merchants/${incorrect_merchant_id}/details

*** Test Cases ***
TC_O2O_00068
    [Documentation]    [ViewProfile] Request with User has not bound to the shop and returns access denied
    [Tags]    Merchant    Regression    Medium
    Get Merchant Profile By Merchant ID    ${unbound_merchant_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    detail    ${access_denied_detail}
    Response Should Contain Property With Value    title     ${access_denied_title}
    Response Should Contain Property With Value    path      ${unbound_merchant_path}
    Response Should Contain Property With Value    message   ${access_denied_message}

TC_O2O_00069
    [Documentation]    [ViewProfile] User has already bound the shop - Match Merchant ID
    [Tags]    Merchant    Regression    High
    [Setup]   Submit Auto Binding Request    ${valid_mid}
    Get Merchant Profile By Merchant ID    ${VALID_MERCHANT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value       storeName        ${store_name}
    [Teardown]  Submit Unbind Request     ${valid_mid}

TC_O2O_00070
    [Documentation]    [ViewProfile] User has already bound the shop - Mismatch Merchant ID
    [Tags]    Merchant    Regression    Medium
    [Setup]   Submit Auto Binding Request    ${valid_mid}
    Get Merchant Profile By Merchant ID    ${mismatch_merchant_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    detail    ${access_denied_detail}
    Response Should Contain Property With Value    title     ${access_denied_title}
    Response Should Contain Property With Value    path      ${mismatch_merchant_path}
    Response Should Contain Property With Value    message   ${access_denied_message}
    [Teardown]  Submit Unbind Request     ${valid_mid}

TC_O2O_00414
    [Documentation]    [ViewProfile] User has already bound the shop - Incorrect Merchant ID
    [Tags]    Merchant    Regression    Medium
    [Setup]   Submit Auto Binding Request    ${valid_mid}
    Get Merchant Profile By Merchant ID    ${incorrect_merchant_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    detail    ${access_denied_detail}
    Response Should Contain Property With Value    title     ${access_denied_title}
    Response Should Contain Property With Value    path      ${incorrect_merchant_path}
    Response Should Contain Property With Value    message   ${access_denied_message}
    [Teardown]  Submit Unbind Request     ${valid_mid}
