*** Settings ***
Documentation    Tests to verify that create adjustment api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/inventory/adjustment_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}    scope=inventory.product.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${product_name}   Iphone 11 plus
${product_quantity}  ${10.0}
${invalid_product_quantity_type}  TEN
${negative_product_quantity}   ${-5.0}
${invalid_location_id}  999
${invalid_company_name}   NotExistCompany

*** Test Cases ***
TC_O2O_13475
    [Documentation]  Verify return and response of adjustment when inventory has product in the company line in case of units in the real stock don't match with units in the inventory system
    [Tags]  ASCO2O-8632   Regression   Smoke   High  UnitTest
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${product_name}", "price": "25900", "companyName": "My Company"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Get Created Product ID From Response
    Post Create Product Variants    ${INVENTORY_PROJECT_ID}    ${PRODUCT_ID}    {"variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..quantity  ${product_quantity}

TC_O2O_13498
    [Documentation]  Verify return and response of adjustment when inventory have this product in the company line and the product variant line in case of the quantity isn't numeric type
    [Tags]  ASCO2O-8632   Regression   Smoke   High
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${invalid_product_quantity_type}" } ] }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value   $.type  https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value   $.message  error.http.400

TC_O2O_13499
    [Documentation]  Verify return and response of adjustment when inventory have this product in the company line and the product variant line in case of the quantity is negative numeric type
    [Tags]  ASCO2O-8632   Regression   Smoke   High
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${negative_product_quantity}" } ] }
    Response Correct Code   ${NOT_FOUND_CODE}
    Response Should Contain Property With Value  $.type  https://www.jhipster.tech/problem/problem-with-message
    Response Should Contain Property With Value  $.message  https://www.jhipster.tech/problem/entity-not-found

TC_O2O_13500
    [Documentation]  Verify return and response with location which doesn't exist
    [Tags]  ASCO2O-8632   Regression   Sanity   High  UnitTest
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "${invalid_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity}" } ] }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.errorKey  not_exist.location

TC_O2O_13501
    [Documentation]  Adjust with company which doesn't exist
    [Tags]  ASCO2O-8632   Regression   Sanity   High  UnitTest
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "${invalid_company_name}", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity}" } ] }
    Response Correct Code  ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.errorKey  not_exist.company