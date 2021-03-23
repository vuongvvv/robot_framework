*** Settings ***
Documentation    Verify Content With Permission CRUD From Content-types And Can Create Contents
Resource    ../../../../../web/resources/init.robot
Resource    ../../../../../web/keywords/we_platform/common/common_keywords.robot
Resource    ../../../../../web/keywords/we_platform/login/login_keyword.robot
Resource    ../../../../../web/keywords/we_platform/projects/projects_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/create_or_edit_content_type_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/content_types_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/content/status_content_page_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/content/create_or_edit_content_keywords.robot
Resource    ../../../../../web/keywords/we_platform/content_types/content/view_content_page_keywords.robot
Test Setup  Run keywords  Open Browser With Option    ${WE_PLATFROM_URL}   
...   AND   Login To We Platform Website     ${WE_PLATFORM_CONTENT_USER}     ${WE_PLATFORM_CONTENT_PASSWORD}
...   AND   Navigate To Main Menu And Sub Main Menu    Menu    Project   
...   AND   Browsing Project Information    ${project_name}
...   AND   Navigate To Left Menu     Contents   ContentTypes
Test Teardown     Clean Environment

*** Variables ***
${project_name}    WeShop Tesco
${attributes_string}  attributes_test_string
${attributes_decimal}    0.5
${edit_attributes_string}  attributes_test_string_edit
${edit_attributes_decimal}    0.10
${alert_msg_create}  A new Content is created.
${alert_msg_update}  A Content is updated.
${alert_msg_delete}  A Content is deleted.
${alert_msg_error_permission}   You do not have permission.
${alert_msg_error_required_filed}   Missing required attribute

*** Test Cases ***
TC_O2O_14216
    [Documentation]   Verify create content with content-type have permission all and Attributes not require
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_all    	all-client-all
    Verify Page Content Types Name   permission_all
    Click Create New Content Type Button
    #add attributes and get last id content to verify another permission
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Get First Row On Content Table Id Column
    # Verify view permission user will see if have permission 
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   View
    Verify Value Of Attributes On Textbox Filed  Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Verify Image Attributes Is Exist  Test-Attributes-File
    Verify Value On Markdown Attribute Is Not Empty  Test-Attributes-Markdown
    Click Back Button
    # Verify user can be edit if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Edit
    Input Content Values    Test-Attributes-String=${edit_attributes_string}    Test-Attributes-Decimal=${edit_attributes_decimal}
    Upload Attribute Image  Test-Attributes-File   ${attributes_img_path}
    Input Content On Markdown  Test-Attributes-Markdown  ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_update}
    # Verify user can be delete if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Delete
    Verify Text Alert Message On Popup   ${alert_msg_delete}
    Verify Content Id Does Not Exist     ${TEST_VARIABLE_CONTENT_ID}

TC_O2O_14217
    [Documentation]  Verify create content with content-type have create permission and Attributes not
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_create    	create-client-all
    Verify Page Content Types Name   permission_create
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14220
    [Documentation]  Verify create content with content-type have Delete permission and Attributes not require
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_delete   	delete-client-all
    Verify Page Content Types Name   permission_delete
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14219
    [Documentation]   Verify create content with content-type have Update permission and Attributes not require
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_update   	update-client-all
    Verify Page Content Types Name   permission_update
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14218  
    [Documentation]   Verify create content with content-type have Read permission and Attributes not require
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_read   	read-client-all
    Verify Page Content Types Name   permission_read
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14221
    [Documentation]  Verify create content with content-type have permission all and Attributes 
    ...              not require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_all    	all-client-webackoffice	
    Verify Page Content Types Name   permission_all
    Click Create New Content Type Button
    #add attributes and get last id content to verify another permission
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Get First Row On Content Table Id Column
    # Verify view permission user will see if have permission 
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   View
    Verify Value Of Attributes On Textbox Filed  Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Verify Image Attributes Is Exist  Test-Attributes-File
    Verify Value On Markdown Attribute Is Not Empty  Test-Attributes-Markdown
    Click Back Button
    # Verify user can be edit if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Edit
    Input Content Values    Test-Attributes-String=${edit_attributes_string}    Test-Attributes-Decimal=${edit_attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_update}
     # Verify user can be delete if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Delete
    Verify Text Alert Message On Popup   ${alert_msg_delete}
    Verify Content Id Does Not Exist     ${TEST_VARIABLE_CONTENT_ID}

TC_O2O_14222
    [Documentation]   Verify create content with content-type have create permission and Attributes
    ...               not require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_create    	cerate-client-webackoffice	
    Verify Page Content Types Name   permission_create
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14225
    [Documentation]  Verify create content with content-type have Delete permission and Attributes
    ...              not require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_delete   	delete-client-webackoffice
    Verify Page Content Types Name   permission_delete
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14224
    [Documentation]  Verify create content with content-type have Update permission and Attributes 
    ...              not require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_update   	update-client-webackoffice
    Verify Page Content Types Name   permission_update
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14223
    [Documentation]  Verify create content with content-type have Read permission and Attributes 
    ...              not require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_read   	read-client-webackoffice
    Verify Page Content Types Name   permission_read
    Click Create New Content Type Button
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14226
    [Documentation]   Verify create content with content-type have permission all and Attributes 
    ...              require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_all    	all-client-webackoffice-required	
    Verify Page Content Types Name   permission_all
    Click Create New Content Type Button
    Click Save Button
    #add attributes and get last id content to verify another permission
    Verify Text Alert Message On Popup   ${alert_msg_error_required_filed}
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Get First Row On Content Table Id Column
    # Verify view permission user will see if have permission 
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   View
    Verify Value Of Attributes On Textbox Filed  Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Verify Image Attributes Is Exist  Test-Attributes-File
    Verify Value On Markdown Attribute Is Not Empty  Test-Attributes-Markdown
    Click Back Button
    # Verify user can be edit if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Edit
    Input Content Values    Test-Attributes-String=${edit_attributes_string}    Test-Attributes-Decimal=${edit_attributes_decimal}
    Click Save Button
    # Verify user can be delete if have permission
    Verify Text Alert Message On Popup    ${alert_msg_update}
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Delete
    Verify Text Alert Message On Popup   ${alert_msg_delete}
    Verify Content Id Does Not Exist     ${TEST_VARIABLE_CONTENT_ID}

TC_O2O_14227
    [Documentation]  Verify create content with content-type have create permission and Attributes 
    ...              require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_create    	create-client-webackoffice-required	
    Verify Page Content Types Name   permission_create
    Click Create New Content Type Button
    Click Save Button
    Verify Text Alert Message On Popup   ${alert_msg_error_required_filed}
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_create}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14230	
    [Documentation]   Verify create content with content-type have Delete permission and Attributes 
    ...               require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_delete   	delete-client-webackoffice-required
    Verify Page Content Types Name   permission_delete
    Click Create New Content Type Button
    Click Save Button
    Verify Text Alert Message On Popup   ${alert_msg_error_permission}
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14229    
    [Documentation]     Verify create content with content-type have Update permission and Attributes 
    ...                 require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_update   	update-client-webackoffice-required
    Verify Page Content Types Name   permission_update
    Click Create New Content Type Button
    Click Save Button
    Verify Text Alert Message On Popup   ${alert_msg_error_permission}
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14228
    [Documentation]   Verify create content with content-type have Read permission and Attributes
    ...               require,client : webackoffice
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_read   	read-client-webackoffice-required
    Verify Page Content Types Name   permission_read
    Click Create New Content Type Button
    Click Save Button
    Verify Text Alert Message On Popup   ${alert_msg_error_permission}
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_error_permission}
    Verify Id Not Exist On Content Table Id Column

TC_O2O_14231
    [Documentation]   Verify create content with content-type have all permission but have read permission some Attributes
    [Tags]    Regression    High    E2E
    Select To See Content Of Content Types By Name And Alias    permission_CRUD   	crud-string-file	
    Verify Page Content Types Name   permission_CRUD
    Click Create New Content Type Button
    #add attributes and get last id content to verify another permission
    Input Content Values    Test-Attributes-String=${attributes_string}    Test-Attributes-Decimal=${attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Get First Row On Content Table Id Column
    # Verify view permission user will see if have permission 
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}	   View
    Verify Value Of Attributes On Textbox Filed  Test-Attributes-String=${attributes_string}   Test-Attributes-Decimal=${EMPTY}
    Verify Image Attributes Is Exist  Test-Attributes-File
    Verify Value On Markdown Attribute Is Empty  Test-Attributes-Markdown
    Click Back Button
    # Verify user can be edit if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Edit
    Input Content Values    Test-Attributes-String=${edit_attributes_string}    Test-Attributes-Decimal=${edit_attributes_decimal}
    Upload Attribute Image  Test-Attributes-File  ${attributes_img_path}
    Input Content On Markdown   Test-Attributes-Markdown   ${attributes_markdown_path}
    Click Save Button
    Verify Text Alert Message On Popup    ${alert_msg_update}
    # Verify user can be delete if have permission
    Press Button By Content ID  ${TEST_VARIABLE_CONTENT_ID}   Delete
    Verify Text Alert Message On Popup   ${alert_msg_delete}
    Verify Content Id Does Not Exist     ${TEST_VARIABLE_CONTENT_ID}