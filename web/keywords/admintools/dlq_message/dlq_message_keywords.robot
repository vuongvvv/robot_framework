*** Settings ***
Resource    ../../../resources/locators/admintools/dlq_messages/dlq_messages_merchant_subscriber_locators.robot

*** Keywords ***
Verify Correction DLQ Topic On Merchant Subscriber Page
    [Arguments]    ${expected_topic}
    Wait Until Page Does Not Contain  ${hidden_side_bar}
    Wait Until Element Is Visible    ${dlqTopicName}
    ${number_of_topic}=     Execute Javascript    return document.getElementById("criteria").options.length
    FOR    ${index}    IN RANGE     ${number_of_topic}
    #    Add environment into topic name as a prefix by change wording to be stg if ${ENV} = staging
        ${expected_topic_name}    Run keyword if     '${ENV}'=='staging'    Set Variable    stg${expected_topic[${index}]}
         ...    ELSE    Set Variable    ${ENV}${expected_topic[${index}]}
        ${topic_name}=    Execute Javascript    return document.getElementById("criteria").options[${index}].text
        Should Be Equal As Strings    ${topic_name}    ${expected_topic_name}
    END