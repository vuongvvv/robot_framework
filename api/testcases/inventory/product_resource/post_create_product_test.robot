*** Settings ***
Documentation    Tests to verify that create product api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/inventory/product_resource_keywords.robot
Resource    ../../../keywords/common/string_common.robot

Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}    scope=inventory.product.w
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${name}   Iphone 11 plus
${invalid_companyName}   invalid company name

*** Test Cases ***
TC_O2O_13454
    [Documentation]  To verify return and response when user creates product with valid value
    [Tags]   Joker2019S23   Regression   High   Sanity
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${name}", "price": "25900", "companyName": "My Company"}
    Response Correct Code    ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.productRef  ${RANDOM_INTERNAL_REFERENCE_ID}

TC_O2O_13456
    [Documentation]  To verify return and response when user creates product without all required fields
    [Tags]   Regression   High   Sanity
     Get Random Internal Reference ID
     Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "price": "25900"}
     Response Correct Code    ${BAD_REQUEST_CODE}
     Response Should Contain Property With Value   $.title    Method argument not valid
     Response Should Contain Property With Value   $.message   error.validation

TC_O2O_13460
    [Documentation]  To verify return and response when user creates product with company which is not exists in the system
    [Tags]   Regression   High   Sanity
    Get Random Internal Reference ID
    Post Create Product   ${INVENTORY_PROJECT_ID}   {"productRef": "${RANDOM_INTERNAL_REFERENCE_ID}", "name": "${name}", "price": "25900", "companyName": "${invalid_companyName}"}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value   $.errorKey    not_exist.company