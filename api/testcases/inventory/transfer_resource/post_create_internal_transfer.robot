*** Settings ***
Documentation    Tests to verify that create internal transfer api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/inventory/adjustment_resource_keywords.robot
Resource    ../../../keywords/inventory/transfer_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${product_name}   Iphone 11 plus
${destination_location_id}  18
${product_quantity}  ${10.0}
${reserve_product_quatity}  ${1.0}
${negative_product_quatity}  ${-1.0}
${not_exist_location_id}   ${999}
${not_exist_destination_location_id}   ${999}
${not_exist_company}    My Companys
${not_exist_product_ref}   notExistProductRef
${not_exist_variant_ref}   notExistVariantRef

*** Test Cases ***
TC_O2O_14547
    [Documentation]  To verify return and response when user creates internal transfer with valid value
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
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
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With Value  $.status   ASSIGNED
    Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..quantity  ${reserve_product_quatity}

TC_O2O_14555
    [Documentation]  To verify return and response when user creates internal transfer with quantity is negative
    [Tags]   Regression   Medium   Smoke  UnitTest
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "RELEASE_202011_001", "variantRef": "SKU_RELEASE_202011_001", "quantity": "${negative_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.validation
    Response Should Contain Property With Value  $.fieldErrors..field    productVariants[0].quantity
    Response Should Contain Property With Value  $.fieldErrors..message     Positive

TC_O2O_14565
    [Documentation]  To verify return and response when user creates internal transfer with source location which is not exist
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "${not_exist_location_id}", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.not_exist.location

TC_O2O_14566
    [Documentation]  To verify return and response when user creates internal transfer with destination location which is not exist
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${not_exist_destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.not_exist.location

TC_O2O_14567
    [Documentation]  To verify return and response when user creates internal transfer with company which is not exist
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "${not_exist_company}", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.not_exist.company

TC_O2O_14568
    [Documentation]  To verify return and response when user creates internal transfer with product ref which is not exist
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${not_exist_product_ref}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.not_exist.product

TC_O2O_14569
    [Documentation]  To verify return and response when user creates internal transfer with variant ref which is not exist
    [Tags]   Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${not_exist_variant_ref}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message   error.not_exist.product_variant