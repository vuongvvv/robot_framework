*** Settings ***
Documentation    Tests to verify that create product variants api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/common/string_common.robot

Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}    scope=inventory.product.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${invalid_product_id}     999999
${product_name}   Iphone 11 plus

*** Test Cases ***
TC_O2O_13469
    [Documentation]  To verify return and response when user creates product variants with valid value
    [Tags]   Regression   High   Sanity
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${product_name}", "price": "25900", "companyName": "My Company"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Get Created Product ID From Response
    Post Create Product Variants  ${INVENTORY_PROJECT_ID}    ${PRODUCT_ID}    {"variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}

TC_O2O_13472
    [Documentation]  To verify return and response when user creates product variants with product internal reference which is not exist
    [Tags]   Regression   High   Sanity
    Post Create Product Variants  ${INVENTORY_PROJECT_ID}    ${invalid_product_id}   {"variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value   $.title    not_exist.product
    Response Should Contain Property With Value   $.message   error.not_exist.product