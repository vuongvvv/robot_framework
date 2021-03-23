*** Settings ***
Documentation    API for get address detail by postcode

Resource    ../../resources/init.robot
Resource    ../../keywords/tsm/address_resource_keywords.robot

*** Test Cases ***
TC_O2O_27173
    [Documentation]    get address detail with postcode correctly
    [Tags]    Regression    Smoke
    Generate Robot Automation Header    ${TSM_CLIENT_ID}    ${TSM_CLIENT_SECRET}    grant_type=client_credentials    client_id_and_secret=wolverine_robot_automation
    Get Address by Postcode    10210
    Response Correct Code    ${SUCCESS_CODE}

    #Province
    Response Property Should Be Equal As String    province.id    1
    Response Property Should Be Equal As String    province.nameEN    Bangkok
    Response Property Should Be Equal As String    province.nameTH    กรุงเทพมหานคร

    #District
    Response Property Should Be Equal As String    districts[0].id    36
    Response Property Should Be Equal As String    districts[0].nameEN    Don Mueang
    Response Property Should Be Equal As String    districts[0].nameTH    ดอนเมือง
    Fetch Property From Response    province.id    PROVINCE_ID
    Response Property Should Be Equal As String    districts[0].provinceId    ${PROVINCE_ID}

    #Sub District
    Response Property Should Be Equal As String    subDistricts[0].id    203
    Response Property Should Be Equal As String    subDistricts[0].nameEN    Si Kan
    Response Property Should Be Equal As String    subDistricts[0].nameTH    สีกัน
    Response Property Should Be Equal As String    subDistricts[0].postCode    10210
    Fetch Property From Response    districts[0].id    DISTRICT_ID
    Response Property Should Be Equal As String    subDistricts[0].districtId    ${DISTRICT_ID}

TC_O2O_27172
    [Documentation]    get address detail with postcode is invalid
    [Tags]    Regression    Smoke
    Generate Robot Automation Header    ${TSM_CLIENT_ID}    ${TSM_CLIENT_SECRET}    grant_type=client_credentials    client_id_and_secret=wolverine_robot_automation
    Get Address by Postcode    10001
    Response Correct Code    ${SUCCESS_CODE}

    Response Should Contain Property With Null Value    province
    Response Should Contain Property With Empty Value    districts
    Response Should Contain Property With Empty Value    subDistricts

TC_O2O_27169
    [Documentation]    get address detail without client scope
    [Tags]    Regression    Smoke
    Generate Robot Automation Header    robotautomationclientnoscope    robotautomationclientnoscope    grant_type=client_credentials    client_id_and_secret=robotautomationclientnoscope
    Get Address by Postcode    10210
    Response Correct Code    ${FORBIDDEN_CODE}