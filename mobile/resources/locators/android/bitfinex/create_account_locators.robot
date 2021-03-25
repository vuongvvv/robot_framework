*** Variables ***
${txt_username}    //android.widget.EditText[@text='Username']
${txt_email}    //android.widget.EditText[@text='Email']
${txt_password}    //android.widget.EditText[@text='Password']
${txt_confirm_password}    //android.widget.EditText[@text='Confirm Password']
${chk_confirmation}    //android.widget.TextView[@text='I can confirm that I have specified a strong and unique password not used for anything other than for my Bitfinex account.']//preceding-sibling::android.view.ViewGroup
${ddl_time_zone}    //android.widget.TextView[@text='']/..
${btn_sign_up}    //android.widget.TextView[@text='Sign Up']
${btn_log_in}    //android.widget.TextView[@text='Log In']
${btn_close_create_account_screen}    //android.widget.TextView[@text='']

# DYNAMIC
