*** Settings ***
Library    Collections
Library    String
Library    JSONLibrary    
Resource    validation_common.robot

*** Keywords ***
Get Property Value From Json By Index
    [Arguments]    ${property}    ${index}=0    ${input_json}=${RESP.json()}
    @{property_values}=    Get Value From Json    ${input_json}    $.${property}
    [Return]    ${property_values}[${index}]

Is Property With Value Exist In Json
    [Arguments]    ${property}    ${value}    ${input_json}=${RESP.json()}
    @{property_values}=    Get Value From Json    ${input_json}    $.${property}
    ${return_value}=    Run Keyword And Return Status    List Should Contain Value    ${property_values}    ${value}
    [Return]    ${return_value}

Get Property Value By Another Property Value
    [Arguments]    ${property}    ${value}    ${return_property}    ${input_json}=${RESP.json()}
    @{property_values}=    Get Value From Json    ${input_json}    $.${property}
    ${matched_value_index}=    Get Index From List    ${property_values}    ${value}
    @{return_property_values}=    Get Value From Json    ${input_json}    $.${return_property}
    ${return_value}=    Run Keyword If    '${matched_value_index}'!='-1'    Set Variable    ${return_property_values}[${matched_value_index}]
    [Return]    ${return_value}

Generate Json From Json Property Value
    [Arguments]    ${property}    ${generated_key}    ${input_json}=${RESP.json()}
    ${returnValue}=    Set Variable    {
    @{property_values}=    Get Value From Json    ${input_json}    $.${property}
    FOR    ${value}    IN    @{property_values}
        ${returnValue}=    Catenate    SEPARATOR=,{    ${returnValue}    "${generated_key}":${value}}
    END
    ${returnValue}=    Replace String    ${returnValue}    {,{    {
    [Return]    ${returnValue}

Update Json With Value
     [Arguments]    ${json_data}    ${update_property}    ${new_value}
     ${update_value}=    Get Property Value From Json By Index    .${update_property}    0    ${json_data}
     ${is_string}=    BuiltIn.Run Keyword And Return Status    String.Should Be String    ${update_value}
     ${string_to_replace}=    BuiltIn.Run Keyword If    ${is_string}==${False}    BuiltIn.Set Variable    "${update_property}":${SPACE}${update_value}
         ...    ELSE    BuiltIn.Set Variable    "${update_property}":${SPACE}"${update_value}"
     ${new_string}=    JSONLibrary.Convert JSON To String    ${json_data}
     ${final_string}=    String.Replace String    ${new_string}    ${string_to_replace}    "${update_property}":${SPACE}${new_value}
     ${final_json}=    JSONLibrary.Convert String to JSON    ${final_string}
     [Return]    ${final_json}

Update Json By Another Property
    [Arguments]    ${parent_property}    ${source_property}    ${source_value}    ${update_property}    ${new_value}    ${input_json}=${RESP.json()}
    # get Json to be replaced
    ${json_temp}    Get Property Value From Json By Index    ${parent_property}    0    ${input_json}
    Convert To List    ${json_temp}
    
    # find index of property & value in the replaced json
    @{property_values}    Get Value From Json    ${input_json}    $.${source_property}
    ${matched_value_index}    Get Index From List    ${property_values}    ${source_value}
    
    # update json with new property and value
    ${dict_child}    Set Variable    ${json_temp}[${matched_value_index}]
    ${string_child}    Convert To String    ${dict_child}
    Set To Dictionary    ${dict_child}    ${update_property}=${new_value}
    ${string_new_child}    Convert To String    ${dict_child}
    ${string_original}    Convert JSON To String    ${input_json}
    Replace String    ${string_original}    ${string_child}    ${string_new_child}        
    ${return_json}    Convert String to JSON    ${string_original}
    [Return]    ${return_json}
 
Check String Is Json
    [Arguments]    ${input_string}
    ${string_convert}=    BuiltIn.Convert To String    ${input_string}
    ${converted_string}=    String.Replace String    ${string_convert}    '    "
    #Work around: Remove "u" from string, incase the input string is in Unicode format. This work around only needs in Python2.
    ${converted_string}=    String.Replace String    ${converted_string}    u    ${EMPTY}
    ${is_json}=    BuiltIn.Run Keyword And Return Status    JSONLibrary.Convert String to JSON    ${converted_string}
    BuiltIn.Should Be True    ${is_json}

Check String Is Json Or Null
    [Arguments]    ${input_string}
    ${is_json}=    Run Keyword And Return Status    Check String Is Json    ${input_string}
    Run Keyword If    ${is_json}
    ...    BuiltIn.Should Be True    ${is_json}
    ...    ELSE
    ...    validation_common.Should Be Null    ${input_string}

Get All Property Value
    [Arguments]    ${property}    ${input_json}=${RESP.json()}
    @{property_values}=    Get Value From Json    ${input_json}    $.${property}
    [Return]    @{property_values}

Get List From Json List
    [Arguments]    ${property}    ${finding_index}    ${value}    ${input_json}=${RESP.json()}
    ${return_value}=    set variable    ${empty}
	${json_object}=    JSONLibrary.Convert String to JSON    ${input_json}
	FOR  ${item}    IN    @{json_object['${property}']}
	    ${return_value}=    set variable if      ${item[${finding_index}]}==${value}    ${item}
        BuiltIn.Exit For Loop If    ${item[${finding_index}]}==${value}
    END
	[Return]    ${return_value}  	
