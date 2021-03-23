*** Settings ***
Library    Collections
Library    JSONLibrary

*** Keywords ***
Read Json From File
    [Documentation]    This keyword read data from file with json format
    ...                How to use it:
    ...                Read Json from file path that recieved
    [Arguments]    ${data_file}
    ${dummy_data_file_path}=    Catenate    SEPARATOR=/    ${CURDIR}    ${data_file}
    ${json_dummy_data}=    Load JSON From File    ${dummy_data_file_path}
    Set Test Variable    ${json_dummy_data}

Update Json Data
    [Documentation]    This keyword update the json field from json_dummy_data variable
    ...                How to use it:
    ...                Update Json Data    $.merchantId    'abc'
    [Arguments]    ${json_path}    ${value}
    ${json_dummy_data}=    Update Value To Json    ${json_dummy_data}    ${json_path}    ${value}
    Set Test Variable    ${json_dummy_data}
