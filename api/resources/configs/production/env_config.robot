*** Variables ***
${GATEWAY_SESSION}    GATEWAY_SESSION
${API_HOST}           https://gateway.weomni.com
${APIGEE_SESSION}       APIGEE_SESSION
${APIGEE_HOST}          https://api.weomni.com
# List of the response code
${SUCCESS_CODE}               200
${CREATED_CODE}               201
${BAD_REQUEST_CODE}           400
${INTERNAL_SERVER_CODE}       500
${NOT_FOUND_CODE}             404
${UNAUTHORIZED}               401
${FORBIDDEN_CODE}             403
${METHOD_NOT_ALLOWED}         405
${ACCEPTED_CODE}              202
${UNSUPPORTED_MEDIA_TYPE}     415
#Client_Id : robot_automation_client
${AUTHORIZATION_KEY}    Basic cm9ib3RfYXV0b21hdGlvbl9jbGllbnQ6cm9ib3RfYXV0b21hdGlvbl9jbGllbnQ=
${RPP_PAYMENT_AUTHORIZATION_KEY}    Basic cWFzYW5pdHlycHBhcGlnZWU6cWFzYW5pdHlycHBhcGlnZWU=
${RPP_HOST}    https://am-rpp.eggdigital.com
${RPP_SESSION}     RPP_SESSION
${RPP_GATEWAY_AUTHORIZATION_KEY}         cm9ib3RfYXV0b21hdGU6YXV0b21hdGVfUGFzc3dvcmQ=
${RPP_GATEWAY_HOST}    https://am-rpp.eggdigital.com
${RPP_GATEWAY_HOST_FOR_TEST_AUDIT_WEB}    https://am-rpp.eggdigital.com
${RPP_GATEWAY_SESSION}    RPP_GATEWAY_SESSION

#EGG DIGITAL
${EGG_DIGITAL_HOST}    https://smsweb.eggdigital.com/
${EGG_DIGITAL_SESSION}    EGG_DIGITAL_SESSION
${EGG_DIGITAL_PROJECT_ID}    180
