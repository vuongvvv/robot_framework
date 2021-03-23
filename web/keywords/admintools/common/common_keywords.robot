*** Settings ***
Resource    ../../../resources/locators/admintools/common/common_locators.robot
Resource    ../../../../api/keywords/common/string_common.robot
Resource    ../../common/locator_common.robot
Resource    ../../../../api/keywords/common/list_common.robot

*** Keywords ***
Logout Admintools
    Click Visible Element    ${mnu_account}
    Click Visible Element    ${lnk_logout}

Navigate On Left Menu Bar
    [Arguments]    ${menu}    ${sub_menu}=${empty}
    Click Visible Element    ${hamberger_menu}
    ${menu_locator}=    Generate Element From Dynamic Locator    ${mnu_right_menu_bar}    ${menu}
    Click Visible Element    ${menu_locator}
    ${sub_menu_locator}=    Generate Element From Dynamic Locator    ${mnu_sub_menu}    ${menu}    ${sub_menu}
    Run Keyword If   '${sub_menu}'!='${empty}'  Click Visible Element    ${sub_menu_locator}

Navigate To Main Menu And Sub Main Menu
    [Arguments]    ${main_menu_name}    ${sub_menu_name}
    ${main_menu_locator}=    Generate Element From Dynamic Locator    ${lnk_main_menu}    ${main_menu_name}
    ${sub_menu_locator}=    Generate Element From Dynamic Locator    ${lnk_sub_menu}    ${sub_menu_name}
    Click Visible Element    ${main_menu_locator}
    Click Visible Element    ${sub_menu_locator}        

Sort By Column
    [Arguments]    ${column_name}    ${order}=desc
    ${column_header_element}    Generate Element From Dynamic Locator    ${lbl_column_header}    ${column_name}
    ${sort_icon_element}    Generate Element From Dynamic Locator    ${ico_column_header_sort}    ${column_name}
    FOR    ${index}    IN RANGE    0    2
        ${class_value_of_sort_icon}    Get Element Property    ${sort_icon_element}    class
        ${is_class_contain}    Is String Contain    ${class_value_of_sort_icon}    ${order}
        Exit For Loop If    ${is_class_contain}==${True}
        Click Visible Element    ${column_header_element}
    END

Verify Data On Column Is Sorting
    [Arguments]    ${column_name}    ${sort_order}=desc
    ${column_data}    Get Data By Column Name    ${column_name}
    Verify List Is Sorting    ${column_data}    ${sort_order}
    
Verify Data By Column
    [Arguments]    ${column_name}    @{expected_values}
    ${table_cells_text}    Get Data By Column Name    ${column_name}
    FOR    ${cell_text}    IN    @{table_cells_text}
        List Should Contain Value    ${expected_values}    ${cell_text}
    END
    
Get Data By Column Name
    [Arguments]    ${column_name}
    ${headers_name}    Get Elements Text    ${lbl_table_column_headers}
    ${column_order}    Get Index From List    ${headers_name}    ${column_name}
    ${table_column_header_cell_elements}    Generate Element From Dynamic Locator    ${cel_table}    ${column_order+1}
    ${return_table_cells_text_list}    Get Elements Text    ${table_column_header_cell_elements}
    [Return]    @{return_table_cells_text_list}

Verify Data Exist On Column Headers
    [Arguments]    ${column_headers}
    FOR    ${column_name}    IN    @{column_headers}
        ${column_data}    Get Data By Column Name    ${column_name}
        Verify List Is Not Empty    ${column_data}
    END
    
Verify Table Column Headers
    [Arguments]    ${column_headers}
    ${fetch_column_headers}=    Get Elements Text    ${lbl_table_column_headers}
    Lists Should Be Equal    ${column_headers}    ${fetch_column_headers}