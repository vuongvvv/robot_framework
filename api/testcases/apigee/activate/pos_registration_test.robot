*** Settings ***
Documentation    Tests to verify that POS REGISTRATION api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/apigee/apigee_activate_keywords.robot
Test Setup    Generate Apigee Header
Test Teardown    Delete All Sessions

*** Variables ***
${activation_code}    24044693
${imei}    869826022379141
${latitude}    ${13.7645001}
${longitude}    ${100.5679174}
${password}    2222

${invalid_activation_code}    24044692
${invalid_imei}    869826022379142
${activated_activation_code}    13989216          
    
*** Test Cases ***
TC_O2O_00539
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with invalid ACTIVATION CODE will return "ขออภัยค่ะ เลข Activation code ผิด กรุณาตรวจสอบอีกครั้ง" message
    [Tags]      Regression     Medium    Sanity    Smoke
    Post Pos Registration    { "activationCode": "${invalid_activation_code}", "imei": "${imei}", "latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${NOT_FOUND_CODE}
    Response Should Contain Property With Value    .status.code    ${${NOT_FOUND_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    ขออภัยค่ะ เลข Activation code ผิด กรุณาตรวจสอบอีกครั้ง
    
TC_O2O_00540
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with activated ACTIVATION CODE will return "เครื่องของคุณได้รับการลงทะเบ" message
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "activationCode": "${activated_activation_code}", "imei": "${imei}", "latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    เครื่องของคุณได้รับการลงทะเบียนแล้ว
    
TC_O2O_00541
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with invalid IMEI
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "activationCode": "${activation_code}", "imei": "${invalid_imei}", "latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    เครื่องของคุณได้รับการลงทะเบียนแล้ว
    
TC_O2O_00542
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with mising activationCode returns 400
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "imei": "${imei}", "latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    The activation_code is required
    Response Should Contain Property With Value    .errors..property    activation_code
    
TC_O2O_02529
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with mising imei returns 400
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "activationCode": "${activation_code}","latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    The imei is required
    Response Should Contain Property With Value    .errors..property    imei
    
TC_O2O_02530
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with mising password returns 400
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "activationCode": "${activation_code}","imei": "${imei}", "latitude": ${latitude}, "longitude": ${longitude} }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    The password is required
    Response Should Contain Property With Value    .errors..property    password
    
TC_O2O_00543
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api without body
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    ${EMPTY}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Empty JSON string
    Response Should Contain Property With Empty Value    .fields
    
TC_O2O_00544
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api without body
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    {}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .status.code    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    .status.message    Bad Request
    Response Should Contain Property With Value    .errors..message    The activation_code is required
    Response Should Contain Property With Value    .errors..property    activation_code
    
TC_O2O_00545
    [Documentation]     [API] [Apigee] [Activate] Verify Activate Apigee api with incorrect Json format
    [Tags]      Regression     Medium    NoUnitTest        
    Post Pos Registration    { "activationCode": "${activation_code}" "imei": "${imei}", "latitude": ${latitude}, "longitude": ${longitude}, "password": "${password}" }
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .displayCode    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    .messsage    Invalid Request Format: Missing comma in object literal
    Response Should Contain Property With Empty Value    .fields