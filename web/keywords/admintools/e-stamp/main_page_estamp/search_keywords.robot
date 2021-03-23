*** Settings ***
Resource    ../../../../resources/locators/admintools/e-stamp/main_page_estamp/search_locators.robot

*** Variables ***
${date_regex}           (^(((([1-9])|([0][1-9])|([1-2][0-9])|(30))\-([A,a][P,p][R,r]|[J,j][U,u][N,n]|[S,s][E,e][P,p]|[N,n][O,o][V,v]))|((([1-9])|([0][1-9])|([1-2][0-9])|([3][0-1]))\-([J,j][A,a][N,n]|[M,m][A,a][R,r]|[M,m][A,a][Y,y]|[J,j][U,u][L,l]|[A,a][U,u][G,g]|[O,o][C,c][T,t]|[D,d][E,e][C,c])))\-[0-9]{4}$)|(^(([1-9])|([0][1-9])|([1][0-9])|([2][0-8]))\-([F,f][E,e][B,b])\-[0-9]{2}(([02468][1235679])|([13579][01345789]))$)|(^(([1-9])|([0][1-9])|([1][0-9])|([2][0-9]))\-([F,f][E,e][B,b])\-[0-9]{2}(([02468][048])|([13579][26]))$)
${date_time_regex}      ^((31(?!([-])(Feb|Apr|June?|Sep|Nov)))|((30|29)(?!([-])Feb))|(29(?=([-])Feb([-])(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))))|(0?[1-9])|1\d|2[0-8])([-])(Jan|Feb|Ma(r|y)|Apr|Ju(l|n)|Aug|Oct|(Sep|Nov|Dec))([-])((1[6-9]|[2-9]\d)\d{2}\s(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?)$

*** Keywords ***
User Want To Filter Create Date
    Click Element            ${textfield_create_date}

User Want To Filter Start Date
    Click Element            ${textfield_start_date}

User Want To Filter End Date
    Click Element            ${textfield_end_date}

Calendar Should Be Displayed
    Wait Until Element Is Visible     ${calendar}     timeout=5s

Select The Start Date Range
    Click Element       ${calendar_start_date}

Select The End Date Range
    Click Element       ${calendar_end_date}

Date Selected Should Be Displayed
    [Arguments]     ${textfield_date}
    ${textfield_text_date}=      Get Value      ${textfield_date}
    Should Be Equal      ${textfield_text_date}      ${textfield_text_date}

Date Format Should Be Displayed Correctly With DD-MMM-YYYY
    [Arguments]     ${textfield_date}
    ${textfield_text_date}=      Get Value                 ${textfield_date}
    ${date_format}=              Set Variable              ${textfield_text_date}
    ${date_split}=               Split String              ${date_format}     ${SPACE}-${SPACE}
    @{date_list}=                Convert To List           ${date_split}
    FOR    ${value_date}    IN    @{date_list}
        Should Match Regexp    ${value_date}     ${date_regex}
        Set Variable           ${value_date}
    END

Click On Search Button
    Click Button        ${button_search}

Campaign List Should Contain Create Date And Time Matches Regex
    ${get_column_date}=     Get Element Count          ${column_date}
    ${text_date}=           Create List
    FOR    ${row_index}       IN RANGE        1      ${get_column_date} + 1
        ${text_date}=      Get Text               ${column_date}[${row_index}]/td[4]
    END

Campaign List Should Contain Start Date And Time Matches Regex
    ${get_column_date}=     Get Element Count          ${column_date}
    ${text_date}=           Create List
    FOR    ${row_index}       IN RANGE        1      ${get_column_date} + 1
        ${text_date}=      Get Text               ${column_date}[${row_index}]/td[5]
    END

Campaign List Should Contain End Date And Time Matches Regex
    ${get_column_date}=     Get Element Count          ${column_date}
    ${text_date}=           Create List
    FOR    ${row_index}       IN RANGE        1      ${get_column_date} + 1
        ${text_date}=      Get Text               ${column_date}[${row_index}]/td[6]
    END
