*** Variables ***
${BROWSER}        Chrome
${DELAY}          0.5
${ADMIN_TOOLS_URL}      https://alpha-backoffice.weomni-test.com/
${WE_PLATFROM_URL}    https://alpha-platform.weomni-test.com
${SERVICE_STASTUS_URL}   https://alpha-status.weomni-test.com
${RETAIL_ADMIN_PROTAL_URL}        https://retail-admin-portal.tmn-dev.com/login/
${CHRM_DEAL_MANAGEMENT_URL}            http://chrm-backoffice-dev.trueyou.co.th/
${IMPLICIT_WAIT}    3s
${VENDING_MACHINE_CMS_URL}  https://alpha-vending.weomni-test.com/vending_cms/login

#PAYMENT User Journey
#Note: The 'merchantAnalyticsAccessToken' value in ${mechant_dashboard_url} below can be got from following instruction
#1. Run rsa-encryption.jar with this example command: java -jar rsa-encryption.jar encrypt "{\"merchant_id\":\"0024934\",\"outlet_id\":\"0001\",\"created_date\":$current_unix_datetime}"
#2. You will got encrypt value, encode this value to URL encoded format in website https://www.urlencoder.org/
${MERCHANT_DASHBOARD_URL}    https://alpha-merchant-dashboard.weomni-test.com/#/?merchantAnalyticsAccessToken=Bzqq8sbbObLJuaaNuTBRUvRKh66NDbcXvoHH9gf9luQZApxeAZ3GQBG3DHByUHf2ZpMKNP9gsawH8ezkiJCncZbNM0XwxdAcqRRAx%2F2kIfwMfP8MtMDXb7L3hRdWYSnL%2BtPZaeSg6yjR%2BE%2F2Ruv5%2BA7dQXL5m%2FJXqcbI2Qs9Uac%3D&merchantId=0024934