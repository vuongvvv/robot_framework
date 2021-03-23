*** Settings ***
Documentation    Tests to verify that SearchTransaction api works correctly
Resource    ../../../resources/init.robot
Resource    ../../../keywords/payment/transaction_resource_keywords.robot
Test Setup    Generate Robot Automation Header    ${PAYMENT_USER}    ${PAYMENT_PASSWORD}   client_id_and_secret=robotautomationclientpayment
Test Teardown     Delete All Sessions
#Require Client Scope: payment.payment.read

*** Variables ***
${date_regex}    ^\\d{4}[-]\\d{2}[-]\\d{2}[T]\\d{2}[:]\\d{2}[:]\\d{2}[Z]$

*** Test Cases ***
TC_O2O_07805
    [Documentation]    [payment][Search Transaction] Request with "payment.payment.read" scope returns 200
    [Tags]    High    Regression    Sanity    Smoke    payment
    Get Search Transaction
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13390
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid merchantId
    [Tags]    Low    Regression    payment
    Get Search Transaction    merchantId=xxxxxx
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is String Or Empty List    content
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Value    totalPages    ${0}
    Response Should Contain Property With Value    totalElements    ${0}
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${0}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}


TC_O2O_13391
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid merchantId
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    merchantId=${BRAND_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Number String    totalPages
    Response Should Contain Property With Number String    totalElements
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${20}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}

TC_O2O_13392
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid outletId
    [Tags]    Low    Regression    payment
    Get Search Transaction    outletId=xxxxxx
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is String Or Empty List    content
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Value    totalPages    ${0}
    Response Should Contain Property With Value    totalElements    ${0}
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${0}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}

TC_O2O_13393
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid outletId
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    outletId=${BRANCH_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId


TC_O2O_13394
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid terminalId
    [Tags]    Low    Regression    payment
    Get Search Transaction    terminalId=xxxxxx
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is String Or Empty List    content
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Value    totalPages    ${0}
    Response Should Contain Property With Value    totalElements    ${0}
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${0}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}

TC_O2O_13395
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid terminalId
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    terminalId=${TERMINAL_ID}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13396
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid mobile number
    [Tags]    Low    Regression    payment
    Get Search Transaction    mobile=66610090735
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is String Or Empty List    content
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Value    totalPages    ${0}
    Response Should Contain Property With Value    totalElements    ${0}
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${0}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}

TC_O2O_13397
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid mobile number
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    mobile=0610090735
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13398
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid amount
    [Tags]    Low    Regression    payment
    Get Search Transaction    amount=10000.99
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property Value Is String Or Empty List    content
    Response Should Contain All Property Values Are Boolean    pageable.sort.sorted
    Response Should Contain All Property Values Are Boolean    pageable.sort.unsorted
    Response Should Contain Property With Value    pageable.pageSize    ${20}
    Response Should Contain Property With Value    pageable.pageNumber    ${0}
    Response Should Contain Property With Value    pageable.offset    ${0}
    Response Should Contain All Property Values Are Boolean    pageable.paged
    Response Should Contain All Property Values Are Boolean    pageable.unpaged
    Response Should Contain All Property Values Are Boolean    first
    Response Should Contain All Property Values Are Boolean    last
    Response Should Contain Property With Value    totalPages    ${0}
    Response Should Contain Property With Value    totalElements    ${0}
    Response Should Contain All Property Values Are Boolean    sort.sorted
    Response Should Contain All Property Values Are Boolean    sort.unsorted
    Response Should Contain Property With Value    numberOfElements    ${0}
    Response Should Contain Property With Value    size    ${20}
    Response Should Contain Property With Value    number    ${0}

TC_O2O_13399
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid amount
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    amount=10000
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13400
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid currency
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    currency=baht
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    currency
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13401
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid currency (lower case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    currency=thb
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    currency
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13402
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid currency (upper case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    currency=THB
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId


TC_O2O_13403
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid channel
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    channel=abc
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    channel
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13404
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid channel (lower case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    channel=edc
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    channel
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13405
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid channel (upper case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    channel=EDC
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13406
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid action
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    action=void
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    action
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13407
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid action (lower case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    action=charge
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    action
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13408
    [Documentation]    [payment][Search Transaction] Verify response when query status with valid action (upper case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    action=CHARGE
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13409
    [Documentation]    [payment][Search Transaction] Verify response when query status with invalid paymentMethod
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    paymentMethod=test
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    paymentMethod
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13410
    [Documentation]    [payment][Search Transaction]Verify response when query status with valid paymentMethod  (lower case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    paymentMethod=wallet
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    paymentMethod
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13411
    [Documentation]    [payment][Search Transaction]Verify response when query status with valid paymentMethod (upper case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    paymentMethod=WALLET
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId

TC_O2O_13412
    [Documentation]    [payment][Search Transaction]Verify response when query status with invalid status
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    status=test
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    status
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13413
    [Documentation]    [payment][Search Transaction]Verify response when query status with valid status  (lower case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    status=success
    Response Correct Code    ${BAD_REQUEST_CODE}
    Response Should Contain Property With Value    type    http://www.jhipster.tech/problem/constraint-violation
    Response Should Contain Property With Value    title    Constraint Violation
    Response Should Contain Property With Value    status    ${${BAD_REQUEST_CODE}}
    Response Should Contain Property With Value    message    error.validation
    Response Should Contain Property With Value    path    /api/transactions
    Response Should Contain Property With Value    violations..field    status
    Response Should Contain Property With Value    violations..message    Failed to convert property value

TC_O2O_13414
    [Documentation]    [payment][Search Transaction]Verify response when query status with valid status (upper case)
    [Tags]    Medium    Regression    Smoke    payment
    Get Search Transaction    status=SUCCESS
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain All Property Values Are String    content..action
    Response Should Contain All Property Values Are String    content..amount
    Response Should Contain All Property Values Are String    content..channel
    Response Should Contain All Property Values Match Regex    content..createdDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..currency
    Response Should Contain All Property Values Match Regex    content..lastModifiedDate    ${date_regex}
    Response Should Contain All Property Values Are String    content..merchantId
    Response Should Contain All Property Values Are String    content..mobile
    Response Should Contain All Property Values Are String Or Null    content..name
    Response Should Contain All Property Values Are String    content..outletId
    Response Should Contain All Property Values Are String Or Null    content..paymentId
    Response Should Contain All Property Values Are String    content..paymentMethod
    Response Should Contain All Property Values Are String    content..status
    Response Should Contain All Property Values Are String    content..terminalId
    Response Should Contain All Property Values Are String    content..txRefId
