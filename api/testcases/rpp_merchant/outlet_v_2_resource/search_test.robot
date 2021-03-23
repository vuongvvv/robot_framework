*** Settings ***
Documentation    Tests to verify that API search work correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/rpp_merchant/outlet_v_2_resource_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${RPP_MERCHANT_USERNAME}    ${RPP_MERCHANT_PASSWORD}    merchant.outlet.read
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${outlet_id}    999999999

*** Test Cases ***
TC_O2O_07558
    [Documentation]    [GetOutletV2] Verify GET API returns 400 Bad Request if outlet Id doesn't exist in RPP
    [Tags]    Regression    UnitTest    Sanity
    Get Search Outlet By Id    ${outlet_id}
    Verify Bad Request Response When Getting Outlet Not Exist    ${outlet_id}

