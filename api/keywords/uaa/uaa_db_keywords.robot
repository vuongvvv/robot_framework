*** Settings ***
Resource     ../common/database_common.robot

*** Keywords ***
Get User Internal ID
    [Arguments]    ${username}
    ${mobile_number}=    Replace String    ${username}    0    66    count=1
    ${uaa_user_id}=    Query    select id from jhi_user where mobile = ${mobile_number}
    [Return]    ${uaa_user_id[0][0]}