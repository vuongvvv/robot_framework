*** Settings ***
Resource    ../uaa/social_resource_keywords.robot

*** Keywords ***
Generate Header With Truemoney Access Token
    [Arguments]    ${truemoney_access_token}
    Post Sign In With Truemoney Token    ${truemoney_access_token}
    ${access_token_after_singn_in_truemoney}=    Get Property Value From Json By Index    access_token    0    ${RESP.json()}
    &{GATEWAY_HEADER}=    Create Dictionary    authorization=Bearer ${access_token_after_singn_in_truemoney}    Content-Type=application/json
    Set Test Variable    &{GATEWAY_HEADER}
