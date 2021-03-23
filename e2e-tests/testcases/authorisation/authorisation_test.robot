*** Settings ***
Documentation    Tests to verify that AccessManagement feature
Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/access-management/subject_resource_keywords.robot
Resource    ../../../api/keywords/access-management/resource_resource_keywords.robot
Resource    ../../../api/keywords/access-management/policy_resource_keywords.robot
Resource    ../../../api/keywords/access-management/authorization_resource_keywords.robot

Test Setup    Generate Robot Automation Header    ${ACCESSMANAGEMENT_USER}    ${ACCESSMANAGEMENT_USER_PASSWORD}    gateway=${WE_PLATFORM}
Test Teardown    Delete All Sessions

*** Variables ***
${subject_key_1}    subject-key-1
${child_subject_key_1}    subject-key-1-1
${subject_key_2}    subject-key-2
${resource_key_1}    resource-key-1
${child_resource_key_1}    resource-key-1-1
${resource_key_2}    resource-key-2
${action_key_1}    read
${action_key_2}    write
${automated_description_subject}    automation test - subject
${automated_description_resource}    automation test - resource
${automated_description_policy}    automation test - policy

*** Test Cases ***
TC_O2O_18501
    [Documentation]     Authorisation with child subjects and resources
    [Tags]    Regression    E2E    access-management
    Generate Project Id
    Post Create Subject    ${PROJECT_ID}    { "key":"${subject_key_1}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Resource    ${PROJECT_ID}    { "key":"${resource_key_1}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${PROJECT_ID}    { "subjects":[ "${subject_key_1}" ], "resources":[ "${resource_key_1}" ], "actions":[ "${action_key_1}" ], "description":"${automated_description_policy}" }
    Response Correct Code    ${CREATED_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Add child subject
    Post Create Subject    ${PROJECT_ID}    { "key":"${child_subject_key_1}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    subject_resource_keywords.Post Add Children    ${PROJECT_ID}    ${subject_key_1}    {"subjects":["${child_subject_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Add child resource
    Post Create Resource    ${PROJECT_ID}    { "key":"${child_resource_key_1}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    resource_resource_keywords.Post Add Children    ${PROJECT_ID}    ${resource_key_1}    {"resources":["${child_resource_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Remove child subject
    subject_resource_keywords.Delete Children    ${PROJECT_ID}    ${subject_key_1}    {"subjects":["${child_subject_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}

    #Remove child resource
    resource_resource_keywords.Delete Children    ${PROJECT_ID}    ${resource_key_1}    {"resources":["${child_resource_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    
TC_O2O_18502
    [Documentation]     Authorisation with adding subjects, resources, actions to existing policy
    [Tags]    Regression    E2E    access-management
    Generate Project Id
    Post Create Subject    ${PROJECT_ID}    { "key":"${subject_key_1}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Resource    ${PROJECT_ID}    { "key":"${resource_key_1}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    Post Create Policy    ${PROJECT_ID}    { "subjects":[ "${subject_key_1}" ], "resources":[ "${resource_key_1}" ], "actions":[ "${action_key_1}" ], "description":"${automated_description_policy}" }
    Response Correct Code    ${CREATED_CODE}
    Collect Policy Id From Response
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Add subject to policy
    Post Create Subject    ${PROJECT_ID}    { "key":"${subject_key_2}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    Post Add Subjects    ${PROJECT_ID}    ${POLICY_ID}    {"subjects":["${subject_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Add resource to policy
    Post Create Resource    ${PROJECT_ID}    { "key":"${resource_key_2}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    Post Add Resources    ${PROJECT_ID}    ${POLICY_ID}    {"resources":["${resource_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Add action to policy    
    Post Add Actions    ${PROJECT_ID}    ${POLICY_ID}    {"actions":["${action_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}","${subject_key_2}" ], "resources": [ "${resource_key_1}","${resource_key_2}" ], "actions": [ "${action_key_1}", "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    
    #Remove subject from policy
    Delete Subjects    ${PROJECT_ID}    ${POLICY_ID}    {"subjects":["${subject_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    
    #Remove resources from policy
    Delete Resources    ${PROJECT_ID}    ${POLICY_ID}    {"resources":["${resource_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    
    #Remove action from policy
    Delete Actions    ${PROJECT_ID}    ${POLICY_ID}    {"actions":["${action_key_2}"]}
    Response Correct Code    ${SUCCESS_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_2}" ], "resources": [ "${resource_key_2}" ], "actions": [ "${action_key_2}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    

TC_O2O_18722
    [Documentation]     Policy of the child Subjects or Resources have no impact to its parent
    [Tags]    Regression    E2E    access-management
    Generate Project Id
    Post Create Subject    ${PROJECT_ID}    { "key":"${subject_key_1}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    Post Create Resource    ${PROJECT_ID}    { "key":"${resource_key_1}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    #Add child subject
    Post Create Subject    ${PROJECT_ID}    { "key":"${child_subject_key_1}", "description":"${automated_description_subject}" }
    Response Correct Code    ${CREATED_CODE}
    subject_resource_keywords.Post Add Children    ${PROJECT_ID}    ${subject_key_1}    {"subjects":["${child_subject_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    #Add child resource
    Post Create Resource    ${PROJECT_ID}    { "key":"${child_resource_key_1}", "description":"${automated_description_resource}", "actions":[ "${action_key_1}" ] }
    Response Correct Code    ${CREATED_CODE}
    resource_resource_keywords.Post Add Children    ${PROJECT_ID}    ${resource_key_1}    {"resources":["${child_resource_key_1}"]}
    Response Correct Code    ${SUCCESS_CODE}
    #Create Policy and Authorisation
    Post Create Policy    ${PROJECT_ID}    { "subjects":[ "${child_subject_key_1}" ], "resources":[ "${child_resource_key_1}" ], "actions":[ "${action_key_1}" ], "description":"${automated_description_policy}" }
    Response Correct Code    ${CREATED_CODE}
    Wait Until Cashbin Rules Created
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${True}    
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${child_subject_key_1}" ], "resources": [ "${resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}
    Post Is Authorized    ${PROJECT_ID}    { "subjects": [ "${subject_key_1}" ], "resources": [ "${child_resource_key_1}" ], "actions": [ "${action_key_1}" ] }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Boolean Value    authorized    ${False}