*** Settings ***
Resource    ../common/json_common.robot

*** Keywords ***
Get Search Sub Category
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /merchant-v2/api/subcategories    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    
Fetch Sub Category Id From Category Id
    [Arguments]    ${category_id}
    ${TEST_DATA_SUB_CATEGORY_ID}=    Get Property Value By Another Property Value    .categoryId    ${category_id}    .subCategoryId
    Set Test Variable    ${TEST_DATA_SUB_CATEGORY_ID}