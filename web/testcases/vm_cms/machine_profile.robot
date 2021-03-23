*** Settings ***
Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/vm_cms/login_page.robot
Resource    ../../../web/keywords/vm_cms/common_keywords.robot
Test Setup    Open Browser With Option    ${VENDING_MACHINE_CMS_URL}    headless_mode=${True}

Test Teardown    Clean Environment

*** Test Cases ***

TC_O2O_12752
    [Documentation]  To verify that VMCMS is able to create a new machine profile.
    [Tags]    Regression    Sanity
    Login To Vending Machine CMS    ${VM_CMS_USER}     ${VM_CMS_PASSWORD}
    Create New Machine Profile And Verify Data
    Logout From Vending Machine CMS

TC_O2O_12755
    [Documentation]  To verify that VMCMS is able to update an existing machine profile.
    [Tags]    Regression    Sanity
    Login To Vending Machine CMS    ${VM_CMS_USER}     ${VM_CMS_PASSWORD}
    Update Machine Profile And Verify Data
    Logout From Vending Machine CMS

TC_O2O_14247
    [Documentation]  To verify that VMCMS is able to delete an existing machine profile.
    [Tags]    Regression    Sanity
    Login To Vending Machine CMS    ${VM_CMS_USER}     ${VM_CMS_PASSWORD}
    Delete Machine Profile And Verify Data
    Logout From Vending Machine CMS