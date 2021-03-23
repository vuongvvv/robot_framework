*** Settings ***
Library    OperatingSystem    

*** Keywords ***
Get File Path
    [Arguments]    ${file_name}
    ${return_path}    Set Variable    ${CURDIR}/${file_name}
    [Return]    ${return_path}