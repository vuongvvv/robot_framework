*** Settings ***
Documentation  Tests to verify that create company api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/inventory/company_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission   ${INVENTORY_USER}    ${INVENTORY_PASSWORD}
Test Teardown     Run Keywords    Delete Created Client And User Group  AND   Delete All Sessions

*** Variables ***
${active}   ${True}

*** Test Cases ***
TC_O2O_16144
    [Documentation]  To verify return and response when create company with valid value
    [Tags]   Regression   Smoke   High  UnitTest    ASCO2O-19151
    Get Random Company Name
    Post Create Company  ${INVENTORY_PROJECT_ID}   { "name": "${RANDOM_COMPANY_NAME}" }
    Response Correct Code  ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.name  ${RANDOM_COMPANY_NAME}
    Response Should Contain Property With Value  $.active  ${active}
    Get Created Company ID
    Delete Company  ${INVENTORY_PROJECT_ID}   ${COMPANY_ID}

TC_O2O_16145
    [Documentation]  To verify return and response when create company with duplicate name
    [Tags]  Regression   Smoke   High  UnitTest    ASCO2O-19151
    Get Random Company Name
    Post Create Company  ${INVENTORY_PROJECT_ID}   { "name": "${RANDOM_COMPANY_NAME}" }
    Response Correct Code  ${CREATED_CODE}
    Response Should Contain Property With String Value  $.id
    Response Should Contain Property With Value  $.name  ${RANDOM_COMPANY_NAME}
    Response Should Contain Property With Value  $.active  ${active}
    Get Created Company ID
    Post Create Company  ${INVENTORY_PROJECT_ID}   { "name": "${RANDOM_COMPANY_NAME}" }
    Response Correct Code  ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value  $.errorKey   duplicate.company
    Delete Company  ${INVENTORY_PROJECT_ID}   ${COMPANY_ID}