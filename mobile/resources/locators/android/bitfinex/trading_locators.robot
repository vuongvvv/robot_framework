*** Variables ***
${txt_search_tickers}    accessibility_id=Tickers-Search-Input
${btn_clear_search_tickers}    accessibility_id=Tickers-Search-Clear-Button
${ddl_currency_filter}    accessibility_id=Tickers-Ccy-Picker
${btn_close_currency_dropdown}    xpath=//android.widget.TextView[@text='']
${ddl_filter_tickers}    xpath=//android.widget.TextView[@text='Any']/..
${btn_collapse_tickers}    accessibility_id=Tickers-Collapsible
${tab_starred_tickers}    accessibility_id=Tickers-Starred-Button
${tab_all_tickers}    accessibility_id=Tickers-All-Button
${lbl_no_tickers_found}    xpath=//android.widget.TextView[@text='No tickers found']
${tbl_name_column}    xpath=(//android.widget.ScrollView)[2]//android.widget.TextView[1]
${pnl_liquidations}    xpath=//android.widget.TextView[@text='LIQUIDATIONS']

# DYNAMIC
${lbl_tickers_table_column_by_name}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']
${drd_currency_item_by_name}    xpath=//android.widget.TextView[@text='_DYNAMIC_0']
${tbl_cell_ticker_by_name}    accessibility_id=tickers_table__DYNAMIC_0