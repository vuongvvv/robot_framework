*** Settings ***
Documentation    This test suites will check all the following Terminal APIs
...                 1. createTerminal: Create a new Terminal for the particulat Merchant ID and Outlet ID
...                 2. updateTerminal: Update Terminal Status to "DRAFT" or "DELETED"
...                 3. deleteTerminal: Update Terminal Status to "DELETED"
...                 4. listAllTerminals: Get All Terminals for the particulat Merchant ID and Outlet ID
...                 5. listTerminal: Get a Terminal Details by the particular Terminal ID

Resource    ../../../resources/init.robot
Resource    ../../../keywords/merchant/merchant_register_terminal_keywords.robot
Suite Setup    Prepare Test Suite Data
Test Setup    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
Test Teardown    Delete All Sessions

*** Variables ***
${TEST_USERNAME}    66819075885
${TEST_PASSWORD}    password
${terminal_status_draft}    DRAFT
${terminal_status_deleted}    DELETED
${invalid_merchant_id}    automationInvalidMerchantID
${invalid_outlet_id}    automationInvalidOutletID
${invalid_terminal_id}    automationInvalidTerminalID
${unauthorized_error}    unauthorized
${unauthorized_error_desc}    Full authentication is required to access this resource
${bad_request_title}    Bad Request
${bad_request_detail}    Required request body is missing ##>> THIS VALUE NEED TO BE UPDATED WHEN O2O-2658 IS FIXED
${forbidden_title}    Forbidden
${forbidden_detail}    Access is denied

*** Keywords ***
Create Valid Merchant And Outlet
    Create Test Merchant
    Get Created ID
    Set Suite Variable    ${valid_merchant_id}    ${get_id}
    Create Test Outlet    ${valid_merchant_id}
    Get Created ID
    Set Suite Variable    ${valid_outlet_id}    ${get_id}

Create Draft Terminal
    Create Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${terminal_status_draft}
    Get Created ID
    Set Suite Variable    ${draft_terminal_id}    ${get_id}

Create Deleted Terminal
    Create Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${terminal_status_deleted}
    Get Created ID
    Set Suite Variable    ${deleted_terminal_id}    ${get_id}

Create Merchant And Outlet With No Terminal
    Create Test Merchant
    Get Created ID
    Set Suite Variable    ${no_terminal_merchant}    ${get_id}
    Create Test Outlet    ${no_terminal_merchant}
    Get Created ID
    Set Suite Variable    ${no_terminal_outlet}    ${get_id}

Prepare Test Suite Data
    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}
    Create Valid Merchant And Outlet
    Create Draft Terminal
    Create Deleted Terminal

*** Test Cases ***
TC_O2O_00896
    [Documentation]    [createTerminal] Able to create Terminal with specific status if the Merchant ID and Outlet ID are valid
    [Tags]    Merchant    ExcludeRegression    ExcludeSmoke    High
    [Template]    Create Terminal Successfully
    ${valid_merchant_id}    ${valid_outlet_id}    ${terminal_status_draft}
    ${valid_merchant_id}    ${valid_outlet_id}    ${terminal_status_deleted}

TC_O2O_00899
    [Documentation]    [createTerminal] Unable to create Terminal if the entered Merchant ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Create Terminal    ${invalid_merchant_id}    ${valid_outlet_id}    ${terminal_status_draft}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00900
    [Documentation]    [createTerminal] Unable to create Terminal if the entered Outlet ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Create Terminal    ${valid_merchant_id}    ${invalid_outlet_id}    ${terminal_status_draft}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00901
    [Documentation]    [createTerminal] Unable to create Terminal if the entered Merchant ID and Outlet ID do not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Create Terminal    ${invalid_merchant_id}    ${invalid_outlet_id}    ${terminal_status_draft}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00903
    [Documentation]    [createTerminal] Unable to create Terminal if the entered Status is invalid
    [Tags]    Merchant    ExcludeRegression    Medium
    Create Terminal    ${valid_merchant_id}    ${valid_outlet_id}    INVALID
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property With Value    detail    ${bad_request_detail}    ##BUG-O2O-2658##

TC_O2O_00904
    [Documentation]    [createTerminal] Unable to create Terminal if the entered Status is empty
    [Tags]    Merchant    ExcludeRegression    Medium
    Create Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${NULL}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property With Value    detail    ${bad_request_detail}    ##BUG-O2O-2658##

TC_O2O_00906
    [Documentation]    [updateTerminal] Able to update Terminal Status to "DELETED" if the Merchant ID, Outlet ID, and Terminal ID are valid
    [Tags]    Merchant    ExcludeRegression    ExcludeSmoke    High
    Update Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}    ${terminal_status_deleted}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${draft_terminal_id}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    outletId    ${valid_outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status_deleted}

TC_O2O_00907
    [Documentation]    [updateTerminal] Able to update Terminal Status to "DRAFT" if the Merchant ID, Outlet ID, and Terminal ID are valid
    [Tags]    Merchant    ExcludeRegression    High
    Update Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${deleted_terminal_id}    ${terminal_status_draft}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${deleted_terminal_id}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    outletId    ${valid_outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status_draft}

TC_O2O_00908
    [Documentation]    [updateTerminal] Able to create new Terminal if the entered Terminal ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    [Setup]    Run Keywords    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}    AND    Set Non-Existing Terminal ID
    Update Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${non_existing_terminal}    ${terminal_status_draft}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${non_existing_terminal}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    outletId    ${valid_outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status_draft}

TC_O2O_00911
    [Documentation]    [updateTerminal] Unable to update Terminal Status if the entered Merchant ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Update Terminal    ${invalid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}    ${terminal_status_deleted}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00912
    [Documentation]    [updateTerminal] Unable to update Terminal Status if the entered Outlet ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Update Terminal    ${valid_merchant_id}    ${invalid_outlet_id}    ${draft_terminal_id}    ${terminal_status_deleted}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00914
    [Documentation]    [updateTerminal] Unable to update Terminal Status if the entered Status is invalid
    [Tags]    Merchant    ExcludeRegression    Medium
    Update Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}    INVALID
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property With Value    detail    ${bad_request_detail}    ##BUG-O2O-2658##

TC_O2O_00915
    [Documentation]    [updateTerminal] Unable to update Terminal Status if the entered Status is empty
    [Tags]    Merchant    ExcludeRegression    Medium
    Update Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}    ${NULL}
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    title    ${bad_request_title}
    Response Should Contain Property With Value    detail    ${bad_request_detail}    ##BUG-O2O-2658##

TC_O2O_00917
    [Documentation]    [deleteTerminal] Able to update Terminal Status to "DELETED" if the Merchant ID, Outlet ID, and Terminal ID are valid, Current status is "DRAFT"
    [Tags]    Merchant    ExcludeRegression    High
    Delete Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${draft_terminal_id}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    outletId    ${valid_outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status_deleted}

TC_O2O_00918
    [Documentation]    [deleteTerminal] Able to update Terminal Status to "DELETED" if the Merchant ID, Outlet ID, and Terminal ID are valid, Current status is "DELETED"
    [Tags]    Merchant    ExcludeRegression    Medium
    Delete Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${deleted_terminal_id}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Value    id    ${deleted_terminal_id}
    Response Should Contain Property With Value    merchantId    ${valid_merchant_id}
    Response Should Contain Property With Value    outletId    ${valid_outlet_id}
    Response Should Contain Property With Value    status    ${terminal_status_deleted}

TC_O2O_00921
    [Documentation]    [deleteTerminal] Unable to update Terminal Status if the entered Merchant ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Delete Terminal    ${invalid_merchant_id}    ${valid_outlet_id}    ${deleted_terminal_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00922
    [Documentation]    [deleteTerminal] Unable to update Terminal Status if the entered Outlet ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Delete Terminal    ${valid_merchant_id}    ${invalid_outlet_id}    ${deleted_terminal_id}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00923
    [Documentation]    [deleteTerminal] Unable to update Terminal Status if the entered Terminal ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Delete Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${invalid_terminal_id}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00925
    [Documentation]    [getAllTerminals] Able to retrieve the list of all Terminal that related to the particular Merchant ID and Outlet ID - Has Terminal
    [Tags]    Merchant    ExcludeRegression    High
    Get All Terminals    ${valid_merchant_id}    ${valid_outlet_id}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_00926
    [Documentation]    [getAllTerminals] Able to retrieve the list of all Terminal that related to the particular Merchant ID and Outlet ID - No Terminal
    [Tags]    Merchant    ExcludeRegression    High
    [Setup]    Run Keywords    Generate Access Token    ${ROLE_ADMIN}    ${ROLE_ADMIN_PASSWORD}    AND    Create Merchant And Outlet With No Terminal
    Get All Terminals    ${no_terminal_merchant}    ${no_terminal_outlet}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_00929
    [Documentation]    [getAllTerminals] Unable to retrieve the list of all Terminal if the entered Merchant ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get All Terminals    ${invalid_merchant_id}    ${valid_outlet_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00930
    [Documentation]    [getAllTerminals] Unable to retrieve the list of all Terminal if the entered Outlet ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get All Terminals    ${valid_merchant_id}    ${invalid_outlet_id}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00931
    [Documentation]    [getAllTerminals] Unable to retrieve the list of all Terminal if the entered Merchant ID and Outlet ID do not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get All Terminals    ${invalid_merchant_id}    ${valid_outlet_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00933
    [Documentation]    [getTerminal] Able to retrieve the Terminal Details if the Merchant ID, Outlet ID, and Terminal ID are valid
    [Tags]    Merchant    ExcludeRegression    High
    Get Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}
    Response Correct Code    ${SUCCESS_CODE}

TC_O2O_00936
    [Documentation]    [getTerminal] Unable to retrieve the Terminal Details if the entered Merchant ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get Terminal    ${invalid_merchant_id}    ${valid_outlet_id}    ${draft_terminal_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}

TC_O2O_00937
    [Documentation]    [getTerminal] Unable to retrieve the Terminal Details if the entered Outlet ID does not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get Terminal    ${valid_merchant_id}    ${invalid_outlet_id}    ${draft_terminal_id}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00938
    [Documentation]    [getTerminal] Unable to retrieve the Terminal Details if the entered Terminal ID does not exist in the system
    [Tags]    Merchant    Regression    Medium
    Get Terminal    ${valid_merchant_id}    ${valid_outlet_id}    ${invalid_terminal_id}
    Response Correct Code    ${NOT_FOUND_CODE}

TC_O2O_00939
    [Documentation]    [getTerminal] Unable to retrieve the Terminal Details if the entered Merchant ID, Outlet ID and Terminal ID do not exist in the system
    [Tags]    Merchant    ExcludeRegression    Medium
    Get Terminal    ${invalid_merchant_id}    ${invalid_outlet_id}    ${invalid_terminal_id}
    Response Correct Code    ${FORBIDDEN_CODE}
    Response Should Contain Property With Value    title    ${forbidden_title}
    Response Should Contain Property With Value    detail    ${forbidden_detail}
