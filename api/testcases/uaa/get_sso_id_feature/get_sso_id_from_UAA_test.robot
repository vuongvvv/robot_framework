*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../../web/resources/init.robot
Resource    ../../../keywords/uaa/get_sso_id_keywords.robot
Resource          ../../../keywords/uaa/login_trueid_keywords.robot

Test Setup        Create Gateway Session

*** Variables ***
${expired_access_token}    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJ0cnVlaWQtMjE5NzE5MzQiLCJzY29wZSI6WyJtZW1iZXJzaGlwLm1lbWJlci5zdWJzY3JpYmUiLCJpbXBsaWNpdCIsImhpc3RvcnkuaGlzdG9yeS5hY3RBc0FkbWluIiwibWVyY2hhbnRUeC5jcmVhdGUiLCJlc3RhbXAucmV3YXJkLmFjdEFzQWRtaW4iLCJjYW1wYWlnbi51c2FnZS5jcmVhdGUiLCJjYW1wYWlnbi51c2FnZS5saXN0IiwiZXN0YW1wLmNhbXBhaWduLmFjdEFzQWRtaW4iLCJiYXRjaF9wcm9jZXNzb3IiLCJtYXBwaW5nLnJlYWQiLCJwYXNzd29yZCIsImNhbXBhaWduLmNhbXBhaWduLmFjdEFzQWRtaW4iLCJtZW1iZXJzaGlwLm1lbWJlci5wdWJsaWNDcmVhdGUiLCJwb2ludC5tc2cuZGxxLWwiLCJhdXRob3JpemF0aW9uX2NvZGUiLCJlc3RhbXAuYnJhbmNoLmFjdEFzQWRtaW4iLCJjYW1wYWlnbi5wcm9tb3Rpb24udXBkYXRlIiwiZXN0YW1wLm1lcmNoYW50LmFjdEFzQWRtaW4iLCJlc3RhbXAuc3RhdHVzLmFjdEFzQWRtaW4iLCJjYW1wYWlnbi5wcmlvcml0eS5jcmVhdGUiLCJjYW1wYWlnbi5wcm9tb3Rpb24uZGV0YWlsIiwicmVmcmVzaF90b2tlbiIsIm1lcmNoYW50Lm91dGxldC5hY3RBc0FkbWluIiwicGVybWlzc2lvbi5yZWFkIiwiY2FtcGFpZ24ucHJvbW90aW9uLnNlYXJjaCIsImNhbXBhaWduLnByb21vdGlvbi5jcmVhdGUiLCJwYXltZW50VHguY3JlYXRlIiwibWVyY2hhbnQubWVyY2hhbnQucmVhZCIsInJwcC1zeW5jLWJhdGNoIl0sImV4cCI6MTU1MDUyODc5NCwiaWF0IjoxNTUwMjI4Nzk0LCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwianRpIjoiODZjZDdiOGUtZDM3OS00NjJjLWFhNjctMTEzYmY4M2IxOTAxIiwiY2xpZW50X2lkIjoiYWRtaW50b29scyJ9.dz4XsJT9cg377Rgf9gCSlo3yY_F4-i324bfR9tObTRFizHCetVGZBtF6D2uxan-3QlDgwW_bFk2Ce2ErobMeF4rblPBY6Bow8IZ-hVjJiAE3yayd_V-SLglH27meuFHX5DN4hTf_JWrmVZ6kADmLK0FvgQas613ba9597CpWXthSM6G0VRs-KsFvhGRqivd7_uOyYd-4nwZQ0xmC9Wx4653M0HLLWVL6wc8U25-GhyZQDaIjmo721W1JX4q-KeAeW3rXBtINrqVpTreqVgjZVymW-9B1PknjdHkPRzFOc7DrGkPV6Bjfy2b20qazrRMiAcuThkEfcmst1hc4pioh_Q
${invalid_access_token}    tZW1iZXIuc3Vic2eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJhZG1pbiIsInNjb3BlIjpbImVzdGFtcC5tZXJjaGFudC5hY3RBc0FkbWluIiwibWV
${invalid_token_error}    invalid_token
${expired_token_message}    "error_description": "Access token expired
${invalid_token_message}    Cannot convert access token to JSON
${provider_id}    trueid

*** Test Cases ***
TC_O2O_05087
    [Documentation]    [API][SSO] Verify API returns 200 OK if user get sso_id sucessfully
    [Tags]    Regression    High    Smoke    uaa    trueid
    Get Access Token From TrueID    ${TRUE_ID_USER}    ${TRUE_ID_USER_PASSWORD}
    Get SSO ID From UAA With Access Token    ${ACCESS_TOKEN}    ${provider_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    providerId    ${provider_id}

TC_O2O_05089
    [Documentation]    [API][SSO] Verify API returns 401 Unauthorized if user get sso_id with expire token
    [Tags]    Regression    Medium    BE-UAA    O2O-8921    Minos-2019S05
    Get SSO ID From UAA With Access Token    ${expired_access_token}    ${provider_id}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}
    Response Correct Message    ${expired_token_message}

TC_O2O_05090
    [Documentation]    [API][SSO] Verify API returns 401 Unauthorized if user get sso_id with invalid token
    [Tags]    Regression    Medium    BE-UAA    O2O-8921    Minos-2019S05
    Get SSO ID From UAA With Access Token    ${invalid_access_token}    ${provider_id}
    Response Correct Code    ${UNAUTHORIZED}
    Response Should Contain Property With Value    error    ${invalid_token_error}
    Response Should Contain Property With Value    error_description    ${invalid_token_message}
