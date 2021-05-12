*** Settings ***
Library    RequestsLibrary    

*** Keywords ***
Create Bitfinex Session
    Create Session    ${BITFINEX_SESSION}    ${BITFINEX_HOST}    verify=true