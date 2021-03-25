*** Variables ***
#O2O MERCHANT FOR PAYMENT BY CREDIT CARD AND GATEWAY IS SCB
${SCB_MERCHANT_ID}    1100011
${SCB_ACTIVE_OUTLET}    00110
${SCB_INACTIVE_OUTLET}    00111
${SCB_NO_STATUS_OUTLET}    00112
${SCB_OUTLET_MID_INVALID}    00113
${SCB_OUTLET_SCB_SECRET_INVALID}    00114
${SCB_OUTLET_MID_EMPTY}    00115
${SCB_OUTLET_SCB_SECRET_EMPTY}    00116
${SCB_OUTLET_ASC_RATE_EMPTY}    00117
${SCB_OUTLET_MERCHANT_RATE_EMPTY}    00118
${SCB_OUTLET_MERCHANT_NAME_EMPTY}    00119
${SCB_OUTLET_O2O_PUBLICKEY_INVALID}    00120
${SCB_OUTLET_O2O_CIPHER_INVALID}    00121
${SCB_OUTLET_MERCHANT_NAME_EXTRA_LONG}    00122
${SCB_OUTLET_MERCHANT_NAME_SPECIAL_CHAR}    00123

#O2O MERCHANT FOR PAYMENT BY CREDIT CARD AND GATEWAY IS 2C2P
${2C2P_MERCHANT_ID}    1100022
${2C2P_ACTIVE_OUTLET}    00210
${2C2P_INACTIVE_OUTLET}    00211
${2C2P_NO_STATUS_OUTLET}    00216
${2C2P_MERCHANT_SECRET_KEY_EMPTY}    00212
${2C2P_MERCHANT_SECRET_KEY_INVALID}    00213
${2C2P_MERCHANT_SECRET_MID_EMPTY}    00214
${2C2P_MERCHANT_SECRET_MID_INVALID}    00215
${2C2P_OUTLET_MERCHANT_NAME_EMPTY}    00219

#O2O MERCHANT FOR PAYMENT BY CREDIT CARD AND GATEWAY IS EMPTY
${NA_MERCHANT_ID}    1100033
${NA_ACTIVE_OUTLET}    00310

#O2O MERCHANT FOR PAYMENT BY CREDIT CARD AND GATEWAY IS SCB FOR Generate Data Keypair
${SCB_MERCHANT_ID_KEYPAIR}    1100111
${SCB_OUTLET_ID_KEYPAIR}    00110

#O2O MERCHANT FOR PAYMENT WITH ONE-TIME OTP
${WALLET_MERCHANT_ID}    1100001
${WALLET_ACTIVE_OUTLET}    00410
${WALLET_OUTLET_ONE_TIME_FLAG_EMPTY}    00420
${WALLET_OUTLET_ONE_TIME_FLAG_DISABLE}    00421
${WALLET_OUTLET_NO_TMN_CLIENT_USER}    00411
${WALLET_OUTLET_NO_TMN_SECRET_PASSWORD}    00412
${WALLET_OUTLET_NO_SHOP_ID}    00413
${WALLET_OUTLET_NO_SHOP_NAME}    00414
${WALLET_OUTLET_NO_TMN_MERCHANT_ID}    00415
${WALLET_OUTLET_INVALID_TMN_CLIENT}    00416
${WALLET_OUTLET_INVALID_TMN_SECRET_PASS}    00417
${WALLET_OUTLET_INVALID_SHOP_ID}    00418
${WALLET_OUTLET_INVALID_TMN_MERCHANT_ID}    00419

#OMISE CUSTOMER
${CUSTOMER_NOT_FOUND_WP_CARD_ID}    wpcard_2c5578aef4d14efbb35011692e7ec288