*** Settings ***
Documentation    Tests to verify that changeTrueYouStatusToInProgress api works correctly
Resource    ../../../resources/init.robot  # Get the configuaration
Resource    ../../../keywords/common/gateway_common.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/merchant/rpp_merchant_register_merchant_keywords.robot
Resource    ../../../keywords/merchant/rpp_merchant_register_outlet_keywords.robot
Test Setup    Generate Gateway Header With Scope and Permission    ${O2O_MERCHANT_USERNAME}    ${O2O_MERCHANT_PASSWORD}    merchant.outlet.write
Test Teardown    Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${merchant_TMN_TY_json_data}    ../../resources/testdata/component/feature/merchant/create_rpp_merchant_data_TMN_TY.json
${merchant_TMN_json_data}    ../../resources/testdata/component/feature/merchant/create_rpp_merchant_data_TMN.json
${outlet_json_data}    ../../resources/testdata/component/feature/merchant/create_rpp_outlet_data.json
${length}    7

*** Test Cases ***
TC_O2O_11873
    [Documentation]    [TY Merchant] Verify the API return 200 when updating the status from WAITING to IN_PROGRESS for all the outlets belong to the merchant
    [Tags]    Regression    High    Minos-2019S08
    # create merchant
    ${random_string}=    Generate Random String    ${length}    [NUMBERS]
    Read Json From File    ${merchant_TMN_TY_json_data}
    Update Json Data    $.merchantId    ${random_string}
    Update Json Data    $.refId    ${random_string}
    Update Json Data    $.'trueyouId'    ${random_string}
    Post Create Merchant    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    @{merchant_brand_id}    Get Value From Json    ${RESP.json()()}    $.merchantId
    @{merchant_sequence_id}    Get Value From Json    ${RESP.json()()}    $.id

    # create outlet
    Read Json From File    ${outlet_json_data}
    Post Create Outlets And Address Ref Merchant Id    ${merchant_brand_id[0]}    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Get Value From Json    ${RESP.json()()}    $.merchantId
    @{outlet_id}    Get Value From Json    ${RESP.json()()}    $.outlets[0].id
    Response Should Contain Property With Value    outlets[0].'trueyouStatus'    WAITING

    # Change TY outlet to in-progress
    Put Change True You Status To In Progress    ${merchant_sequence_id[0]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    outlets[0].'trueyouStatus'    IN_PROGRESS
    Response Should Contain Property With Value    outlets[0].id    ${outlet_id[0]}

TC_O2O_11875
    [Documentation]    [TY Merchant] Verify the API does NOT update the outlet that has status is Approve, IN_PROGRESS
    [Tags]    Regression    High    Minos-2019S08
    # create merchant
    ${random_string}=    Generate Random String    ${length}    [NUMBERS]
    Read Json From File    ${merchant_TMN_json_data}
    Update Json Data    $.merchantId    ${random_string}
    Update Json Data    $.refId    ${random_string}
    Update Json Data    $.'trueyouId'    ${random_string}
    Post Create Merchant    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    @{merchant_brand_id}    Get Value From Json    ${RESP.json()()}    $.merchantId
    @{merchant_sequence_id}    Get Value From Json    ${RESP.json()()}    $.id

    # create outlet
    Read Json From File    ${outlet_json_data}
    Post Create Outlets And Address Ref Merchant Id    ${merchant_brand_id[0]}    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    Get Value From Json    ${RESP.json()()}    $.merchantId
    @{outlet_id}    Get Value From Json    ${RESP.json()()}    $.outlets[0].id
    Response Should Contain Property With Value    outlets[0].'trueyouStatus'    ${None}

    # Change TY outlet to in-progress
    Put Change True You Status To In Progress    ${merchant_sequence_id[0]}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property    outlets[0]
