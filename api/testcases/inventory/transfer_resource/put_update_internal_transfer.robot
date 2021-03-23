*** Settings ***
Documentation    Tests to verify that update internal transfer transaction api works correctly

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
${complete_internal_transfer_status}  DONE
${invalid_internal_transfer_status}   COMPLETE
${not_exist_internal_transfer_id}  999

*** Test Cases ***
TC_O2O_14540
    [Documentation]  To verify return and response when user updates status to complete internal transfer with valid status
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
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
    Get Created Internal Transfer ID From Response
    Put Internal Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${INTERNAL_TRANSFER_ID}   { "status": "${complete_internal_transfer_status}" }
    Response Correct Code  ${SUCCESS_CODE}
    Response Should Contain Property With Value  $.status  DONE
    Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..quantity  ${reserve_product_quatity}

TC_O2O_14541
    [Documentation]  To verify return and response when user updates status to complete internal transfer with invalid status
    [Tags]    Regression   High  UnitTest
    Generate Random Stock Transaction
    Post Create Internal Transfer  ${INVENTORY_PROJECT_ID}  { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "destinationLocationId": "${destination_location_id}", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Get Created Internal Transfer ID From Response
    Put Internal Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${INTERNAL_TRANSFER_ID}   { "status": "${invalid_internal_transfer_status}" }
    Response Correct Code  ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.message  error.http.400

TC_O2O_14543
    [Documentation]  To verify return and response when user updates status to complete internal transfer with id does not exist
    [Tags]    Regression   High  UnitTest
    Put Internal Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${not_exist_internal_transfer_id}   { "status": "${complete_internal_transfer_status}" }
    Response Correct Code  ${NOT_FOUND_CODE}