*** Settings ***
Resource    ../../../../web/resources/locators/we_platform/content/content_types_locators.robot
Resource    ../../../../web/resources/locators/we_platform/content/content_locators.robot

*** Keywords ***
Search Content By Attribute And Value
    [Arguments]    ${attribute_name}    ${value}    ${index}=${0}
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    ${attribute_name_locator}=     Format String    ${txt_attribute_name}    ${index}
    ${value_locator}=              Format String    ${txt_value}            ${index}
    Wait Until Element Is Visible     ${attribute_name_locator}
    Input Text    ${attribute_name_locator}    ${attribute_name}
    Input Text    ${value_locator}             ${value}
    Click Element    ${btn_search_content}

View Content By Index
    [Arguments]    ${index}=${1}
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    Wait Until Element Is Visible    ${txt_search_result}
    ${content_view_locator}=     Format String    ${btn_view_content}    ${index}
    Click Element    ${content_view_locator}

Get Information Of Brand Content
    Wait Until Element Is Visible    ${txt_brand_tsm_merchant_id}    10
    ${tsm_merchant_id}             Get Element Attribute              ${txt_brand_tsm_merchant_id}    value
    ${brand_name_th}               Get Element Attribute              ${txt_brand_name_th}           value
    ${brand_name_en}               Get Element Attribute              ${txt_brand_name_en}           value
    ${brand_social_website}        Get Element Attribute              ${txt_social_website}         value
    ${brand_social_facebook}       Get Element Attribute              ${txt_social_facebook}        value
    ${brand_social_instagram}      Get Element Attribute              ${txt_social_instagram}       value
    ${brand_social_twitter}        Get Element Attribute              ${txt_social_twitter}         value
    ${brand_social_line}           Get Element Attribute              ${txt_social_line}            value
    Set Test Variable    ${TSM_MERCHANT_ID}              ${tsm_merchant_id}
    Set Test Variable    ${BRAND_NAME_TH}                ${brand_name_th}
    Set Test Variable    ${BRAND_NAME_EN}                ${brand_name_en}
    Set Test Variable    ${BRAND_SOCIAL_WEBSITE}         ${brand_social_website}
    Set Test Variable    ${BRAND_SOCIAL_FACEBOOK}        ${brand_social_facebook}
    Set Test Variable    ${BRAND_SOCIAL_INSTAGRAM}       ${brand_social_instagram}
    Set Test Variable    ${BRAND_SOCIAL_TWITTER}         ${brand_social_twitter}
    Set Test Variable    ${BRAND_SOCIAL_LINE}            ${brand_social_line}

Get Information Of Shop Content
    Wait Until Element Is Visible    ${txtShopTsmMerchantId}
    ${shop_tsm_merchant_id}        Get Element Attribute              ${txt_shop_tsm_merchant_id}      value
    ${shop_name_th}                Get Element Attribute              ${txt_shop_name_th}             value
    ${shop_name_en}                Get Element Attribute              ${txt_shop_name_en}             value
    ${shop_highlight}              Get Element Attribute              ${txt_shop_highlight}          value
    ${shop_tel}                    Get Element Attribute              ${txt_shop_tel}                value
    ${shop_mobile}                 Get Element Attribute              ${txt_shop_mobile}             value
    Set Test Variable    ${SHOP_TSM_MERCHANT_ID}              ${shop_tsm_merchant_id}
    Set Test Variable    ${SHOP_NAME_TH}                      ${shop_name_th}
    Set Test Variable    ${SHOP_NAME_EN}                      ${shop_name_en}
    Set Test Variable    ${SHOP_HIGHLIGHT}                    ${shop_highlight}
    Set Test Variable    ${SHOP_TEL}                          ${shop_tel}
    Set Test Variable    ${SHOP_MOBILE}                       ${shop_mobile}