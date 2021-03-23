*** Settings ***
Documentation    Create test data on AdminTools

Resource    ../../../api/resources/init.robot
Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../web/keywords/admintools/client/client_keywords.robot

Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}
...    AND    Login Backoffice    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
...    AND    Navigate On Left Menu Bar    Application    Client
Test Teardown    Clean Environment

*** Test Cases ***
CREATE_TESTING_CLIENT_IDS
    [Documentation]    CREATE_TESTING_CLIENT_IDS
    [Template]    Check And Create Client Id
    robotautomationclientnoscope    robotautomationclientnoscope    robotautomationclientnoscope    invalidScope    Password,Client Credentials
    robotautomationclientcms    robotautomationclientcms    robotautomationclientcms    cms.ct.*    Password,Client Credentials

UPDATE_TESTING_CLIENT_IDS
    [Documentation]    UPDATE_TESTING_CLIENT_IDS
    [Template]    Update Client Id
    robotautomationclientname    merchant.merchant.write,activationcode.write,activationcode.read,merchant.terminal.read,merchant.outlet.actAsAdmin,proj.proj.w,paymentTx.read,paymentRawTx.create,payment.payment.write,merchant.outlet.read,merchant.merchant.write,merchant.outlet.write,products.r,products.w,products.d,psnl.products.r,file.write,kyb.document.write,shop.kyb.write,merchantv2.shopContractTmn.write,shop.write,terminal.write,brand.kyb.write,merchantv2.category.read,merchantv2.subcategory.read,merchantv2.callver.write,merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantTx.create,sms.read,weshop.order.*,weshop.order.confirm,merchant.merchant.autobind,brand.write,campaign.promotion.create,campaign.usage.create,campaign.promotion.update,batch_processor,sms.read,sms.create,notification.push.create,push-notification.configuration.write,notification.push.register,push-notification.configuration.read,account.update,signin.line,uaa.config.write,uaa.client-config.write,signin.sms-otp,merchant.merchant.read,merchant.merchant.updateTmnStatus,merchant.merchant.updateTyStatus
    robotautomationclientname    merchant.terminal.read,proj.proj.w,paymentTx.read,paymentRawTx.create,payment.payment.write,merchant.outlet.read,merchant.merchant.write,merchant.outlet.write,products.r,products.w,products.d,psnl.products.r,file.write,kyb.document.write,shop.kyb.write,merchantv2.shopContractTmn.write,shop.write,terminal.write,brand.kyb.write,merchantv2.category.read,merchantv2.subcategory.read,merchantv2.callver.write,merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantTx.create,sms.read,weshop.order.*,weshop.order.confirm,merchant.merchant.autobind,brand.write,campaign.promotion.create,campaign.usage.create,campaign.promotion.update,batch_processor,sms.read,sms.create,notification.push.create,push-notification.configuration.write,notification.push.register,push-notification.configuration.read,account.update,signin.line,uaa.config.write,uaa.client-config.write,signin.sms-otp,merchant.merchant.read,merchant.merchant.updateTmnStatus,merchant.merchant.updateTyStatus
    robotautomationclientpayment_admin    payment.payment.actAsAdmin,payment.payment.charge
    robotautomationclientpayment    robotautomationclientpayment    robotautomationclientpayment    payment.payment.read,paymentTx.read,paymentRawTx.create,payment.payment.write    Password,Client Credentials
    robotautomationclientpayment_onetime_otp    robotautomationclientpayment_onetime_otp    robotautomationclientpayment_onetime_otp    payment.tmn.otp,payment.tmn.token,payment.wallet.delete,payment.tmn.charge,payment.tmn.refund,payment.wallet.read,payment.payment.read,paymentTx.read    Password,Client Credentials
    robotautomationclientpayment_creditcard    payment.payment.charge,payment.payment.void,payment.payment.refund,payment.payment.read,paymentTx.read,payment.recurring.read,payment.payment.list,payment.recurring.update,payment.recurring.cancel
    robotautomationclientpayment_no_authority    payment.tmn.otp,payment.wallet.read,payment.wallet.delete,payment.tmn.charge,payment.tmn.refund,payment.payment.read,payment.payment.list,payment.recurring.update,payment.recurring.cancel
    robotautomationclient_wepayment    merchant.truemonyStatus.read,paymentTx.read,merchant.merchant.read,payment.transfer.sync
