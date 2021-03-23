*** Settings ***
Documentation    Tests to verify that create delivery transfer api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/inventory/product_variant_resource_keywords.robot
Resource    ../../../keywords/inventory/adjustment_resource_keywords.robot
Resource    ../../../keywords/inventory/transfer_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}    scope=inventory.product.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${product_name}   Iphone 11 plus
${product_quantity}  ${10.0}
${reserve_product_quatity}  ${5.0}
${product_quantity_less_than_order}  ${2.0}
${negative_product_quantity}   ${-1.0}

*** Test Cases ***
TC_O2O_13506
    [Documentation]  Verify return and response of reservation when inventory system has available products more than an order
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
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
     Generate Random Stock Transaction
     Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}","variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
     Response Correct Code    ${CREATED_CODE}
     Response Should Contain Property With Value  $.status   CONFIRMED
     Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
     Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
     Response Should Contain Property With Value  $.productVariants..quantity  ${reserve_product_quatity}

TC_O2O_13507
    [Documentation]  Verify return and response of reservation when inventory system has available products less than an order
    [Tags]    Regression   High   Smoke  UnitTest    ASCO2O-19151
    Generate Random Stock Transaction
    Post Create Adjustment  ${INVENTORY_PROJECT_ID}  { "name": "Stock ${RANDOM_STOCK_TRANSACTION}", "locationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${product_quantity_less_than_order}" } ] }
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.productVariants..productRef  ${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..variantRef  SKU_${RANDOM_INTERNAL_REFERENCE_ID}
    Response Should Contain Property With Value  $.productVariants..quantity  ${product_quantity_less_than_order}
    Generate Random Stock Transaction
    Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "${RANDOM_INTERNAL_REFERENCE_ID}","variantRef": "SKU_${RANDOM_INTERNAL_REFERENCE_ID}", "quantity": "${reserve_product_quatity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.errorKey   not_available.product_variant
    Response Should Contain Property With Value  $.message    error.not_available.product_variant

TC_O2O_13519
    [Documentation]  Verify return and response when reserve with invalid value reservedQuantity
    [Tags]    Regression   High   Smoke
    Generate Random Stock Transaction
    Post Create Delivery Transfer   ${INVENTORY_PROJECT_ID}   { "sourceDocument": "${RANDOM_STOCK_TRANSACTION}", "sourceLocationId": "8", "companyName": "My Company", "productVariants": [ { "productRef": "RELEASE_202011_001","variantRef": "SKU_RELEASE_202011_001", "quantity": "${negative_product_quantity}" } ] }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.title  Method argument not valid
    Response Should Contain Property With Value  $.message  error.validation
    Response Should Contain Property With Value  $.fieldErrors..field  productVariants[0].quantity