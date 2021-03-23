*** Settings ***
Documentation    CREATE_TRUE_TOWN_TEST_DATA

Resource    ../../../api/resources/init.robot
Resource    ../../../api/keywords/merchant_v2/account_resource_keywords.robot
Resource    ../../../api/resources/testdata/alpha/weshop/weshop_data.robot

# scope=merchant.merchant.autobind
Test Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}
Test Teardown     Delete All Sessions

*** Test Cases ***
CREATE_TRUE_TOWN_TEST_DATA
    [Documentation]    CREATE_TRUE_TOWN_TEST_DATA
    Post Auto Binding True You Link    ${TSM_MERCHANT_ID}
    Response Correct Code    ${CREATED_CODE}