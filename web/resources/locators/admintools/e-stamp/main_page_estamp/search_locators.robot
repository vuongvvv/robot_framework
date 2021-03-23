*** Variables ***
${textfield_campaign_status}    id=campaign_status
${textfield_store_name}         id=merchant-name
${textfield_create_date}        id=create_date_range
${textfield_start_date}         id=start_date_range
${textfield_end_date}           id=end_date_range
${calendar}                     xpath=//*[@class='bs-datepicker-container']
${calendar_start_date}          xpath=//bs-days-calendar-view[1]//*[@class='bs-datepicker-body']/table[contains(@class,'days weeks')]/tbody/tr[3]/td[4]
${calendar_end_date}            xpath=//bs-days-calendar-view[2]//*[@class='bs-datepicker-body']/table[contains(@class,'days weeks')]/tbody/tr[3]/td[4]
${button_search}                xpath=//button[contains(@jhitranslate, 'entity.action.search')]
${column_date}                  xpath=//table[contains(@class,'table table-striped')]/tbody/tr
