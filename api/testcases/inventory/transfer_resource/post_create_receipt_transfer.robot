*** Settings ***
Documentation    Tests to verify that create receipt transfer api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/inventory/adjustment_resource_keywords.robot
Resource    ../../../keywords/inventory/transfer_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${product_name}   Receipt transfer project
${destination_location_id}  18
${negative_product_quatity}  ${-1.0}
${not_exist_destination_location_id}   ${999}
${receipt_product_quatity}   ${1.0}
${product_quantity}  ${10.0}

*** Test Cases ***
TC_O2O_13908
    [Documentation]  Verify return and response when creates receipt transfer with valid value
    [Tags]   ASCO2O-9841   Regression    High    Smoke   UnitTest
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${product_name}", "price": "25900", "companyName": "My Company"}
    Response Correct Code    ${CREATED_CODE}
    Get Created Product ID From Response
    Post Create Product Variants  ${INVENTORY_PROJECT_ID}    ${PRODUCT_ID}    {"variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}" }
    Response Correct Code    ${CREATED_CODE}
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Generate Random Stock Transaction
    Post Create Receipt Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "destinationLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${receipt_product_quatity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value  $.status   DONE
    Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..quantity  ${receipt_product_quatity}

TC_O2O_13909
    [Documentation]  Verify return and response when creates receipt transfer with location which does not exist
    [Tags]   ASCO2O-9841   Regression    Medium    Smoke   UnitTest
    Generate Random Stock Transaction
    Post Create Receipt Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "destinationLocationId": "${not_exist_destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${receipt_product_quatity}" } ] }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.entityName   adjustment
    Response Should Contain Property With Value  $.errorKey    not_exist.location

TC_O2O_13921
    [Documentation]  Verify return and response when creates receipt transfer with negative value of quantity
    [Tags]   ASCO2O-9841   Regression    Medium    Smoke   UnitTest
    Generate Random Stock Transaction
    Post Create Receipt Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "destinationLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${negative_product_quatity}" } ] }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.validation
    Response Should Contain Property With Value  $.fieldErrors..field    productVariants[0].quantity
    Response Should Contain Property With Value  $.fieldErrors..message     Positive