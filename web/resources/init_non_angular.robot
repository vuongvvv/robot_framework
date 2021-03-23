*** Settings ***
# http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#library-documentation-top
# https://rasjani.github.io/robotframework-seleniumtestability/index.html?tag=plugin
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;False
Resource    ../keywords/common/web_common.robot