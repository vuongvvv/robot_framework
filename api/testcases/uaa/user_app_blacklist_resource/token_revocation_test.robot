*** Settings ***
Documentation    Tests to verify that revoke token succeed and
...              fail correctly depending from users input values.

Resource            ../../../resources/init.robot
Resource            ../../../keywords/uaa/user_app_blacklist_resource_keywords.robot
Test Setup    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${user_id}                  4
${not_found_user_id}        999999999
${invalid_user_id}          011111111
${client_id}                1
${invalid_client_id}        999999999
${invalid_token_error}      invalid_token
${not_found_error}          Not Found
${not_found_user_error}     user id not found
${not_found_client_error}   client id not found
${null_user_client_error}   An userAppBlacklist cannot be null for both client id and user id
${access_denied_error}      Access is denied
${bad_request_error}        Bad Request
${regex_id}                 ^\\d+$
${regex_date}               ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d+Z$

*** Test Cases ***
TC_O2O_02362
    [Documentation]    [Revoke] Verify to make sure that revoke the user access token successful by the UserID
    [Tags]      Regression     Revoke     High        UAA
    Revoke User And Client Token          null       ${user_id}
    Response Correct Code                 ${CREATED_CODE}
    [Teardown]    Restore Token Revocation       ${created_revoke_id}

TC_O2O_02363
    [Documentation]    [Revoke] Verify to make sure that revoke the user access token successful by the ClientID
    [Tags]      Regression     Revoke     High        UAA
    Revoke User And Client Token        ${client_id}     null
    Response Correct Code               ${CREATED_CODE}
    [Teardown]    Restore Token Revocation        ${created_revoke_id}

TC_O2O_02364
    [Documentation]    [Revoke] Verify to make sure that revoke the user access token successful by the UserID & ClientID
    [Tags]      Regression     Revoke     High        UAA
    Revoke User And Client Token        ${client_id}          ${user_id}
    Response Correct Code               ${CREATED_CODE}
    [Teardown]    Restore Token Revocation        ${created_revoke_id}

TC_O2O_02365
    [Documentation]    [Revoke] Verify the error message when the user send the invalid (expired) access token at the request header
    [Tags]      Regression     Revoke     Medium        UAA
    Revoke With The Invalid Token            ${user_id}    ${client_id}
    Response Correct Code                    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_02367
    [Documentation]    [Revoke] Verify the error message when the user send the invalid clientID (client not found)
    [Tags]      Regression     Revoke     Medium        UAA
    Revoke User And Client Token                    ${invalid_client_id}  null
    Response Correct Code                           ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    title    ${not_found_client_error}

TC_O2O_02368
    [Documentation]    [Revoke] Verify the error message when the user send the null client ID and null user ID
    [Tags]      Regression     Revoke     Medium        UAA
    Revoke User And Client Token                    null       null
    Response Correct Code                           ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${null_user_client_error}

TC_O2O_02679
    [Documentation]    [Blacklist] Displayed all blacklist accounts - User permission
    [Tags]      Regression     Blacklist     UserList     Medium        UAA
    [Setup]    Generate Gateway Header With Scope and Permission    ${UAA_USERNAME}    ${UAA_USERNAME_PASSWORD}    permission_name=uaa.user-app-blacklist.actAsAdmin
    [Teardown]    Delete Created Client And User Group
    # Generate Access Token    ${UAA_BLACKLIST_LIST_USERNAME}    ${UAA_BLACKLIST_LIST_PASSWORD}
    Get All Blacklist
    Response Correct Code                           ${SUCCESS_CODE}
    Response Should Contain All Property Values Match Regex    .id     ${regex_id}
    Response Should Contain All Property Values Match Regex    .revocationDate    ${regex_date}
    Response Should Contain All Property Values Are Integer    .userId
    Response Should Contain All Property Values Are Integer    .clientId

TC_O2O_02680
    [Documentation]    [Blacklist] Displyed all blacklist account - User doesn't have permission
    [Tags]      Regression     Blacklist     UserGet     Medium        UAA
    Generate Access Token    ${UAA_BLACKLIST_GET_USERNAME}    ${UAA_BLACKLIST_GET_PASSWORD}
    Get All Blacklist
    Response Correct Code                           ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    detail    ${access_denied_error}

TC_O2O_02681
    [Documentation]    [Blacklist] Displyed all blacklist account - Access Token Expired
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Get All Blacklist With Invalid Token
    Response Correct Code                           ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_02683
    [Documentation]    [Blacklist] Displyed all blacklist account but endpoint is invalid
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Get All Blacklist With Invalid Endpoint
    Response Correct Code                           ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    error    ${not_found_error}

TC_O2O_02686
    [Documentation]    [BlacklistDetail] Displayed blacklist details - User Permission
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Revoke User And Client Token          null       ${user_id}
    Generate Access Token    ${UAA_BLACKLIST_GET_USERNAME}    ${UAA_BLACKLIST_GET_PASSWORD}
    Get Blacklist Detail      ${created_revoke_id}
    Response Correct Code                           ${SUCCESS_CODE}
    Response Should Contain Property Matches Regex    .id     ${regex_id}
    Response Should Contain Property Matches Regex    .revocationDate    ${regex_date}
    Response Should Contain All Property Values Are Integer    .userId
    Response Should Contain All Property Values Are Integer    .clientId

TC_O2O_02687
    [Documentation]    [BlacklistDetail] Request view blacklist details with invalid ID
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Generate Access Token    ${UAA_BLACKLIST_GET_USERNAME}    ${UAA_BLACKLIST_GET_PASSWORD}
    Get Blacklist Detail   ${invalid_user_id}
    Response Correct Code                           ${NOT_FOUND_CODE}

TC_O2O_02688
    [Documentation]    [BlacklistDetail] Request view blacklist detail with the null ID
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Generate Access Token    ${UAA_BLACKLIST_GET_USERNAME}    ${UAA_BLACKLIST_GET_PASSWORD}
    Get Blacklist Detail    null
    Response Correct Code                           ${BAD_REQUEST_CODE}
   Response Should Contain Property With Value    title    ${bad_request_error}

TC_O2O_02689
    [Documentation]    [BlacklistDetail] View blacklist details - Access Token Expired
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Get Blacklist Detail With Invalid Token    ${created_revoke_id}
    Response Correct Code                           ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_02691
    [Documentation]    [BlacklistDetail] View blacklist details has invalid Endpoint
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Revoke User And Client Token          null       ${user_id}
    Get Blacklist Detail With Invalid Endpoint        ${created_revoke_id}
    Response Correct Code                           ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    error    ${not_found_error}

TC_O2O_02693
    [Documentation]    [DeleteBlacklist] Delete blacklist account - Admin Permission
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Revoke User And Client Token          null       ${user_id}
    Get Blacklist Detail      ${created_revoke_id}
    Delete Blacklist   ${created_revoke_id}
    Get Blacklist Detail      ${created_revoke_id}
    Response Correct Code                           ${NOT_FOUND_CODE}

TC_O2O_02694
    [Documentation]    [DeleteBlacklist] Delete blacklist accounts - User permission
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Revoke User And Client Token          null       ${user_id}
    Delete Blacklist   ${created_revoke_id}
    Get All Blacklist
    Check Deleted Blacklist        .id           ${created_revoke_id}

TC_O2O_02696
    [Documentation]    [DeleteBlacklist] User delete blacklist account with null ID
    [Tags]      Regression     Blacklist     Admin     Medium        UAA      Getblacklist
    Generate Access Token    ${UAA_BLACKLIST_GET_USERNAME}    ${UAA_BLACKLIST_GET_PASSWORD}
    Delete Blacklist    null
    Response Correct Code                           ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_error}

TC_O2O_02697
    [Documentation]    [DeleteBlacklist] Delete blacklist account - Access Token Expired
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Delete Blacklist With Invalid Token    ${user_id}
    Response Correct Code                           ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}

TC_O2O_02699
    [Documentation]    [DeleteBlacklist] Delete blacklist account has invalid Endpoint
    [Tags]      Regression     Blacklist     ActAsAdmin     Medium        UAA
    Delete Blacklist With Invalid Endpoint       ${user_id}
    Response Correct Code                           ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    error    ${not_found_error}