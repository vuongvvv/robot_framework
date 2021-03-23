*** Settings ***
Resource          ../../../resources/locators/admintools/main_page/main_page_locators.robot

*** Keywords ***
Go to Estamp Main Page
    Click the Hamburger Menu
    wait until page does not contain  ${hidden_side_bar}
    click element  ${estamp_menu}
    click element  ${estamp_campaign_menu}
    set browser implicit wait  0 second

Estamp Menu should be displayed
    Element Should Be Visible            ${estamp_menu}

Go to DLQ Messages Main Page
    Click the Hamburger Menu
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    Click Element    ${dlq_messages_menu}
    Click Element    ${dlq_messages_merchant_subscriber_menu}
    Wait Until Page Does Not Contain  ${hidden_side_bar}

Go To Merchant Page Of Merchant Edit MySQL
    Click the Hamburger Menu
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    Click Element    ${merchant_edit_my_sql_menu}
    Wait Until Element Is Visible    ${merchant_edit_my_sql_merchant_menu}
    Click Element    ${merchant_edit_my_sql_merchant_menu}
    Set Browser Implicit Wait    10 second
    Wait Until Page Does Not Contain  ${hidden_side_bar}

Go To Outlet Page Of Merchant Edit MySQL
    Click the Hamburger Menu
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    Click Element    ${merchant_edit_my_sql_menu}
    Wait Until Element Is Visible    ${merchant_edit_my_sql_outlet_menu}
    Click Element    ${merchant_edit_my_sql_outlet_menu}
    Set Browser Implicit Wait    10 second
    Wait Until Page Does Not Contain  ${hidden_side_bar}
