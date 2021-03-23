*** Settings ***
Documentation    Tests to verify that search campaign filter api works correctly

Resource    ../../../resources/init.robot
Resource    ../../../keywords/common/dummy_data_common.robot
Resource    ../../../keywords/project/project_resource_keywords.robot
Resource    ../../../keywords/promotion/campaign_resource_keywords.robot

Test Setup     Generate Gateway Header With Scope and Permission   ${PROMOTION_USERNAME}    ${PROMOTION_PASSWORD}    scope=proj.proj.w,proj.proj.r,camp.camp.w,camp.capm.r
Test Teardown  Run Keywords    Delete Created Client And User Group    AND    Delete All Sessions

*** Variables ***
${project_name}    Test campaign
${project_code}    Test_campaign
${project_description}     Test for Campaign
${create_campaign_filter_json_data}   ../../../api/resources/testdata/promotion/create_campaign_filter.json
${refCode}    TP00002
${campaign_name}   KFC 2019
${startDate}   1998-05-08T15:53:00Z
${endDate}     2000-05-08T15:53:00Z

*** Test Cases ***
TC_O2O_09740
    [Documentation]  To verify result and response when user searches by merchant Id incase: exact matched
    [Tags]    High    Regression    Smoke
    Post Create Project     {"name": "${project_name}","code": "${project_code}","description": "${project_description}"}
    Get Created ProjectID From Response
    Read Json From File   ${create_campaign_filter_json_data}
    Post Create Campaign     ${json_dummy_data}  ${project_id}
    Response Correct Code    ${CREATED_CODE}
    Get Created CampaignID From Response
    Get Created LastModifiedDate From Response
    Get All Campaigns  ${project_id}  conditions[merchantId].value.equals=M100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..when..conditions..attribute    merchantId
    Response Should Contain Property With Value   $..rules..when..conditions..value    M100

TC_O2O_09742
    [Documentation]  To verify result and response when user searches by Outlet Id incase: exact matched
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}  conditions[outletId].value.equals=O100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..when..conditions..attribute    outletId
    Response Should Contain Property With Value   $..rules..when..conditions..value    O100

TC_O2O_09744
    [Documentation]  To verify result and response when user searches by Terminal Id incase: exact matched
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}  conditions[terminalId].value.equals=T100
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..when..conditions..attribute    terminalId
    Response Should Contain Property With Value   $..rules..when..conditions..value    T100

TC_O2O_09746
    [Documentation]  To verify result and response when user searches by StartDate incase: equals
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    startDate.equals=${startDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..startDate    ${startDate}

TC_O2O_09747
    [Documentation]  To verify result and response when user searches by StartDate incase: greater than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    startDate.greaterThan=${startDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09748
    [Documentation]  To verify result and response when user searches by StartDate incase: greater or equal than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    startDate.greaterOrEqualThan=${startDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..startDate    ${startDate}

TC_O2O_09749
    [Documentation]  To verify result and response when user searches by StartDate incase: less than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    startDate.lessThan=${startDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09750
    [Documentation]  To verify result and response when user searches by StartDate incase: less or eqaul than
    [Tags]    High    Regression    Sanity
    Get All Campaigns  ${project_id}    startDate.lessOrEqualThan=${startDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..startDate    ${startDate}

TC_O2O_09751
    [Documentation]  To verify result and response when user searches by EndDate incase: equals
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    endDate.equals=${endDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..endDate    ${endDate}

TC_O2O_09752
    [Documentation]  To verify result and response when user searches by EndDate incase: greater than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    endDate.greaterThan=${endDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09753
    [Documentation]  To verify result and response when user searches by EndDate incase: greater or equal than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    endDate.greaterOrEqualThan=${endDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..endDate    ${endDate}

TC_O2O_09754
    [Documentation]  To verify result and response when user searches by EndDate incase: less than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    endDate.lessThan=${endDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09755
    [Documentation]  To verify result and response when user searches by EndDate incase: less or eqaul than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    endDate.lessOrEqualThan=${endDate}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..endDate    ${endDate}

TC_O2O_09756
    [Documentation]  To verify result and response when user searches by UpdateDate incase: equals
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    lastModifiedDate.equals=${LAST_MODIFIED_DATE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name    ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..lastModifiedDate    ${LAST_MODIFIED_DATE}

TC_O2O_09757
    [Documentation]  To verify result and response when user searches by UpdateDate incase: greater than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    lastModifiedDate.greaterThan=${LAST_MODIFIED_DATE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09758
    [Documentation]  To verify result and response when user searches by UpdateDate incase: greater or equal than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    lastModifiedDate.greaterOrEqualThan=${LAST_MODIFIED_DATE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..lastModifiedDate    ${LAST_MODIFIED_DATE}

TC_O2O_09759
    [Documentation]  To verify result and response when user searches by UpdateDate incase: less than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    lastModifiedDate.lessThan=${LAST_MODIFIED_DATE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09760
    [Documentation]  To verify result and response when user searches by UpdateDate incase: less or eqaul than
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    lastModifiedDate.lessOrEqualThan=${LAST_MODIFIED_DATE}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..lastModifiedDate    ${LAST_MODIFIED_DATE}

TC_O2O_09761
    [Documentation]  To verify result and response when user searches by Limit incase: True
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    quota.specified=True
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09762
    [Documentation]  To verify result and response when user searches by Limit incase: False
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    quota.specified=False
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}

TC_O2O_09763
    [Documentation]  To verify result and response when user searches by ActivityCode incase: exact matched
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}   conditions[activityCode].value.equals=ABC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}

TC_O2O_09770
    [Documentation]  To verify result and response when user searches by Payment [string] incase: exact matched
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}     actionData[EVERY_PAYMENT_AMOUNT].value.equals=500
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..then..data..attribute   EVERY_PAYMENT_AMOUNT
    Response Should Contain Property With Value   $..rules..then..data..value   500

TC_O2O_09771
    [Documentation]  To verify result and response when user searches by Payment [string] incase: contain search
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}     actionData[EVERY_PAYMENT_AMOUNT].value.equals=50
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09777
    [Documentation]  To verify result and response when user searches by Point [string] incase: exact matched
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}     actionData[GET_POINT].value.equals=200
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..then..data..attribute   GET_POINT
    Response Should Contain Property With Value   $..rules..then..data..value   200

TC_O2O_09778
    [Documentation]  To verify result and response when user searches by Point [string] incase: contain search
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}     actionData[GET_POINT].value.equals=20
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Not Contain Property   $..name
    Response Should Not Contain Property   $..refCode

TC_O2O_09779
    [Documentation]  To verify result and response when user searches more than one attribute
    [Tags]    High    Regression
    Get All Campaigns  ${project_id}    conditions[merchantId].value.equals=M100&actionData[GET_POINT].value.equals=200&actionData[EVERY_PAYMENT_AMOUNT].value.equals=500
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value   $..name     ${campaign_name}
    Response Should Contain Property With Value   $..refCode     ${refCode}
    Response Should Contain Property With Value   $..rules..then..data..attribute   EVERY_PAYMENT_AMOUNT
    Response Should Contain Property With Value   $..rules..then..data..value   500
    Response Should Contain Property With Value   $..rules..then..data..attribute   GET_POINT
    Response Should Contain Property With Value   $..rules..then..data..value   200
    Delete Campaign    ${campaign_id}    ${project_id}
    Delete Project  ${project_id}