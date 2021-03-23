*** Settings ***
Documentation    Tests to verify that update delivery transfer transaction api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/inventory/adjustment_resource_keywords.robot
Resource    ../../../keywords/inventory/transfer_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${product_name}   Iphone 11 plus
${product_quantity}  ${10.0}
${reserve_product_quatity}  ${1.0}
${complete_delivery_transfer_status}  DONE
${invalid_delivery_transfer_status}  SUCCESS
${cancel_delivery_transfer_status}   CANCEL

*** Test Cases ***
TC_O2O_13890
    [Documentation]  Verify return and response when updates status with valid status
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
     Get Random Internal Reference ID
     Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${product_name}", "price": "25900", "companyName": "My Company"}
     Response Correct Code    ${CREATED_CODE}
     Get Created Product ID From Response
     Post Create Product Variants    ${INVENTORY_PROJECT_ID}    ${PRODUCT_ID}    {"variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}" }
     Response Correct Code    ${CREATED_CODE}
     Generate Random Stock Transaction
     Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity}" } ] }
     Response Correct Code    ${CREATED_CODE}
     Generate Random Stock Transaction
     Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}","variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
     Response Correct Code    ${CREATED_CODE}
     Get Created Delivery Transfer ID From Response
     Put Update Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${DELIVERY_TRANSFER_ID}   { "status": "${complete_delivery_transfer_status}" }
     Response Correct Code    ${SUCCESS_CODE}
     Response Should Contain Property With Value  $.status  DONE
     Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
     Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
     Response Should Contain Property With Value  $.productVariants..quantity  ${reserve_product_quatity}

TC_O2O_13891
    [Documentation]  Verify return and response when updates status with invalid status
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}","variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Get Created Delivery Transfer ID From Response
    Put Update Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${DELIVERY_TRANSFER_ID}   { "status": "${invalid_delivery_transfer_status}" }
    Response Correct Code   ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.title  Bad Request

TC_O2O_13893
    [Documentation]  Verify return and response when updates status which is already canceled
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}","variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Get Created Delivery Transfer ID From Response
    Put Update Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${DELIVERY_TRANSFER_ID}   { "status": "${cancel_delivery_transfer_status}" }
    Response Correct Code     ${SUCCESS_CODE}
    Put Update Delivery Transfer  ${INVENTORY_PROJECT_ID}   ${DELIVERY_TRANSFER_ID}   { "status": "${complete_delivery_transfer_status}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.errorKey  Could not complete delivery transfer: ${DELIVERY_TRANSFER_ID}because it has been already cancelled