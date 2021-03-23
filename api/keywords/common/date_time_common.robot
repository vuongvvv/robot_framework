*** Settings ***
Library    DateTime

*** Keywords ***
Get Date With Format And Increment
    [Arguments]    ${result_format}    ${increment}=0
    ${desired_date} =    Get Current Date    result_format=${result_format}    increment=${increment}
    Set Test Variable    ${DESIRED_DATE}    ${desired_date}
    [Return]    ${desired_date}

Get Unix Time Stamp From Current Date
    [Arguments]   ${result_format}
    ${desired_date} =    Get Current Date    result_format=${result_format}
    ${UNIX_TIME_STAMP}=   Convert Date   ${desired_date}     epoch
    Set Test Variable    ${UNIX_TIME_STAMP}