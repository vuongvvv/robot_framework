*** Settings ***
Documentation    Create test data on AdminTools

Resource    ../../../api/resources/init.robot
Resource    ../../../web/resources/init.robot
Resource    ../../../web/keywords/admintools/common/common_keywords.robot
Resource    ../../../web/keywords/admintools/main_page/login_keywords.robot
Resource    ../../../web/keywords/admintools/user_management_user/user_group_keywords.robot

Test Setup    Run Keywords    Open Browser With Option    ${ADMIN_TOOLS_URL}    headless_mode=${False}
...    AND    Login Backoffice    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
...    AND    Navigate On Left Menu Bar    User Management    User Group    
Test Teardown    Clean Environment

*** Test Cases ***
UPDATE_TESTING_USER_GROUPS
    [Documentation]    ADD_USER_INTO_USER_GROUPS
    [Template]    Update User Group
    Sale Management    ${None}    ${ADMIN_TOOLS_USERNAME}
    Merchant Edit & History User Group    ${None}    ${ADMIN_TOOLS_USERNAME},${ROLE_USER}
    BiFrost Admin    ${None}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    
    robot_automation_test_user_group_customize    mbs.rpp-edc.history.get,merchant.merchant.actAsAdmin,weshop.order.admin    ${ROLE_USER}    
    robot_automation_test_user_group_merchant    merchantv2.brand.read,merchantv2.brand.actAsAdmin,merchantv2.callver.actAsAdmin,merchantv2.brandFraud.actAsAdmin    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER},${O2O_MERCHANT_USERNAME}
    robot_automation_test_user_group_membership    merchant.merchant.actAsAdmin,membership.member.list    ${MEMBERSHIP_USER}    
    robot_automation_test_user_group_uaa    uaa.config.write,uaa.userGroup.update,uaa.userGroup.create,uaa.userGroup.get,uaa.userGroup.list,uaa.userGroup.delete,uaa.user-app-blacklist.actAsAdmin,uaa.permission.get,uaa.permission.list,uaa.permissionGroup.get,uaa.permissionGroup.list,uaa.user.list,uaa.client-config.write    ${UAA_USERNAME}
    robot_automation_test_user_group_notification    notification.template.update    ${NOTIFICATION_PRODUCER_USERNAME}    Notification Template Admin Group,Notification History Admin Group
    robot_automation_test_user_group_point    point.entityAudit.actAsAdmin,point.point.list    ${POINT_USERNAME}
    robot_automation_test_user_group_admin_tools    mbs.rpp-edc.history.get,merchantv2.brandFraud.actAsAdmin,merchantv2.shop.actAsAdmin,merchantv2.shop.read    ${ADMIN_TOOLS_USERNAME}
    Mapping Service Admin    ${None}    ${MAPPING_USER}
    Supper Admin    ${None}    ${NOTIFICATION_USERNAME}
    Group for Campaign management    campaign.campaign.edit-active-campaign,campaign.campaign.delete-active-campaign    ${SUPER_ADMIN_USER}
    robot_automation_test_user_group_payment    paymentTransaction.msg.actAsAdmin,notification.message.actAsAdmin    ${PAYMENT_USER}
    TrueYou Campaign Admin    ${None}    ${SUPER_ADMIN_USER}
    TrueYou Campaign Super Admin    ${None}    ${SUPER_ADMIN_USER}