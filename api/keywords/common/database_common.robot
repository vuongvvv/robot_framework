*** Settings ***
Library    DatabaseLibrary

*** Variables ***
${o2oautomation_postgres_host}    o2o-ci-cd-postgres.c6ehhunbi0fx.ap-southeast-1.rds.amazonaws.com
${o2oautomation_postgres_name}    postgres
${o2oautomation_postgres_pass}    7tBKeHxo2YbB
${o2oautomation_postgres_port}    5432
${o2oautomation_postgres_user}    pool_qa

*** Keywords ***
Connect Postgres Database
    Connect To Database Using Custom Params    psycopg2    database='${o2oautomation_postgres_name}', user='${o2oautomation_postgres_user}', password='${o2oautomation_postgres_pass}', host='${o2oautomation_postgres_host}', port=${o2oautomation_postgres_port}

Query Database
    [Arguments]    ${select_statement}
    ${return_query_results} =    Query    ${select_statement}
    [Return]    ${return_query_results}

Execute Sql Command
    [Arguments]    ${sql_command}
    Execute Sql String    ${sql_command}

Disconnect Database
    Disconnect From Database
