*** Settings ***
Documentation    https://rawgit.com/peterservice-rnd/robotframework-excellib/master/docs/ExcelLibrary.html
Library    ExcelLibrary    
Library    Collections    

*** Keywords ***
Open Excel File
    [Arguments]    ${file_path}    ${doc_id}
    Open Excel Document    ${file_path}    ${doc_id}
    
Read Excel Data By Row Num
    [Arguments]    ${sheet_name}    ${row_num}=1
    ${return_row_data}    Read Excel Row    row_num=${row_num}    sheet_name=${sheet_name}
    [Return]    ${return_row_data}

Read Excel Data By Column Num
    [Arguments]    ${sheet_name}    ${col_num}
    ${return_column_data}    Read Excel Column    col_num=${col_num+1}    sheet_name=${sheet_name}
    [Return]    ${return_column_data}
    
Read Excel Data By Column Name
    [Arguments]    ${sheet_name}    ${column_name}
    ${list_column_headers}    Read Excel Data By Row Num    ${sheet_name}
    ${column_number}    Get Index From List    ${list_column_headers}    ${column_name}
    ${column_values}    Read Excel Data By Column Num    ${sheet_name}    ${column_number}
    Remove Values From List    ${column_values}    ${None}    ${column_name}
    [Return]    ${column_values}

Write Data To Excel
    [Arguments]    ${column_name}    ${write_data}    ${sheet_name}    ${row_offset}=1
    ${list_column_headers}    Read Excel Data By Row Num    ${sheet_name}
    ${column_number}    Get Index From List    ${list_column_headers}    ${column_name}
    Write Excel Column    col_num=${column_number+1}    col_data=${write_data}    sheet_name=${sheet_name}    row_offset=${row_offset}

Append Data To Excel
    [Arguments]    ${column_name}    ${append_data}    ${sheet_name}
    ${list_column_headers}    Read Excel Data By Row Num    ${sheet_name}
    ${column_number}    Get Index From List    ${list_column_headers}    ${column_name}
    ${column_data}    Read Excel Data By Column Num    ${sheet_name}    ${column_number}
    Remove Values From List    ${column_data}    ${None}
    ${append_column_index}    Get Length    ${column_data}
    Write Data To Excel    ${column_name}    ${append_data}    ${sheet_name}    ${append_column_index}

Save Excel File
    [Arguments]    ${file_path}
    Save Excel Document    ${file_path}
        
Close All Excel Files
    Close All Excel Documents