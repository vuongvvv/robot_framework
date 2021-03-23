*** Settings ***
Documentation    Tests to verify that login account succeed and
...              fail correctly depending from users input values.

Resource    ../../../resources/init.robot
Resource    ../../../keywords/uaa/login_keywords.robot
Resource    ../../../keywords/uaa/admin_keywords.robot
Test Setup        Create Gateway Session
Test Teardown     Delete All Sessions

*** Variables ***
${valid_username}                     ${UAA_USERNAME}
${valid_password}                     ${ROLE_USER_PASSWORD}
${incorrect_username}                 66639148300
${incorrect_password}                 12345678
${invalid_grant_message}              "error": "invalid_grant"
${invalid_credentials_description}    "error_description": "Bad credentials"
${invalid_token_message}              "error": "invalid_token"
${expired_access_token}               eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI2NjYzOTE0ODM0OCIsInNjb3BlIjpbIm9wZW5pZCJdLCJleHAiOjE1MjExOTgzMTEsImlhdCI6MTUyMTE5NDcxMSwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImp0aSI6ImNlYmFmNDc3LWQwYT
${expired_refresh_token}              eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI2NjQ0NDQ0NDQ0NCIsInNjb3BlIjpbIm9wZW5pZCJdLCJhdGkiOiIxMmUwNmM0MS03Mzk0LTRjZWYtYjUyMS00ODljMGUwZTkzNzUiLCJleHAiOjE1MjM2NzY0NjksImlhdCI6MTU
${invalid_access_token}    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI2NjgxNTU1NTU1NSIsInNjb3BlIjpbIm9wZW5pZCJdLCJleHAiOjE1MjIxMzcwOTQsImlhdCI6MTUyMjEzNjc5NCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9VU0VSIl0sImp0aSI6IjkzN2ViYWE2LWM3MjMtNDdmNS04NDI5LTc5MzMyNjc5YWZjYSIsImNsaWVudF9pZCI6IndlYl9hcHAifQ.iQjhxX4m9HAbvfLX3n3xZt8UQa1w-HgmetgXWdqyIrCii0m6TJLvet64Je-aozJHnTtBG6rEE1mIrlpPIve1lN4gzwqXfGcnma3bV8UEavMLy6GrRLBqQq3KhGVcG-4qxSJ_yg7VDH_X35CmLcZPlXojB-I6D8Z_ihWWE5wOY6cv9mo3WzT73QGwZek0oHYvfMsyNIKccS9VwQtjAXmX2IkPKIhI5B-NzXrqQN1ZYGnZLi709epHcQRSfCkIbZeeRGq4ERN8kVvwjAC3_zR4JETOkUbM1hYWvG-La9f7wDL4T5kqDUOhaXtAQ8zTD0x0ZnOaaa7maWUtR6j0FV-vb
${timestamp_regex}    \\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[.]\\d{3}[+][0]{4}
&{missing_username_data}    password=${valid_password}  grant_type=password
&{missing_password_data}    username=${valid_username}  grant_type=password

*** Test Cases ***
TC_O2O_00073
    [Documentation]     Check if the user is able to login with the valid account.
    [Tags]      Regression     Login     High        UAA
    Login Account               username=${valid_username}  password=${valid_password}  grant_type=password
    Response Correct Code       ${SUCCESS_CODE}

TC_O2O_00074
    [Documentation]     Check if the user input the incorrect user, response header status is 400 (BAD Request)
    [Tags]      Regression     Login     High        UAA
    Login Account               username=${incorrect_username}         password=${valid_password}    grant_type=password
    Response Correct Code       ${BAD_REQUEST_CODE}
    Response Correct Message    ${invalid_grant_message}
    Response Correct Message    ${invalid_credentials_description}

TC_O2O_00075
    [Documentation]     Check if the user input the incorrect password, response header status is 400 (BAD Request)
    [Tags]      Regression     Login     High        UAA
    Login Account               username=${valid_username}         password=${incorrect_password}    grant_type=password
    Response Correct Code       ${BAD_REQUEST_CODE}
    Response Correct Message    ${invalid_grant_message}
    Response Correct Message    ${invalid_credentials_description}

TC_O2O_00076
    [Documentation]     Check if the refresh token is valid and do not expire, response header status should be 200 (OK)
    [Tags]      Regression     Login     High        UAA
    Login Account                    username=${valid_username}  password=${valid_password}  grant_type=password
    Get Access Token From Refresh Token       ${RESPONSE_REFRESH_TOKEN}
    Response Correct Code                     ${SUCCESS_CODE}

TC_O2O_00077
    [Documentation]     Check if the refresh token is expired, response header status is 401 (Unauthorized)
    [Tags]      Regression     Login     High        UAA
    Get Access Token From Refresh Token       ${expired_refresh_token}
    Response Correct Code                     ${UNAUTHORIZED}
    Response Correct Message                  ${invalid_token_message}

TC_O2O_00078
    [Documentation]     Check if the access token is valid and do not expire, response header status should be 200 (OK)
    [Tags]      Regression     Login     High        UAA
    Login Account                                username=${valid_username}         password=${valid_password}    grant_type=password
    Get Account Information With Access Token    ${RESPONSE_ACCESS_TOKEN}
    Response Correct Code                        ${SUCCESS_CODE}

TC_O2O_00079
    [Documentation]     Check if the access token is expired, response header status should be 401 (Unauthorized)
    [Tags]      Regression     Login     High        UAA
    Get Access Token From Refresh Token           ${expired_access_token}
    Response Correct Code      ${UNAUTHORIZED}
    Response Correct Message   ${invalid_token_message}

TC_O2O_00254
    [Documentation]     [API] [Login] Verify "/uaa/oauth/token" with missing username, or missing password
    [Tags]      Regression     Login     High        UAA
    [Template]    Login With Missing Username Or Password Should Fail
    &{missing_username_data}
    &{missing_password_data}

TC_O2O_00255
    [Documentation]     [API] [Login] Verify "/uaa/oauth/token" with missing grant_type
    [Tags]      Regression     Login     High        UAA
    Login Account    username=${valid_username}  password=${valid_password}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    error    invalid_request
    Response Should Contain Property With Value    error_description    Missing grant type

TC_O2O_00256
    [Documentation]     [API] [Login] Verify "/uaa/oauth/token" with incorrect grant_type
    [Tags]      Regression     Login     High        UAA
    Login Account    username=${valid_username}    password=${valid_password}    grant_type=invalid grant type
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    error    unsupported_grant_type
    Response Should Contain Property With Value    error_description    Unsupported grant type: invalid grant type

TC_O2O_00257
    [Documentation]     [API] [Login] Verify "/uaa/api/users/admin" with invalid access_token
    [Tags]      Regression     Login     High        UAA
    Get User Admin Information    Authorization=Bearer ${invalid_access_token}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    invalid_token
    Response Should Contain Property With Value    error_description    Cannot convert access token to JSON

TC_O2O_00258
    [Documentation]     [API] [Login] Verify "/uaa/api/users/admin" with missing access_token
    [Tags]      Regression     Login     High        UAA
    Get User Admin Information
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property Matches Regex    timestamp    ${timestamp_regex}
    Response Should Contain Property With Value    status    ${${UNAUTHORIZED}}
    Response Should Contain Property With Value    error    Unauthorized
    Response Should Contain Property With Value    message  Unauthorized
    Response Should Contain Property With Value    path     /api/users/admin
