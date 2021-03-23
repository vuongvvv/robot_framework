*** Settings ***
Library    OperatingSystem
Library    String
Library    Collections   

*** Keywords ***
Get Line Content From File
    [Arguments]    ${file_path}    ${line_number}=0
    ${api_folder_file_path}=    Fetch From Left    ${CURDIR}    /keywords
    ${file_content}=    Get File    ${api_folder_file_path}${file_path}
    @{list_file_content}=    Split String    ${file_content}    separator=${\n}
    [Return]    @{list_file_content}[${line_number}]