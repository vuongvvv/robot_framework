*** Settings ***
Resource   ../../../web/resources/locators/service_status/service_status_page_locators.robot

*** Keywords ***
Verify Announcement Section Displays
    Wait Element Is Visible    ${lbl_accouncement_section}

Verify Alert Message Displays
    Wait Element Is Visible    ${lbl_alert}