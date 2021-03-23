*** Settings ***
Documentation    Tests to verify that the create campaign APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot
Suite Setup         Prepare Test Suite Data
Test Setup          Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
Test Teardown       Delete All Sessions

*** Variables ***
${campaign_merchant_type}            merchant
${campaign_customer_type}            customer
${campaign_group}                    university
${spending_amount}                   20000
${payment_id}                        1
${point}                             5
${minimum_spending}                  500
${daily_cap}                         200000
${monthly_cap}                       5000000
${status}                            ACTIVE
${invalid_campaign_type}             true
${invalid_spending_amount}           ten bath
${invalid_point}                     two
${invalid_minimum_spending}          @ten
${invalid_daily_cap}                 ten thousand
${invalid_monthly_cap}               200000 THB
${invalid_status}                    ACTIVATE
${invalid_payment_id}                100

${bad_request_title}                 Bad Request
${intetnal_server_title}             Internal Server Error
${invalid_end_date_message}          Start date should be before end date

*** Keywords ***
Prepare Test Suite Data
    Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
    Set Campaign Date Period

*** Test Cases ***
TC_O2O_01811
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter type are not customer or merchant
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${invalid_campaign_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01740
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when some require filed is empty
    [Tags]     Campaign      Regression      Medium
    [Template]      Create Campaign With Required Fields Is Empty
    ${EMPTY}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${status}

    ${campaign_customer_type}    ${EMPTY}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${status}

    ${campaign_customer_type}    ${campaign_group}    ${EMPTY}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${status}

    ${campaign_customer_type}    ${campaign_group}    ${spending_amount}     ${payment_id}   ${EMPTY}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${status}

    ${campaign_customer_type}    ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${EMPTY}   ${end_date}     ${status}

    ${campaign_customer_type}    ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${EMPTY}     ${status}

    ${campaign_customer_type}    ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${EMPTY}

TC_O2O_01741
    [Documentation]     [Campaign][API][CreateCampaign] Verify that API will return error when multiple require fileds are empty
    [Tags]     Campaign      Regression      Medium
    [Template]      Create Campaign With Required Fields Is Empty
    ${EMPTY}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${EMPTY}   ${end_date}     ${status}

    ${campaign_customer_type}    ${EMPTY}    ${spending_amount}     ${payment_id}   ${EMPTY}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}   ${end_date}     ${status}

TC_O2O_01742
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when some required fileds is missing
    [Tags]     Campaign      Regression      Medium
    [Template]      Create Campaign With Required Fields Is Missing
    {"group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","group":"${campaign_group}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}"}

TC_O2O_01743
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when multiple required fileds are missing
    [Tags]     Campaign      Regression      Medium
    [Template]      Create Campaign With Required Fields Is Missing
    {"group":"${campaign_group}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"point":"${point}","minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"endDate":"${end_date}","status":"${status}"}

    {"type":"${campaign_customer_type}","spendingAmount":"${spending_amount}","paymentMethods":[{"id":${payment_id},"methodCode":"WALLET","methodName":"True Wallet","description":"Paid via True Wallet"}],"minimumSpending":"${minimum_spending}","dailyCap":${daily_cap},"monthlyCap":${monthly_cap},"startDate":"${start_date}","endDate":"${end_date}","status":"${status}"}

TC_O2O_01744
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter incorrect data type on spendingAmount field (decimal only)
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${invalid_spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01745
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter incorrect data type on point field (integer only)
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${invalid_point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01746
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter incorrect data type on minimumSpending field (decimal only)
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${invalid_minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01747
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter incorrect data type on dailyCap field (decimal only)
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${invalid_daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01748
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter incorrect data type on monthlyCap field (decimal only)
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${invalid_monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01751
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter status are not INACTIVE or ACTIVE
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${invalid_status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}

TC_O2O_01753
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API will return error when enter payment method are not WALLET or ALIPAY
    [Tags]     Campaign      Regression      Medium
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${invalid_payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    title     ${intetnal_server_title}

TC_O2O_02128
    [Documentation]    [Campaign][API][CreateCampaign] Verify that API create campagin will return error when set startDate field > EndDate
    [Tags]     Campaign      Regression      Medium
    Set Campaign End Date is Yesterday
    Create Campaign     ${campaign_customer_type}   ${campaign_group}    ${spending_amount}     ${invalid_payment_id}   ${point}    ${minimum_spending}
    ...     ${daily_cap}     ${monthly_cap}    ${start_date}    ${end_date}    ${status}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    globalErrors..message     ${invalid_end_date_message}



