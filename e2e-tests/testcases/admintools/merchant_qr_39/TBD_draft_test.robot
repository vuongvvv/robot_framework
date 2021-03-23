*** Settings ***
Documentation    E2E tests for Merchant - Tag39 Epic
Resource    ../../../../api/resources/init.robot
Resource    ../../../../api/resources/testdata/alpha/merchant/merchant_data.robot
Resource    ../../../../api/keywords/merchant/category_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/sub_category_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/brand_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/shop_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/terminal_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/call_verification_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/document_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/file_resource_keywords.robot
Resource    ../../../../api/keywords/merchant/fraud_resource_keywords.robot
Resource    ../../../../api/keywords/cms/content_resource_keywords.robot

Resource    ../../../../api/keywords/bifrost/routing_resource_keywords.robot

Resource    ../../../../web/resources/init_robot_browser.robot
Resource    ../../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../../web/keywords/admintools/call_verification_qr_39/brand_call_verification_keywords.robot
Resource    ../../../../web/keywords/admintools/fraud_approval/fraud_admin_approval_keywords.robot
Resource    ../../../../web/resources/testdata/alpha/true_you_deal_management/true_you_deal_management_testdata.robot
Resource    ../../../../web/keywords/deal_management/common/common_keywords.robot
Resource    ../../../../web/keywords/deal_management/partner_requests/partner_requests_detail_keywords.robot

Resource    ../../../../web/resources/testdata/alpha/truemoney_admin_portal/truemoney_admin_portal_testdata.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/common/truemoney_admin_portal_common_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/merchant_profile_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/shop_profile_keywords.robot
Resource    ../../../../web/keywords/truemoney_admin_portal/merchant_management/shop_contract_approval_list_keywords.robot

# scope: merchantv2.shopContractTmn.write,shop.write,terminal.write,file.write,kyb.document.write,shop.kyb.write,merchantv2.brand.read,merchantv2.brand.actAsAdmin,brand.kyb.write,merchantv2.category.read,merchantv2.subcategory.read
# permission: merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantv2.callver.write,merchantv2.brandFraud.actAsAdmin
# Test Setup    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
# Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
# ...    AND    Login Backoffice    ${ADMIN_TOOLS_USERNAME}    ${ADMIN_TOOLS_PASSWORD}
# ...    AND    Generate Robot Automation Header    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}
# Test teardown    Run Keywords    Switch To Non Angular JS Site
# ...    AND    Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}
# ...    AND    Login TrueMoney Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
# ...    AND    Remove TrueMoney Account    ${TRUEMONEY_BRAND_ID}    ${TRUEMONEY_SHOP_ID}
# ...    AND    Update TrueMoney Merchant Operation Status    ${TRUEMONEY_BRAND_ID}    CERTIFICATED_FAILED
# ...    AND    Switch To Angular JS Site
# ...    AND    Clean Environment
# ...    AND    Delete All Sessions

*** Variables ***
${category_name_en}    Food & Drink
# /o2o-api-automation/api/resources/testdata/merchant/upload_files
${jpeg_owner_image}    jpeg_owner_image.jpeg
${jpeg_owner_certificate}    jpeg_owner_certificate.jpeg
${png_vat_registration}    png_vat_registration.png
${pdf_bank_passbook}    pdf_bank_passbook.pdf
${jpeg_household_registration}    jpeg_household_registration.jpeg
${jpeg_company_registration}    jpeg_company_registration.jpeg
${jpeg_rental_contract}    jpeg_rental_contract.jpeg
${jpeg_other}    jpeg_other.jpeg

${jpeg_brand_image_logo}    jpeg_brand_image_logo.jpeg
${jpeg_brand_image_store_front}    jpeg_brand_image_store_front.jpeg
${png_brand_image_menu}    png_brand_image_menu.png
${jpeg_brand_image_map}    jpeg_brand_image_map.jpeg
${jpeg_brand_image_other}    jpeg_brand_image_other.jpeg

${jpeg_shop_image_logo}    jpeg_shop_image_logo.jpeg
${jpeg_shop_image_store_front}    jpeg_shop_image_store_front.jpeg
${png_shop_image_menu}    png_shop_image_menu.png
${jpeg_shop_image_map}    jpeg_shop_image_map.jpeg
${jpeg_shop_image_other}    jpeg_shop_image_other.jpeg

*** Test Cases ***
# TC_O2O_24620_draft
    # [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can update Category, Sub Category, Brand Fraud Approval status on "Brand Fraud Approval" page
    # [Tags]    E2EExclude    o2o-merchant    cms    trueyou    truemoney    rpp-merchant-bs-api    rpp-merchanttransaction-ms-api    webhook    o2o-uaa    bifrost    platform-gateway    o2o-gateway    o2o-admintools    kafka
    # Switch To Non Angular JS Site
    # Open Browser With Option    ${TRUE_MONEY_ADMIN_PORTAL_URL}
    # Login TrueMoney Admin Portal    ${TRUE_MONEY_ADMIN_PORTAL_USERNAME}    ${TRUE_MONEY_ADMIN_PORTAL_PASSWORD}
    # Update TrueMoney Merchant Operation Status    110000000021814666772    CERTIFICATED
TC_O2O_24620_draft
    [Documentation]    [O2O Merchant Onboard - Tag39] Fraud admin can update Category, Sub Category, Brand Fraud Approval status on "Brand Fraud Approval" page
    [Tags]    E2EExclude    o2o-merchant    cms    trueyou    truemoney    rpp-merchant-bs-api    rpp-merchanttransaction-ms-api    webhook    o2o-uaa    bifrost    platform-gateway    o2o-gateway    o2o-admintools    kafka
    Open Browser With Option    ${TRUE_YOU_DEAL_MANAGEMENT_URL}
    Login Deal Management    ${DEAL_MANAGEMENT_APPROVER_USERNAME}    ${DEAL_MANAGEMENT_APPROVER_PASSWORD}
    Navigate To Deal Management Menu    RPP-EDC    PROSPECT
    Get First Partner Id On Merchant Table
    Go To Url    ${TRUE_YOU_DEAL_MANAGEMENT_URL}/rpp/edit/402095
    Verify Partner Requests Detail Information    ref_id=602f8854207d81000170477b    mid=602f8854207d81000170477b
    # Verify Shop Address    road=${TEST_DATA_BRAND_TRUEYOU_BRAND_ADDRESS_ROAD}
    # Verify CHRM Information    ${SHOP_IMAGE_STORE_FRONT_CONTENT_ID}    ${SHOP_IMAGE_MENU_CONTENT_ID}    ${SHOP_IMAGE_LOGO_CONTENT_ID}    ${SHOP_TRUEYOU_CONTENT_ID}
    # Clean Environment