*** Settings ***
Documentation    Verify the weomni status page is display component availability in weomni platform
Resource    ../../../../web/resources/init.robot
Resource    ../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/content_types/content/status_content_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/content_types/content_types_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/content_types/content_type_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/content_types/create_or_edit_content_type_keywords.robot
Resource    ../../../../web/keywords/service_status/service_status_page_keywords.robot
Resource    ../../../../web/keywords/we_platform/common/common_keywords.robot
Test Setup    Run Keywords    Open Browser With Option    ${WE_PLATFROM_URL}
...    AND    Login To We Platform Website    ${WE_PLATFORM_MONITORING_USER}    ${WE_PLATFORM_MONITORING_PASSWORD}    
...    AND    Navigate To Main Menu And Sub Main Menu    Menu    Project    
...    AND    Browsing Project Information   ${project_name}
Test Teardown    Clean Environment

*** Variable ***
${project_name}    WeOmniPlatform
${content_type_name}    Status content
${content_type_alias}    status-content
${we_platfrom_browser_index}  1
${service_stastus_browser_index}  2
${new_content_type_alias}   robot-test-edit-alias
${expected_service_status_subject}    Announcement
${expected_alert_message}    All Systems Operational
${time_out}    3s
${refresh_interval}    5s

*** Test Case ***
TC_O2O_12204
    [Documentation]    Verify the project, content type IDs and alias are as expected for WeOmniPlatform project
    [Tags]    Regression    Smoke    High    webackoffice
    #Verify project ID in web page and URL are the same
    Get Information From Property    Id
    Get Id From URL    project
    Should Be Equal As Strings  ${ID_FROM_URL}    ${INFORMATION_GOT_FROM_PROPERTY}
    #Verify the content ID in web page and URL are the same
    Navigate To Left Menu    Contents    ContentTypes
    Press Content Types Button By Name And Alias    View    ${content_type_name}    ${content_type_alias}
    Get Content Type Id Page From Header
    Get Id From URL    content-type
    Should Be Equal As Strings  ${ID_FROM_URL}    ${CONTENT_TYPE_ID}
    #Verify Alias should be as expected
    Get Information From Property    Alias
    Should Be Equal As Strings  ${content_type_alias}    ${INFORMATION_GOT_FROM_PROPERTY}

TC_O2O_12205
    [Documentation]    Verify the content ID is as expected for WeOmniPlatform project
    [Tags]    Regression    Smoke    High    webackoffice
    Navigate To Left Menu    Contents    ContentTypes
    Select To See Content Of Content Types By Name And Alias    ${content_type_name}    ${content_type_alias}
    Verify Id Exist On Content Table Id Column    ${WE_PLATFORM_CONTENT_ID}

TC_O2O_12206
    [Documentation]    Verify Editing Project alias should be effect to service status page
    [Tags]    Regression    Smoke    High    webackoffice    status-page
    #Verify the content is display as expected in the Service Status page
    Switch To Non Angular JS Site
    Open Browser With Option    ${SERVICE_STASTUS_URL}
    Verify Announcement Section Displays
    Verify Alert Message Displays
    Switch To Angular JS Site
    #Edit alias for verify that the content still displays in the Service Status page - after 5 minutes, the content will disappear due to the cache
    Switch Browser By Index   ${we_platfrom_browser_index}
    Navigate To Left Menu    Contents    ContentTypes
    Click Edit Button By Alias    ${content_type_alias}
    Edit Content Type    alias=${new_content_type_alias}

    Switch To Non Angular JS Site
    Switch Browser By Index     ${service_stastus_browser_index}
    Refresh Page
    Verify Announcement Section Displays
    Verify Alert Message Displays
    Switch To Angular JS Site
    
    #Edit alias back to default for verify that the content is display in the Service Status page
    Switch Browser By Index     ${we_platfrom_browser_index}
    Click Edit Button By Alias    ${new_content_type_alias}
    Edit Content Type    alias=${content_type_alias}
    
    Switch To Non Angular JS Site
    Switch Browser By Index     ${service_stastus_browser_index}
    Refresh Page
    Verify Announcement Section Displays
    Verify Alert Message Displays
    Switch To Angular JS Site