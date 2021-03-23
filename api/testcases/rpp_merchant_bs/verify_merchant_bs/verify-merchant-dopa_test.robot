*** Settings ***
Resource    ../../../resources/init.robot
Resource    ../../../keywords/rpp_merchant_bs/login_keywords.robot
Resource        ../../../keywords/rpp_merchant_bs/merchant_dopa_keywords.robot
Test Setup    Generate Merchant Bs Header     ${RPP_AUTOMATE_SALE_USER}    ${RPP_AUTOMATE_SALE_PASSWORD}
Test Teardown    Delete All Sessions  

*** Test Cases ***
TC_O2O_10338
    [Documentation]   Check Merchant Dopa
    [Tags]    Regression    Sanity    Smoke   
    Post Api Check Merchant Dopa     { "mobile" : "0866636566", "card_no" : "1600100366042" }
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    status.code    ${200}
    Response Should Contain Property With Value    status.text    Success
    Response Should Contain Property With Value    data.result    success
    Response Should Contain Property With Empty Value    data.message