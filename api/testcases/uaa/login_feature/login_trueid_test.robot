*** Settings ***
Documentation    Tests to verify that login with social account succeed and
...              fail correctly depending from users input values.

Resource          ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource          ../../../keywords/uaa/login_trueid_keywords.robot
Test Setup        Create Gateway Session

*** Variables ***
${trueid_provider}                  trueid
${trueid_username}                  ${TRUE_ID_USER}
${trueid_password}                  ${TRUE_ID_USER_PASSWORD}
${trueid_login_url}                 ${API_HOST}/uaa/api/social/signin/${trueid_provider}
${invalid_provider}                 testid
${no_provider_detail_message}       No connection factory for service provider '${invalid_provider}' is registered
${server_error_title_message}       Internal Server Error
${not_found_error_message}          Not Found
${wrong_authentication_key}         Basic d2ViX2FwcDpjaGFuZ2VwYXNz
${wrong_authentication_format}      Basic a
${failed_decode_detail_message}           Failed to decode basic authentication token
${full_authentication_detail_message}     Full authentication is required to access this resource
${bad_credentials_detail_message}         Bad credentials
${invalid_login_code}               6f78d6375023aabe8fd47155ceb1ca149ffdcddf

*** Test Cases ***
TC_O2O_01489
    [Documentation]     Check if the user is able to load the login page successful via the API
    [Tags]      Regression
    Load The Login Page                 ${trueid_provider}
    Response Correct Code               ${SUCCESS_CODE}

TC_O2O_01491
    [Documentation]     Check to make sure the user is able to login TrueID via the API with the valid returned code
    [Tags]      Regression     Smoke    uaa    trueid
    Open Browser With Option    ${trueid_login_url}
    Login TrueID On Website    ${trueid_username}    ${trueid_password}
    Get Login Code And State
    Login TrueID Account
    Response Correct Code    ${SUCCESS_CODE}
    [Teardown]  Close Browser

TC_O2O_01490
    [Documentation]     Check for no connection factory for service provider
    [Tags]      Regression
    Load The Login Page                 ${invalid_provider}
    Response Correct Code               ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    title     ${server_error_title_message}
    Response Should Contain Property With Value    detail    ${no_provider_detail_message}

TC_O2O_01492
    [Documentation]     Login should be failed with the invalid code
    [Tags]      Regression
    Open Browser With Chrome Headless Mode                    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}              ${trueid_password}
    Get Login Code And State
    Login TrueID Account         ${AUTHORIZATION_KEY}     ${invalid_login_code}
    Response Correct Code                ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    title     ${server_error_title_message}
    [Teardown]  Close Browser

TC_O2O_01493
    [Documentation]     Login should be failed with the expired / authorization code has been used
    [Tags]      Regression
    Open Browser With Chrome Headless Mode                    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}              ${trueid_password}
    Get Login Code And State
    Login TrueID Account         # Use the login code at the first time
    Login TrueID Account         # Reuse the old login code (code has been used)
    Response Correct Code        ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    title     ${server_error_title_message}
    [Teardown]  Close Browser

TC_O2O_01545
    [Documentation]     Check if the user empty the provider name, it should be returned 404
    [Tags]      Regression
    Load The Login Page                 ${EMPTY}
    Response Correct Code               ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    message    ${not_found_error_message}

TC_O2O_01546
    [Documentation]     Access the API with the wrong basic authentication
    [Tags]      Regression
    Open Browser With Chrome Headless Mode                    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}       ${trueid_password}
    Get Login Code And State
    Login TrueID Account         ${wrong_authentication_key}
    Response Correct Code                ${UNAUTHORIZED}
    Response Should Contain Property With Value    detail    ${bad_credentials_detail_message}
    [Teardown]  Close Browser

TC_O2O_01547
    [Documentation]     Access the API without the basic authentication
    [Tags]      Regression
    Open Browser With Chrome Headless Mode                    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}       ${trueid_password}
    Get Login Code And State
    Login TrueID Account         ${EMPTY}
    Response Correct Code                ${UNAUTHORIZED}
    Response Should Contain Property With Value    detail    ${full_authentication_detail_message}
    [Teardown]  Close Browser

TC_O2O_01548
    [Documentation]     Access the API with the wrong format of the basic authentication
    [Tags]      RegressionExclude_ASCO2O-5069
    Open Browser With Chrome Headless Mode                    ${trueid_login_url}
    Login TrueID On Website      ${trueid_username}       ${trueid_password}
    Get Login Code And State
    Login TrueID Account         ${wrong_authentication_format}
    Response Correct Code                ${UNAUTHORIZED}
    Response Should Contain Property With Value    detail    ${failed_decode_detail_message}
    [Teardown]  Close Browser
