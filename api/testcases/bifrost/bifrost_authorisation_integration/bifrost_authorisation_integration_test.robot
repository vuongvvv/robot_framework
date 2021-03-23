*** Settings ***
Documentation    [BiFrost Authorisation] BiFrost Authorisation integration works correctly with fixed values, JavaScript, multiple policies
...    https://truemoney.atlassian.net/browse/ASCO2O-20429 - [Bifrost] Authz Integration

Resource    ../../../resources/init.robot
Resource    ../../../keywords/bifrost/proxy_resource_keywords.robot
Resource    ../../../keywords/bifrost/routing_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform
Test Teardown     Run Keywords    Delete Proxy    ${TEST_DATA_PROXY_ID}
...    AND    Delete All Sessions

*** Variables ***
${bifrost_configuration_path}    /robot/automation
${bifrost_configuration_path_with_entity}    /robot/{entity}
${bifrost_configuration_group_name}    robot_test
${bifrost_configuration_project_id}    robot-automation-bifrost-test
${bifrost_configuration_project_id_not_matched_with_access_management}    not-matched-with-access-management
${bifrost_configuration_target}    bifrost://noop
${bifrost_configuration_policies_fixed_value}    { "subject": "wemall", "action": "read", "resource": "products" }
${bifrost_configuration_policies_simple_access_control}    { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "read", "resource": "products" }
${bifrost_configuration_policies_simple_access_control_not_matched_with_am}    { "subject": "(function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })", "action": "read", "resource": "products" }
${bifrost_configuration_policies_query_based_access_control}    { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "get", "resource": "(function(proxyReq) { return proxyReq.getQueryParameters().get('category'); })" }
${bifrost_configuration_policies_path_based_access_control}    { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "get", "resource": "(function(proxyReq) { return proxyReq.getPathVariables().get('entity'); })" }
${bifrost_configuration_policies_javascript_subject}    { "subject": "(function(proxyReq) { return proxyReq.getProjectId(); })", "action": "read", "resource": "products" }
${bifrost_configuration_policies_javascript_invalid}    { "subject": "(function(proxyReq) { return proxyReq.getProjectId.Invalid(); })", "action": "read", "resource": "products" }
${bifrost_configuration_policies_multiple_policies}    { "subject": "wemall", "action": "read", "resource": "products" }, { "subject": "(function(proxyReq) { return proxyReq.getProjectId(); })", "action": "read", "resource": "products" }
${bifrost_configuration_policies_5_policies}    { "subject": "wemall", "action": "read", "resource": "products" }, { "subject": "(function(proxyReq) { return proxyReq.getProjectId(); })", "action": "read", "resource": "products" }, { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "(function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })", "resource": "(function(proxyReq) { return proxyReq.getProjectId(); })" }, { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "(function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })", "resource": "(function(proxyReq) { return proxyReq.getPathVariables().get('entity'); })" }, { "subject": "(function(proxyReq) { return proxyReq.getClientId(); })", "action": "(function(proxyReq) { return proxyReq.getSourceRequest().getMethod(); })", "resource": "(function(proxyReq) { return proxyReq.getQueryParameters().get('category'); })" }

*** Test Cases ***
# TEST DATA: CREATE_BIFORST_TEST_DATA
TC_O2O_21918
    [Documentation]     [BiFrost Authorisation] BiFrost Authorisation integration works correctly with fixed values, JavaScript, multiple policies
    [Tags]      E2E     High    bifrost
    Post Create Proxy    { "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_fixed_value} ], "requiredScopesString": [] }
    Fetch Proxy Id
    Response Correct Code    ${CREATED_CODE}
    Get All Proxies
    Response Correct Code    ${SUCCESS_CODE}
    Get Proxy    ${TEST_DATA_PROXY_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    
    # Bifrost endpoint authorization with simple access control
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_simple_access_control} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_simple_access_control_not_matched_with_am} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${FORBIDDEN_CODE}
    
    # Bifrost endpoint authorization with query-based access control
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_query_based_access_control} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=robot-automation-test-category
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=robot-automation-test-category&page=20&sort=id
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=robot-automation-test-category&category=food
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=food&category=robot-automation-test-category
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=not-matched-with-am
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${FORBIDDEN_CODE}
    
    # Bifrost endpoint authorization with path-based access control
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path_with_entity}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_path_based_access_control} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    /robot/NotMatchedWithAM
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    /robot/automatio
    Response Correct Code    ${FORBIDDEN_CODE}    

    # Multiple policies matched with Access Management config
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_multiple_policies} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    #Multiple policies only 1 matched with Access Management config
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id_not_matched_with_access_management}    ${bifrost_configuration_path}
    Response Correct Code    ${FORBIDDEN_CODE}
    
    # 5 policies
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path_with_entity}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_5_policies} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}    
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}    category=robot-automation-test-category
    Response Correct Code    ${SUCCESS_CODE}
                   
    # BiFrost config with JavaScript matched with Access Management config
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_javascript_subject} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}    
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}    
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id_not_matched_with_access_management}    ${bifrost_configuration_path}
    Response Correct Code    ${FORBIDDEN_CODE}
    
    # BiFrost config with JavaScript, that can not execute
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_javascript_invalid} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}    
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${INTERNAL_SERVER_CODE}
    
    # Support specifying project for access policies
    # policyProjectId is NULL
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policies": [ ${bifrost_configuration_policies_fixed_value} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id_not_matched_with_access_management}    ${bifrost_configuration_path}
    Response Correct Code    ${FORBIDDEN_CODE}
    # policyProjectId is NOT NULL
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": true, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_simple_access_control} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id_not_matched_with_access_management}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}

    # BiFrost configuration: authorizationEnabled: False
    Put Update Proxy    { "id": "${TEST_DATA_PROXY_ID}", "name": "robot_automation_bifrost_test", "description": "robot_automation_bifrost_test", "owner": "robot_automation_bifrost_test", "path": "${bifrost_configuration_path}", "projectBase": true, "method": "GET", "target": "${bifrost_configuration_target}", "targetMethod": "GET", "authentication": "OAUTH2", "headers": {}, "mapping": { "request": null, "response": null }, "whitelistIps": [], "forwardHeaders": [], "requiredScopes": [], "groupName": "${bifrost_configuration_group_name}", "options": { "ENABLE_REST": "true" }, "projectId": "", "authorizationEnabled": false, "policyProjectId": "${bifrost_configuration_project_id}", "policies": [ ${bifrost_configuration_policies_simple_access_control} ], "requiredScopesString": [] }
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id_not_matched_with_access_management}    ${bifrost_configuration_path}
    Response Correct Code    ${SUCCESS_CODE}
    
    # Remove BiFrost configuration
    Delete Proxy    ${TEST_DATA_PROXY_ID}
    Response Correct Code    ${NO_CONTENT_CODE}
    Get Routing Proxy    ${bifrost_configuration_group_name}    ${bifrost_configuration_project_id}    ${bifrost_configuration_path}
    Response Correct Code    ${NOT_FOUND_CODE}