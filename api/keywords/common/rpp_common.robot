*** Keywords ***
Create RPP Session
    Create Session    ${RPP_SESSION}    ${RPP_HOST}    verify=true

Create RPP Header
    &{headers}=    Create Dictionary    Content-Type=application/json
    Create RPP Session
    Set Suite Variable    &{RPP_HEADER}    &{headers}
