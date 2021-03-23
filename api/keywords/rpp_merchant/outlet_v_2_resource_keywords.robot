*** Settings ***
Resource    ../rpp_merchant/merchant_resource_keywords.robot
Resource    ../common/json_common.robot
Resource    ../common/string_common.robot
Library    Collections
Library    JSONLibrary

*** Variables ***
${random_length}    7

*** Keywords ***
Get Search Outlet
    [Arguments]    ${params_uri}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/outlets    params=${params_uri}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Search Outlet By Id
    [Arguments]    ${outlet_id}    ${fields}=${EMPTY}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/outlets/${outlet_id}    params=${fields}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Get Outlet Contact Person
    [Arguments]    ${id}
    ${RESP}=    Get Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/outlets/${id}/contactPersons    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Post Create Outlets And Address Ref Merchant Id
    [Arguments]    ${json_body}
    ${REQ_JSON}=    evaluate    json.loads('''${json_body}''')    json
    Set Test Variable    ${REQ_JSON}    ${REQ_JSON}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/outlets    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}
    @{outlet_sequence_id}    Get Value From Json    ${RESP.json()}    $.outlets[0].id
    Set Test Variable    ${OUTLET_SEQUENCE_ID}    ${outlet_sequence_id}[0]

Post Create Invalid Outlets And Address Ref Merchant Id
    [Arguments]    ${json_body}
    ${RESP}=    Post Request    ${GATEWAY_SESSION}    /rpp-merchant/api/v2/outlets    data=${json_body}    headers=&{GATEWAY_HEADER}
    Set Test Variable    ${RESP}

Create Merchant And Outlet With Dummy Data
    [Arguments]    ${merchant_json_data}    ${outlet_json_data}
    Generate Gateway Header With Scope and Permission    ${ROLE_USER}    ${ROLE_USER_PASSWORD}    merchant.merchant.write,merchant.outlet.write
    ${random_string}=    Generate Random String    ${random_length}    [NUMBERS]
    Read Json From File    ${merchant_json_data}
    Update Json Data    $.merchantId    ${random_string}
    Update Json Data    $.'trueyouId'    ${random_string}
    Post Create Merchant    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    @{merchant_sequence_id}    Get Value From Json    ${RESP.json()}    $.id
    Read Json From File    ${outlet_json_data}
    Update Json Data    $.outlets[0].merchantId    ${merchant_sequence_id[0]}
    Post Create Outlets And Address Ref Merchant Id    ${json_dummy_data}
    Response Correct Code    ${CREATED_CODE}
    @{outlet_id}    Get Value From Json    ${RESP.json()}    $.outlets[0].id
    ${OUTLET_ID}    Set Variable    ${outlet_id[0]}
    Delete Created Client And User Group
    Set Test Variable    ${OUTLET_ID}

Get Outlet Id From List Of Outlets By Index
    [Arguments]    ${index}    ${params_uri}=page=0&size=12&sort=id,desc
    Get Search Outlet    ${params_uri}
    ${OUTLET_SEQUENCE_ID}    Get Property Value From Json By Index    content[0].id    ${index}
    Set Test Variable    ${OUTLET_SEQUENCE_ID}

Verify The Successful Response Of Contact Persons
    [Arguments]    ${index}
    Response Should Contain Property With Value    [${index}].titleId    ${REQ_JSON}[outlets][0][contactPersons][${index}][titleId]
    Response Should Contain Property With Value    [${index}].titleOtherName    ${REQ_JSON}[outlets][0][contactPersons][${index}][titleOtherName]
    Response Should Contain Property With Value    [${index}].firstNameTh    ${REQ_JSON}[outlets][0][contactPersons][${index}][firstNameTh]
    Response Should Contain Property With Value    [${index}].lastNameTh    ${REQ_JSON}[outlets][0][contactPersons][${index}][lastNameTh]
    Response Should Contain Property With Value    [${index}].firstNameEn    ${REQ_JSON}[outlets][0][contactPersons][${index}][firstNameEn]
    Response Should Contain Property With Value    [${index}].lastNameEn    ${REQ_JSON}[outlets][0][contactPersons][${index}][lastNameEn]
    Response Should Contain Property With Value    [${index}].refType    outlet
    Response Should Contain Property With Value    [${index}].phoneNo    ${REQ_JSON}[outlets][0][contactPersons][${index}][phoneNo]
    Response Should Contain Property With Value    [${index}].mobileNo    ${REQ_JSON}[outlets][0][contactPersons][${index}][mobileNo]
    Response Should Contain Property With Value    [${index}].email    ${REQ_JSON}[outlets][0][contactPersons][${index}][email]
    Response Should Contain Property With Value    [${index}].thaiId    ${REQ_JSON}[outlets][0][contactPersons][${index}][thaiId]
    Response Should Contain Property With Value    [${index}].passportNo    ${REQ_JSON}[outlets][0][contactPersons][${index}][passportNo]
    Response Should Contain Property With Value    [${index}].birthDate    ${REQ_JSON}[outlets][0][contactPersons][${index}][birthDate]
    Response Should Contain Property With Value    [${index}].gender    ${REQ_JSON}[outlets][0][contactPersons][${index}][gender]
    Response Should Contain Property With Value    [${index}].occupation    ${REQ_JSON}[outlets][0][contactPersons][${index}][occupation]

Verify The Successful Response Of Getting Outlet With Request Body
    [Arguments]    ${index}=0
    Response Should Contain Property With Value    outletId    ${REQ_JSON}[outlets][${index}][outletId]
    Response Should Contain Property With Value    outletNameTh    ${REQ_JSON}[outlets][${index}][outletNameTh]
    Response Should Contain Property With Value    outletNameEn    ${REQ_JSON}[outlets][${index}][outletNameEn]
    Response Should Contain Property With Value    outletDetail    ${REQ_JSON}[outlets][${index}][outletDetail]
    Response Should Contain Property With Value    headQuarter    ${REQ_JSON}[outlets][${index}][headQuarter]
    Response Should Contain Property With Value    registerChannel    ${REQ_JSON}[outlets][${index}][registerChannel]
    Response Should Contain Property With Value    franchisee    ${REQ_JSON}[outlets][${index}][franchisee]
    Response Should Contain Property With Value    saleId    ${REQ_JSON}[outlets][${index}][saleId]
    Response Should Contain Property With Value    contactPersons.[0].titleId    ${REQ_JSON}[outlets][${index}][contactPersons][0][titleId]
    Response Should Contain Property With Value    contactPersons.[0].titleOtherName    ${REQ_JSON}[outlets][${index}][contactPersons][0][titleOtherName]
    Response Should Contain Property With Value    contactPersons.[0].firstNameTh    ${REQ_JSON}[outlets][${index}][contactPersons][0][firstNameTh]
    Response Should Contain Property With Value    contactPersons.[0].lastNameTh    ${REQ_JSON}[outlets][${index}][contactPersons][0][lastNameTh]
    Response Should Contain Property With Value    contactPersons.[0].firstNameEn    ${REQ_JSON}[outlets][${index}][contactPersons][0][firstNameEn]
    Response Should Contain Property With Value    contactPersons.[0].lastNameEn    ${REQ_JSON}[outlets][${index}][contactPersons][0][lastNameEn]
    Response Should Contain Property With Value    contactPersons.[0].phoneNo    ${REQ_JSON}[outlets][${index}][contactPersons][0][phoneNo]
    Response Should Contain Property With Value    contactPersons.[0].mobileNo    ${REQ_JSON}[outlets][${index}][contactPersons][0][mobileNo]
    Response Should Contain Property With Value    contactPersons.[0].email    ${REQ_JSON}[outlets][${index}][contactPersons][0][email]
    Response Should Contain Property With Value    contactPersons.[0].thaiId    ${REQ_JSON}[outlets][${index}][contactPersons][0][thaiId]
    Response Should Contain Property With Value    contactPersons.[0].passportNo    ${REQ_JSON}[outlets][${index}][contactPersons][0][passportNo]
    Response Should Contain Property With Value    contactPersons.[0].birthDate    ${REQ_JSON}[outlets][${index}][contactPersons][0][birthDate]
    Response Should Contain Property With Value    contactPersons.[0].gender    ${REQ_JSON}[outlets][${index}][contactPersons][0][gender]
    Response Should Contain Property With Value    contactPersons.[0].occupation    ${REQ_JSON}[outlets][${index}][contactPersons][0][occupation]

Verify Bad Request Response When Creating Outlet With Merchant Not Exist
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    fieldErrors..message    Merchant with id = 212121212121 not found.
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    path    /api/v2/outlets
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    outlet
    Response Should Contain Property With Value    fieldErrors..field    merchantId

Get Outlet Sequence Id
    ${outlet_sequence_id} =    Get Property Value From Json By Index    .id    0
    Set Test Variable    ${OUTLET_SEQUENCE_ID}    ${outlet_sequence_id}

Get Outlet Id
    ${outlet_id} =    Get Property Value From Json By Index    .outletId    0
    Set Test Variable    ${OUTLET_ID}    ${outlet_id}

Verify Bad Request Response When Getting Outlet Not Exist
    [Arguments]    ${outlet_id}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    fieldErrors..message    outlet id not found
    Response Should Contain Property With Value    fieldErrors..field    Outlet ID : ${outlet_id}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Method argument not valid
    Response Should Contain Property With Value    path    /api/v2/outlets/${outlet_id}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    fieldErrors..objectName    outlet

Get Random Outlets IDs Follow Business Instruction
    [Arguments]    ${amount}
    @{OUTLET_TY_ID}=        Create List
    @{OUTLET_TMN_ID}=        Create List
    @{OUTLET_EXTERNAL_ID}=        Create List
    ${rand_num}=    Get Random Strings    10    [NUMBERS]
    ${outlet_TMN_id_prefix}=    Set Variable    ${rand_num}
    FOR  ${INDEX}    IN RANGE    0    ${amount}
        ${rand_num}=    Get Random Strings    15    [NUMBERS]
        Append To List    ${OUTLET_TY_ID}    ${rand_num}
        ${outlet_id}=    Get Substring    ${rand_num}    10    15
        Append To List    ${OUTLET_EXTERNAL_ID}    ${outlet_id}
        ${outlet_TMN_id_temp}=    Set Variable    ${outlet_TMN_id_prefix}0000${INDEX}
        Append To List    ${OUTLET_TMN_ID}    ${outlet_TMN_id_temp}
    END
    Set Test Variable    @{OUTLET_EXTERNAL_ID}    @{OUTLET_EXTERNAL_ID}
    Set Test Variable    @{OUTLET_TY_ID}    @{OUTLET_TY_ID}
    Set Test Variable    @{OUTLET_TMN_ID}    @{OUTLET_TMN_ID}