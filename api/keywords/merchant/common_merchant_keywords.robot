*** Settings ***
Resource    ../common/api_common.robot

*** Keywords ***
Get Current Timestamp
    ${TIME_STAMP} =    Get Date With Format And Increment    %Y%m%d%H%M%S
    Set Test Variable    ${TIME_STAMP}