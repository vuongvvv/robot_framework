*** Settings ***
Resource    ../../../../web/resources/locators/audit_web/common/common_locators.robot

*** Keywords ***
Logout From Audit Web
    Click Element    ${lnk_logout_audit_web}
