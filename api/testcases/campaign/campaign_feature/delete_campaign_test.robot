*** Settings ***
Documentation    Tests to verify that the delete campaign APIs is return error properly as expected.
Resource        ../../../resources/init.robot
Resource        ../../../keywords/campaign/campaign_keywords.robot
Test Setup          Generate Admin Tools Gateway Header    ${SUPER_ADMIN_USER}    ${SUPER_ADMIN_PASSWORD}
Test Teardown       Delete All Sessions

*** Variables ***
${not_found_campaign_id}                  2000
${invalid_campaign_id}                    five
${bad_request_title}                      Bad Request
${intetnal_server_title}                  Internal Server Error

*** Test Cases ***
TC_O2O_01779
    [Documentation]    [Campaign][API][DeleteCampaign]Verify that API returns 404 when campaign is no found
    [Tags]     Campaign      Regression      Medium
    Delete Campaign By ID      ${not_found_campaign_id}
    Response Correct Code      ${INTERNAL_SERVER_CODE}
    Response Should Contain Property With Value    title     ${intetnal_server_title}

TC_O2O_01780
    [Documentation]    [Campaign][API][DeleteCampaign]Verify that API returns 400 when enter incorrect campaign id format
    [Tags]     Campaign      Regression      Medium
    Delete Campaign By ID      ${invalid_campaign_id}
    Response Correct Code      ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title     ${bad_request_title}