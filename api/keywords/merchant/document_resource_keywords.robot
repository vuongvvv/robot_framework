*** Settings ***
Resource    ../../resources/testdata/merchant/upload_files/merchant_upload_data.robot

*** Keywords ***
# https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1288438274/API+upload+KYB+document
Post Upload
    [Arguments]    ${provider}    ${content}    ${file_name}
    Remove From Dictionary    ${GATEWAY_HEADER}    Content-Type
    ${file_path}    Get File Path    ${file_name}
    ${path_to_file}    ${file_extension}    Split Extension    ${file_path}
    ${upload_file}=    Run Keyword If    '${file_extension}'=='pdf'    Evaluate  {'file': ('${file_name}', open("${file_path}", 'r+b'), 'application/${file_extension}')}
    ...    ELSE IF    '${file_extension}'=='jpg'    Evaluate  {'file': ('${file_name}', open("${file_path}", 'r+b'), 'image/jpeg')}
    ...    ELSE    Evaluate  {'file': ('${file_name}', open("${file_path}", 'r+b'), 'image/${file_extension}')}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /merchant-v2/api/upload/kyb/${provider}/document    data=${content}    files=${upload_file}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    Set To Dictionary    ${GATEWAY_HEADER}    Content-Type=application/json
    
Generate Content To Upload
    [Arguments]    ${ref_id}    ${type}    ${content}
    &{TEST_DATA_UPLOAD_CONTENT}    Create Dictionary    refId=${ref_id}    type=${type}    content=${content}
    Set Test Variable    ${TEST_DATA_UPLOAD_CONTENT}