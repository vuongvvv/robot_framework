*** Settings ***
# http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#library-documentation-top
Library    SeleniumLibrary    timeout=10s    implicit_wait=5s
# https://github.com/Selenium2Library/robotframework-angularjs
Library    AngularJSLibrary    root_selector=[ng-version]
Resource    ../resources/configs/${ENV}/env_config.robot
Resource    ../resources/configs/${ENV}/test_accounts.robot
Resource    ../resources/configs/${ENV}/test_data.robot
Resource    ../../api/resources/configs/${ENV}/env_config.robot
Resource    ../../api/resources/configs/${ENV}/test_accounts.robot
Resource    ../keywords/common/web_common.robot