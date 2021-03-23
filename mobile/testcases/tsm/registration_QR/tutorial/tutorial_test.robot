*** Settings ***
Documentation       Tests to verify that the tutorial page display correctly as expected.
Resource            ../../../../resources/init.robot
Resource            ../../../../keywords/tsm/tutorial/tutorial_keywords.robot
Suite Setup         Open Apps   TSM
Suite Teardown      Close Application

*** Test Cases ***
TC_01
    [Documentation]     Verify when tutorial screen opened then show content of promotions correctly
    [Tags]      Regression      High       Tutorial     Smoke
    Tutorial Page Should Be Opened
    Merchant Registration Menu Show Correctly
    Access Activation Code Menu Show Correctly
    Check Status Merchant Menu Show Correctly
    Capture Page Screenshot         filename=TC_01.png