*** Settings ***
Resource    ../../../resources/locators/admintools/common/common_locators.robot
Resource    ../../common/web_common.robot

*** Variable ***
${time_out}    5

*** Keywords ***
Verify Dashboards Page Displays
    Switch To New Window    NEW
    Wait Until Element Is Visible    ${lbl_dashboards}    ${time_out}
    Element Should Be Visible    ${lbl_dashboards}
