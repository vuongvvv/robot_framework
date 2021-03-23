*** Settings ***
Resource    ../../resources/locators/truemoney/android/weshop_locators.robot
Resource    ../../../web/keywords/common/locator_common.robot
Resource    ../common/mobile_common.robot

*** Keywords ***
Create Weshop Order
    Click Visible Element    ${btn_asoke_shop}
    Scroll Element To Middle    ${lbl_test_shop}
    Click Visible Element    ${lbl_test_shop}
    ${product_to_add}=    Generate Element From Dynamic Locator    ${btn_add_product}    สเต็กเนื้อสันใน
    Scroll Element To Middle    ${product_to_add}
    Click Visible Element    ${product_to_add}
    Click Visible Element    ${btn_add_to_cart}           
    Click Visible Element    ${btn_to_payment}        
    Wait Until Element Is Enabled    ${btn_checkout}
    Click Visible Element    ${btn_checkout}    
    Click Visible Element    ${btn_confirm_payment}
    Click Visible Element    ${btn_pay}    
