*** Variables ***
${txt_search_tickers}    //android.widget.EditText[@text='Search']
${ddl_filter_tickers}    //android.widget.TextView[@text='Any']/..
${btn_collapse_tickers}    //android.widget.TextView[@text='TICKERS']
${tab_starred_tickers}    //android.widget.TextView[@text='Starred']
${tab_all_tickers}    //android.widget.TextView[@text='All']
${lbl_no_tickers_found}    //android.widget.TextView[@text='No tickers found']
${tbl_name_column}    (//android.widget.ScrollView)[2]//android.widget.TextView[1]
# DYNAMIC
${lbl_tickers_table_column_by_name}    //android.widget.TextView[@text='_DYNAMIC_0']