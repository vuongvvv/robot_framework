*** Settings ***
Resource      apigee_keywords.robot

*** Keywords ***
Get Campaign List
    [Arguments]      ${terminal_id}    ${params_uri}
    ${RESP}=    Get Request    ${APIGEE_SESSION}    /campaign/v1/terminals/${terminal_id}    params=${params_uri}    headers=&{api_headers}
    Set Test Variable    ${RESP}
    
# Template keywords
Get Campaign Without Params Return Success
    [Arguments]    ${terminal_id}    ${params_uri}
    Get Campaign List    ${terminal_id}    ${params_uri} 
    Response Correct Code    ${SUCCESS_CODE}  
    Response Should Contain All Property Values Are Number    content..brandId
    Response Should Contain All Property Values Are Number    content..branchId
    Response Should Contain All Property Values Are Number    content..terminalId
    Response Should Contain All Property Values Match Regex    content..campaign.code    ^(\\w+)[-](\\d+)$
    Response Should Contain All Property Values Are String    content..campaign.name
    Response Should Contain All Property Values Are Url    content..campaign.imageUrl
    Response Should Contain All Property Values Match Regex    content..campaign.start    ${yyyy_mm_dd_hh_mm_ss}
    Response Should Contain All Property Values Match Regex    content..campaign.end    ${yyyy_mm_dd_hh_mm_ss}
    Response Should Contain All Property Values Match Regex    content..campaign.lastModifiedDate    ${yyyy_mm_dd}
    Response Should Contain All Property Values Match Regex    content..campaign.status    ${status_regex}
    Response Should Contain Property With Integer Value    page..totalElements
    Response Should Contain Property With Integer Value    page..totalPages
    Response Should Contain Property With Integer Value    page..size
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious
    
Get Campaign With Invalid Params Return No Data
    [Arguments]    ${terminal_id}    ${params_uri}
    Get Campaign List    ${terminal_id}    ${params_uri}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Empty Value    content
    Response Should Contain Property With Value    page..totalElements    ${0}
    Response Should Contain Property With Value    page..totalPages    ${0}
    Response Should Contain Property With Value    page..size    ${0}
    Response Should Contain Property With Boolean    page..hasNext
    Response Should Contain Property With Boolean    page..hasPrevious