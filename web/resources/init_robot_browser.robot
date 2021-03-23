*** Settings ***
# https://rpaframework.org/libraries/browser_playwright/
# https://rpaframework.org/libdoc/RPA_Browser_Playwright.html
Library    Browser    timeout=20s
Resource    ../resources/configs/${ENV}/env_config.robot
Resource    ../resources/configs/${ENV}/test_accounts.robot
Resource    ../resources/configs/${ENV}/test_data.robot
Resource    ../../api/resources/configs/${ENV}/env_config.robot
Resource    ../../api/resources/configs/${ENV}/test_accounts.robot
Resource    ../keywords/common/robot_browser_web_common.robot