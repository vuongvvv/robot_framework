*** Variables ***
${GATEWAY_SESSION}    GATEWAY_SESSION
${API_HOST}           https://alpha-gateway.weomni-test.com
${BITFINEX_SESSION}    BITFINEX_SESSION
${BITFINEX_HOST}           https://api-pub.bitfinex.com
${SDK_SESSION}    SDK_SESSION
${SDK_HOST}           https://sdk-auth.trueid-dev.net
${TRUE_YOU_SESSION}    TRUE_YOU_SESSION
${TRUE_YOU_HOST}           http://172.18.124.30:8080
${AUTHORIZATION_KEY}    Basic YXV0b21hdGVDbGllbnQ6SD4vSnhPM2lUbyZ2cEpebg==
#Client_Id : automateClient
${AUTHORIZATION_KEY}    Basic cm9ib3RfYXV0b21hdGlvbl9jbGllbnQ6cm9ib3RfYXV0b21hdGlvbl9jbGllbnQ=
#Client_Id : trueyouapp
${TRUEYOU_AUTHORIZATION_KEY}    Basic dHJ1ZXlvdWFwcDp8YXNkNis+Z29wRDZSUHpS
#Client_Id : edc
${EDC_AUTHORIZATION_KEY}    Basic ZWRjX2VzdGFtcDoyfFROTm92YCV2eC08WEps
#Client_Id : admintools
${ADMIN_TOOLS_AUTHORIZATION_KEY}    Basic YWRtaW50b29sczpkZWNiX0Utamh5YUw4WmVE
# APIGEE gateway is not available on Alpha and Dev environments
${APIGEE_SESSION}       APIGEE_SESSION
${APIGEE_HOST}          https://api.weomni-test.com
${WEOMNI_AUTHORIZATION_KEY}=    Basic QVZqdTdXVDVFTVZodmhvYVUwZ0ZuZ0JMTGlWTTU1YWw6TkIyYThwUlBja1B0MFBVTQ==
${RPP_HOST}                 https://am-rpp-alpha.eggdigital.com
${RPP_SESSION}     RPP_SESSION
${RPP_AUTHORIZATION_KEY}=    Basic dGVzdDoxMjM0NTY=
${RPP_PAYMENT_AUTHORIZATION_KEY}    Basic cnBwYXBpZ2VlOkY2bmF6RGhRY1llQm5r

#RPP Configuration
${RPP_GATEWAY_SESSION}        RPP_GATEWAY_SESSION
${RPP_GATEWAY_HOST}           https://alpha-rpp.weomni-test.com
${RPP_GATEWAY_HOST_FOR_TEST_AUDIT_WEB}    https://alpha-rpp.weomni-test.com
${RPP_GATEWAY_AUTHORIZATION_KEY}         cm9ib3RfYXV0b21hdGU6YXV0b21hdGVfUGFzc3dvcmQ=

## Project For CMS
${WESHOP_PROJECT_ID}    5d5298cd5f221a000146e634     #Using GET /api/projects in project-resource
${WEPAYMENT_PROJECT_ID}    5f4ccb110581b60001e588ca

#EGG DIGITAL
${EGG_DIGITAL_HOST}    https://ppro-smsweb.eggdigital.com/
${EGG_DIGITAL_SESSION}    EGG_DIGITAL_SESSION
${EGG_DIGITAL_PROJECT_ID}    199

#Permanent access token valid 1 year, Expired: 31 Mar 2021
${ADMIN_USER_ACCESS_TOKEN}    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiI2NjYzOTE0ODM0OCIsInNjb3BlIjpbInNtcy5yZWFkIiwic2lnbmluLmxpbmUiLCJwdXNoLW5vdGlmaWNhdGlvbi5jb25maWd1cmF0aW9uLndyaXRlIiwid2VzaG9wLm9yZGVyLmNvbmZpcm0iLCJtZXJjaGFudFR4LmNyZWF0ZSIsIndlc2hvcC5vcmRlci4qIiwiY2FtcGFpZ24udXNhZ2UuY3JlYXRlIiwiYmF0Y2hfcHJvY2Vzc29yIiwibm90aWZpY2F0aW9uLnB1c2guY3JlYXRlIiwicHVzaC1ub3RpZmljYXRpb24uY29uZmlndXJhdGlvbi5yZWFkIiwibWVyY2hhbnQubWVyY2hhbnQuYXV0b2JpbmQiLCJjYW1wYWlnbi5wcm9tb3Rpb24uY3JlYXRlIiwiYnJhbmQud3JpdGUiLCJjYW1wYWlnbi5wcm9tb3Rpb24udXBkYXRlIiwidWFhLmNsaWVudC1jb25maWcud3JpdGUiLCJzaWduaW4uc21zLW90cCIsImFjY291bnQudXBkYXRlIiwibm90aWZpY2F0aW9uLnB1c2gucmVnaXN0ZXIiLCJ1YWEuY29uZmlnLndyaXRlIiwic21zLmNyZWF0ZSIsIkRFRkFVTFQiXSwiZXhwIjoxNjI5MzYxMjEwLCJpYXQiOjE1OTc4MjUyMTAsImF1dGhvcml0aWVzIjpbIm1lcmNoYW50U3Vic2NyaWJlci5tc2cuZGxxLWwiLCJtYXBwaW5nLm1hcHBpbmcuYWN0QXNBZG1pbiIsIm1lcmNoYW50LnRlcm1pbmFsLmFjdEFzQWRtaW4iLCJtYXBwaW5nLmVudGl0eUF1ZGl0LmFjdEFzQWRtaW4iLCJtZXJjaGFudFN1YnNjcmliZXIubXNnLmFjdEFzQWRtaW4iLCJtZXJjaGFudC5lbnRpdHlBdWRpdC5hY3RBc0FkbWluIiwibWVyY2hhbnQub3V0bGV0LmFjdEFzQWRtaW4iLCJtZXJjaGFudC5tZXJjaGFudC5hY3RBc0FkbWluIiwibWVyY2hhbnRQdWJsaXNoZXIubXNnLmRscS1sIiwidWFhLmNsaWVudC5saXN0IiwiUk9MRV9BRE1JTiIsInBvaW50LmVudGl0eUF1ZGl0LmFjdEFzQWRtaW4iLCJtZXJjaGFudC50ZXJtaW5hbC5yZWFkIiwibWVyY2hhbnRQdWJsaXNoZXIubXNnLmFjdEFzQWRtaW4iXSwianRpIjoiM2QzMDcwMWItZjM5MS00MDkzLTliNzMtZjlhZmZmMDhkMjE4IiwiY2xpZW50X2lkIjoicm9ib3RhdXRvbWF0aW9uY2xpZW50In0.fjDCtkGP5OJ4hfOxNHIPn1R4mnZD4OYs4fLtmTN52qNMmx09eivHQvkF-wO4nSBmgzWkjO09L6ItnkRlyHq6ZfCulOvCjTBItiAjbxnhl-SIeStcWPaaXNH9sMfLRGLHw-v4FTkOJP84uuLZlP4BV_lAxq2y44nfeFApkpq3t-fmHaqQu1Pz2QaGqlkUNcWSmoMR6AKHI1XqiNjpLvniTAG38rgYWkW1gwQC5ly_Logv5WupTU68V3nahG3PiRqJHxZPyW78n7eOf3ab7nYBmiAw0qON8o6DoE-Y52LKRO5Ow3z5bI5QQyxNMtxmO6pFepFh5NstCbgWenW1qThBag

#WE PLATFORM
${WE_PLATFORM_HOST}    https://alpha-platform.weomni-test.com
${WE_PLATFORM}    we-platform
