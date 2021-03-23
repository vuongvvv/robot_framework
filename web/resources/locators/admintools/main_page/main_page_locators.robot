*** Variables ***
${signin_button}                                //button[.//text() = 'Sign in']
${login_button}                                 //button[.//text() = 'Log in']
${hidden_side_bar}                              //aside[@style ='transform: translateX(-100%);']
${estamp_menu}                                  //a[.//text() = 'Estamp' and contains(@class, 'nav-link')]
${estamp_campaign_menu}                         //ul[.//text() = 'Main Page' and contains(@class, 'show')]
${dlq_messages_menu}                            //a[.//text() = 'DLQ Messages' and contains(@class, 'nav-link')]
${dlq_messages_merchant_subscriber_menu}        //ul[.//text() = 'Merchant Subsciber' and contains(@class, 'show')]
${merchant_edit_my_sql_menu}                    id=rpp-merchant-menu
${merchant_edit_my_sql_merchant_menu}           //a[contains(@routerlink,"rpp-merchant/dashboard")]
${merchant_edit_my_sql_outlet_menu}             //a[contains(@routerlink,"rpp-merchant/outlet/dashboard")]
${txt_user_name}    //input[@id='username']
${txt_password}    //input[@id='password']

${lbl_admintools}    //h1[contains(text(),'Admintools')]