*** Keywords ***
Create Egg Digital Session
    [Arguments]     ${egg_digital_host}
    Create Session    ${EGG_DIGITAL_SESSION}    ${egg_digital_host}    verify=true

Create Egg Digital Header
    [Arguments]     ${egg_digital_host_url}=${EGG_DIGITAL_HOST}
    &{headers}=    Create Dictionary    Content-Type=application/json
    Create Egg Digital Session    ${egg_digital_host_url}
    Set Suite Variable    &{EGG_DIGITAL_HEADERS}    &{headers}