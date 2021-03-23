*** Settings ***
Documentation    Tests to verify that the get campaign APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot
Test Setup          Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
Test Teardown       Delete All Sessions

*** Variables ***
${not_found_campaign_id}                  2000
${invalid_campaign_id}                    five
${bad_request_title}                      Bad Request

*** Test Cases ***
TC_O2O_01762
    [Documentation]    [Campaign][API][GetCampaignDetails]Verify that API returns 404 when campaign is no found
    [Tags]     Campaign      Regression      Medium
    Get Campaign By ID      ${not_found_campaign_id}
    Response Correct Code      ${NOT_FOUND_CODE}

TC_O2O_01763
    [Documentation]    [Campaign][API][GetCampaignDetails]Verify that API returns 400 when enter incorrect campaign id format
    [Tags]     Campaign      Regression      Medium
    Get Campaign By ID      ${invalid_campaign_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}