*** Settings ***
Resource    ../resources/configs/${ENV}/env_config.robot
Resource    ../resources/configs/${ENV}/test_accounts.robot
Resource    ../resources/configs/${ENV}/test_data.robot
Resource    ../keywords/common/api_common.robot

*** Variables ***
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
${SERVICE_UNAVAILABLE}        503
${NO_CONTENT_CODE}    204