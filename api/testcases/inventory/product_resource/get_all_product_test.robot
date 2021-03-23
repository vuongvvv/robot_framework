*** Settings ***
Documentation    Tests to verify that search product filter api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/common/string_common.robot

Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}    scope=inventory.product.r,inventory.product.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${invalid_product_id}    999999
${name}   Iphone 11 plus

*** Test Cases ***
TC_O2O_13449
    [Documentation]  To verify return and response when user gets data with valid internal reference
    [Tags]   Joker2019S24   Regression   High   Smoke    ASCO2O-19151
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${name}", "price": "25900", "companyName": "My Company"}
    Response Correct Code    ${CREATED_CODE}
    Get Created Product ID From Response
    Get All Products  ${INVENTORY_PROJECT_ID}  ${PRODUCT_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value    $.productRef  ${RANDOM_INTERNAL_REFERENCE_ID}

TC_O2O_13450
    [Documentation]  To verify return and response when user gets data with internal reference which is not exist in the system
    [Tags]   Joker2019S24   Regression   High   Smoke    ASCO2O-19151
    Get All Products  ${INVENTORY_PROJECT_ID}  ${invalid_product_id}
    Response Correct Code    ${NOT_FOUND_CODE}