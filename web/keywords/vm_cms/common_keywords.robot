*** Settings ***
Resource    ../../resources/locators/vm_cms/common_locators.robot
Resource  ../../../web/resources/init.robot

*** Keywords ***

Navigate To All Machine Profile
    Click Element  ${mnu_machine_dropdown}
    Click Link     ${mch_profile_link}
    Wait Until Page Contains Element    //h1[contains(.,'All Machine Profile')]


Create New Machine Profile And Verify Data
    Wait Until Element Is Interactable    ${mnu_machine_dropdown}
    Click Element    ${mnu_machine_dropdown}
    Wait Until Element Is Interactable    ${cre_machine_profile_link}
    Click Element    ${cre_machine_profile_link}
    Wait Until Element Is Interactable    ${vcm_machine_id}
    Fill Text Machine Profile    88888888    00000001    222032797001996    0171937    10007    68175870    ออโตเมชั่นแมชชีน0001    1    individual    individual    Automationtest.com    Automation remark
    Click Button  ${vcm_create_machine_profile_btn}
    Verify Success    88888888    88888888    00000001    222032797001996    0171937    10007    68175870

Verify Success
    [Arguments]    ${mch_search}    ${ver_machine_id}    ${ver_partner_id}    ${ver_merchant_id}    ${ver_brand_id}    ${ver_outlet_id}    ${ver_terminal_id}
    Wait Until Page Contains Element    //p[@class="alert alert-success"]
    Press Keys          ${vcm_search_box}    ${mch_search}
    Element Should Be Visible    //td[contains(text(),'${ver_machine_id}')]
    Element Should Be Visible    //td[contains(text(),'${ver_merchant_id}')]
    Element Should Be Visible    //td[contains(text(),'${ver_partner_id}')]
    Element Should Be Visible    //td[contains(text(),'${ver_brand_id}')]
    Element Should Be Visible    //td[contains(text(),'${ver_outlet_id}')]
    Element Should Be Visible    //td[contains(text(),'${ver_terminal_id}')]

Update Machine Profile And Verify Data
    Wait Until Element Is Interactable    ${mnu_machine_dropdown}
    Click Element    ${mnu_machine_dropdown}
    Wait Until Element Is Interactable    ${mch_profile_link}
    Click Element          ${mch_profile_link}
    Wait Until Element Is Interactable    ${vcm_browse_machine_profile_btn}
    Click Element          ${vcm_browse_machine_profile_btn}
    Wait Until Element Is Interactable    ${vcm_machine_id}
    Fill Text Machine Profile    99999999    00000002    222032797001997    0171938    10008    68175871    ออโตเมชั่นแมชชีน0002    0    global    global    AutomationtestUpdate.com    Automation Update remark
    Click Button  ${vcm_update_machine_profile_btn}
    Verify Success    99999999    99999999    00000002    222032797001997    0171938    10008    68175871

Fill Text Machine Profile
    [Arguments]    ${machine_id}    ${partner_id}   ${merchant_id}    ${brand_id}    ${outlet_id}    ${terminal_id}    ${thai_name}    ${machine_status}    ${blacklist_type}    ${whitelist_type}    ${machine_url}    ${remark} 
    Clear Element Text  ${vcm_machine_id}
    Press Keys          ${vcm_machine_id}    ${machine_id} 
    Clear Element Text  ${vcm_partner_id}
    Press Keys          ${vcm_partner_id}    ${partner_id}
    Clear Element Text  ${vcm_merchant_id}
    Press Keys          ${vcm_merchant_id}   ${merchant_id}
    Clear Element Text  ${vcm_brand_id}
    Press Keys          ${vcm_brand_id}      ${brand_id}
    Clear Element Text  ${vcm_outlet_id}
    Press Keys          ${vcm_outlet_id}     ${outlet_id}
    Clear Element Text  ${vcm_terminal_id}
    Press Keys          ${vcm_terminal_id}   ${terminal_id}
    Clear Element Text  ${vcm_thai_name}
    Press Keys          ${vcm_thai_name}     ${thai_name}
    Select From List By Value   ${vcm_machine_status}    ${machine_status}
    Select From List By Value  ${vcm_blacklist_type}    ${blacklist_type}
    Select From List By Value  ${vcm_whitelist_type}    ${whitelist_type}
    Clear Element Text     ${vcm_machine_url}
    Press Keys             ${vcm_machine_url}    ${machine_url}
    Clear Element Text     ${vcm_remark}
    Press Keys             ${vcm_remark}    ${remark}

Delete Machine Profile And Verify Data
    Wait Until Element Is Interactable    ${mnu_machine_dropdown}
    Click Element    ${mnu_machine_dropdown}
    Click Link       ${mch_profile_link}
    Wait Until Element Is Interactable    ${vcm_delete_machine_profile_btn}
    Click Element       ${vcm_delete_machine_profile_btn}
    Verify Delete Success    99999999

Verify Delete Success
    [Arguments]    ${mch_search}
    Wait Until Page Contains Element    //p[@class="alert alert-success"]
    Press Keys          ${vcm_search_box}    ${mch_search}
    Element Should Be Visible    //td[@class='dataTables_empty']

Logout From Vending Machine CMS
    Click Link      ${vcm_logout_btn}
    SeleniumLibrary.Reload Page
    Wait Until Page Contains Element    //button[contains(.,'Login')]