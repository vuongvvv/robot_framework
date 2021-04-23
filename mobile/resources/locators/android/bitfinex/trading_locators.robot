*** Variables ***
${txt_search_tickers}    xpath=//android.widget.EditText[@text='Search']
${btn_clear_search_tickers}    xpath=//android.widget.TextView[@text='']
${ddl_currency_filter}    xpath=//android.widget.TextView[@text='']/..
${btn_close_currency_dropdown}    xpath=//android.widget.TextView[@text='']
${ddl_filter_tickers}    xpath=//android.widget.TextView[@text='Any']/..
${btn_collapse_tickers}    xpath=//android.widget.TextView[@text='TICKERS']
${tab_starred_tickers}    xpath=//android.widget.TextView[@text='Starred']
${tab_all_tickers}    xpath=//android.widget.TextView[@text='All']
${lbl_no_tickers_found}    xpath=//android.widget.TextView[@text='No tickers found']
${tbl_name_column}    xpath=(//android.widget.ScrollView)[2]//android.widget.TextView[1]

# DYNAMIC
${lbl_tickers_table_column_by_name}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']
${drd_currency_item_by_name}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']
${tbl_cell_ticker_by_name}    xpath=(//android.widget.TextView[@text='_DYNAMIC_0'])[1]