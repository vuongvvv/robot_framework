*** Settings ***
Library    String
Library    Collections

*** Variables ***
${sorting_rule}    ${SPACE}_0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz

*** Keywords ***
Ascending Sort From List Of Values
    [Arguments]    ${actual_list}
    ${ns}    Create Dictionary    alphabet=${sorting_rule}    input_list=${actual_list}
    ${SORT_LIST}=    Evaluate     sorted(input_list, key=lambda word: [alphabet.index(c) for c in word])     namespace=${ns}
    Set Suite Variable    ${SORT_LIST}
