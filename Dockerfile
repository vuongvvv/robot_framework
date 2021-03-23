FROM vuongvvv/robot-framework-real-browser:latest

MAINTAINER Vuong Van <vuong.van@ascendcorp.com>

COPY ./api ${ROBOT_TESTS_DIR}/api
COPY ./web ${ROBOT_TESTS_DIR}/web
COPY ./mobile ${ROBOT_TESTS_DIR}/mobile
COPY ./utility ${ROBOT_TESTS_DIR}/utility
COPY ./e2e-tests ${ROBOT_TESTS_DIR}/e2e-tests