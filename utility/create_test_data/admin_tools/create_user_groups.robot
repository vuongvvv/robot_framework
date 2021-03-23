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
CREATE_USER_GROUPS
    [Documentation]    Draft test case to create e2e-tests folder
    [Template]    Check And Create User Group
    Supper Admin    ${None}    merchant.merchant.actAsAdmin,merchant.merchant.get,merchant.merchant.delete,merchant.merchant.update,campaign.paymentMethod.actAsAdmin,merchant.merchant.create,notification.message.actAsAdmin,notification.message.list,notification.message.get,notification.message.delete,notification.message.update,notification.message.create,notification.message.approve,notification.message.reject,notification.registration.approve,notification.registration.reject,notification.merchant.updateQuota,notification.type.list,notification.type.get,merchant.address.actAsAdmin,merchant.category.actAsAdmin,notification.type.delete,notification.type.update,notification.type.create,notification.type.quotaUpdate,membership.subscription.create,membership.subscription.delete,membership.member.list,notification.entityAudit.actAsAdmin,campaign.campaign.actAsAdmin,estamp.estamp.actAsAdmin,notification.template.read    ${None}
    Sale Management    ${None}    mbs.rpp-cm-tool.history.get    ${None}
    BiFrost Admin    ${None}    bifrost.dev    ${None}
    robot_automation_test_user_group_point    ${None}    ${None}    ${None}
    robot_automation_test_user_group_admin_tools    ${None}    ${None}    ${None}
    robot_automation_test_user_group_payment    ${None}    ${None}    ${None}