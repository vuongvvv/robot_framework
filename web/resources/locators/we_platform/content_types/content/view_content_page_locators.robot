*** Variables ***
${btn_view_back}     //button[@class="btn btn-info"]
#Dynamic locators
${img_attribute}    (//label[text()='${SPACE}_DYNAMIC_0${SPACE}']//following::input)[1]/..//img
${mdn_attribute}    //label[text()='${SPACE}_DYNAMIC_0${SPACE}']
${lbl_mardown_attribute}    (//label[text()='${SPACE}_DYNAMIC_0${SPACE}']/..//following::div)[1]