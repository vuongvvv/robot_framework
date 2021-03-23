*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Get Search Category
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/categories    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Category Id From Name
    [Arguments]    ${category_name_en}
    ${TEST_DATA_CATEGORY_ID}=    Get Property Value By Another Property Value    .categoryNameEn    ${category_name_en}    .categoryId
    Set Test Variable    ${TEST_DATA_CATEGORY_ID}