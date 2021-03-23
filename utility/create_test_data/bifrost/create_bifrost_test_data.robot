*** Settings ***
Documentation    Create test data on AdminTools

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/access-management/subject_resource_keywords.robot
Resource    ../../../api/keywords/access-management/resource_resource_keywords.robot
Resource    ../../../api/keywords/access-management/policy_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform
Test Teardown     Delete All Sessions

*** Variables ***
${bifrost_configuration_project_id}    robot-automation-bifrost-test
${client_id}    robotautomationclient
${method}    get
${path_variable_entity}    automation
${query_param_category}    robot-automation-test-category

# Product Search Authorisation E2E test
${product_search_wemall_project_id_alpha}    5ed5fa524972aa0001153b4a
${product_search_wemall_project_id_staging}    5d1b198a8224fa0001d640ff
${product_search_subject}    robotautomationclient
${product_search_resource}    wemall-domain

*** Test Cases ***
CREATE_BIFORST_TEST_DATA
    [Documentation]    Prepare policies on AccessManagement service, then BiFrost service can check for authorisation on AccessManagement
    Post Create Subject    ${bifrost_configuration_project_id}    { "key":"wemall", "description":"${bifrost_configuration_project_id}" }
    Post Create Subject    ${bifrost_configuration_project_id}    { "key":"${bifrost_configuration_project_id}", "description":"${bifrost_configuration_project_id}" }
    Post Create Subject    ${bifrost_configuration_project_id}    { "key":"${client_id}", "description":"${bifrost_configuration_project_id}" }
    
    Post Create Resource    ${bifrost_configuration_project_id}    { "key":"${bifrost_configuration_project_id}", "description":"${bifrost_configuration_project_id}" }
    Post Create Resource    ${bifrost_configuration_project_id}    { "key":"products", "description":"${bifrost_configuration_project_id}", "actions":[ "Read" ] }
    Post Create Resource    ${bifrost_configuration_project_id}    { "key":"${path_variable_entity}", "description":"${bifrost_configuration_project_id}" }
    Post Create Resource    ${bifrost_configuration_project_id}    { "key":"${query_param_category}", "description":"${bifrost_configuration_project_id}" }
    
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "wemall" ], "resources":[ "products" ], "actions":[ "read" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "${bifrost_configuration_project_id}" ], "resources":[ "products" ], "actions":[ "read" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "${client_id}" ], "resources":[ "products" ], "actions":[ "read" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "${client_id}" ], "resources":[ "${bifrost_configuration_project_id}" ], "actions":[ "${method}" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "${client_id}" ], "resources":[ "${path_variable_entity}" ], "actions":[ "${method}" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${bifrost_configuration_project_id}    { "subjects":[ "${client_id}" ], "resources":[ "${query_param_category}" ], "actions":[ "${method}" ], "description":"${bifrost_configuration_project_id}" }
    Response Correct Code    ${CREATED_CODE}
    
PRODUCT_SEARCH_AUTHORISATION_TEST_DATA
    [Documentation]    Prepare test data for Product Search Authorisation E2E test
    ...    https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1591378517/Product+Search+Authorization
    Post Create Subject    ${product_search_wemall_project_id_${ENV}}    { "key":"${product_search_subject}", "description":"Product Search Authorisation E2E test" }
    Post Create Resource    ${product_search_wemall_project_id_${ENV}}    { "key":"${product_search_resource}", "description":"Product Search Authorisation E2E test", "actions":[ "access" ] }
    Post Create Policy    ${product_search_wemall_project_id_${ENV}}    { "subjects":[ "${product_search_subject}" ], "resources":[ "${product_search_resource}" ], "actions":[ "access" ], "description":"Product Search Authorisation E2E test" }
    Response Correct Code    ${CREATED_CODE}