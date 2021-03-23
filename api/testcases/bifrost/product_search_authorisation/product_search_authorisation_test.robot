*** Settings ***
Documentation    [Product Search] Endpoint Authorization
...    https://truemoney.atlassian.net/browse/ASCO2O-20512

Resource    ../../../resources/init.robot
Resource    ../../../keywords/bifrost/routing_resource_keywords.robot

# scopes: products.r, products.w, products.d, psnl.products.r
Suite Setup    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform
Suite Teardown    Delete All Sessions

*** Variables ***
# project page: https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/1054539825/Project+page
${product_search_wemall_project_id_alpha}    5ed5fa524972aa0001153b4a
${product_search_wemall_project_id_staging}    5d1b198a8224fa0001d640ff
${invalid_wemall_project_id}    5d1b198a8224fa0001d640fd
${update_product_request_body}    { "add": { "doc": { "product_id" : "99999", "store_id" : "947123", "store_name_th" : "SAVE DRUG", "plaza_category_id" : 3575, "product_name_th" : "ENFANT ORGANIC PLUS BABY SOOTHING LOTION 25 ML ครีมบรรเทาอาการคัน ลดรอยดำ", "description_th" : "ENFANT ORGANIC PLUS BABY SOOTHING LOTION 25 ML ครีมบรรเทาอาการคัน ลดรอยดำ", "create_date" : "2019-07-11T10:32:39Z", "update_date" : "2019-12-26T10:53:26Z", "price" : "245.0000", "price_min" : "245.0000", "price_max" : "245.0000", "compare_at_price" : "0.0000", "compare_at_price_min" : "0.0000", "compare_at_price_max" : "0.0000", "weight" : "1.0000", "product_url" : "https://www.wemall.com/d/91573228", "image_id" : "537b700d44fc8c77b43a08c057689bdf", "image_name" : "enfantorganicplusbabysoothinglotion25ml", "image_file_name" : "537b700d44fc8c77b43a08c057689bdf.jpg", "image_url" : "https://wls-th-prod-store-upload.s3-ap-southeast-1.amazonaws.com/upload/gallery5/947121/f/bd/537b700d44fc8c77b43a08c057689bdf.jpg", "image_extension" : "jpeg", "store_url" : "https://www.wemall.com/savedrug", "inStock" : "1", "sku" : "110050060", "viewed" : 0, "discount" : 0, "discount_rate" : 0, "wetrust" : 0, "store_status" : 1, "product_status" : "1", "show" : 1, "index_date" : "2020-05-26T11:46:45Z", "useStock" : "1", "quantity" : 5, "id_sort" : 1, "update_score_date" : "2020-05-26T11:46:45Z", "price_text" : "245.0000 บาท", "pid_sort" : 1, "published_status" : "publish", "category_level_0_ID_th" : "3551", "category_level_0_ID_en" : "3551", "category_level_0_name_th" : "แม่และเด็ก", "category_level_1_ID_th" : "3572", "category_level_1_ID_en" : "3572", "category_level_1_name_th" : "อุปกรณ์อาบน้ำและการแต่งตัว", "category_level_2_ID_th" : "3575", "category_level_2_ID_en" : "3575", "category_level_2_name_th" : "ผลิตภัณฑ์บำรุงผิวและทาตัว", "normal_price" : "245.0000", "discount_price" : "245.0000", "company" : "wemall" } }, "commit": {} }
${create_product_request_body}    { "add": { "doc": { "product_id" : "99999", "store_id" : "947121", "store_name_th" : "SAVE DRUG", "plaza_category_id" : 3575, "product_name_th" : "ENFANT ORGANIC PLUS BABY SOOTHING LOTION 25 ML ครีมบรรเทาอาการคัน ลดรอยดำ", "description_th" : "ENFANT ORGANIC PLUS BABY SOOTHING LOTION 25 ML ครีมบรรเทาอาการคัน ลดรอยดำ", "create_date" : "2019-07-11T10:32:39Z", "update_date" : "2019-12-26T10:53:26Z", "price" : "245.0000", "price_min" : "245.0000", "price_max" : "245.0000", "compare_at_price" : "0.0000", "compare_at_price_min" : "0.0000", "compare_at_price_max" : "0.0000", "weight" : "1.0000", "product_url" : "https://www.wemall.com/d/91573228", "image_id" : "537b700d44fc8c77b43a08c057689bdf", "image_name" : "enfantorganicplusbabysoothinglotion25ml", "image_file_name" : "537b700d44fc8c77b43a08c057689bdf.jpg", "image_url" : "https://wls-th-prod-store-upload.s3-ap-southeast-1.amazonaws.com/upload/gallery5/947121/f/bd/537b700d44fc8c77b43a08c057689bdf.jpg", "image_extension" : "jpeg", "store_url" : "https://www.wemall.com/savedrug", "inStock" : "1", "sku" : "110050060", "viewed" : 0, "discount" : 0, "discount_rate" : 0, "wetrust" : 0, "store_status" : 1, "product_status" : "1", "show" : 1, "index_date" : "2020-05-26T11:46:45Z", "useStock" : "1", "quantity" : 5, "id_sort" : 1, "update_score_date" : "2020-05-26T11:46:45Z", "price_text" : "245.0000 บาท", "pid_sort" : 1, "published_status" : "publish", "category_level_0_ID_th" : "3551", "category_level_0_ID_en" : "3551", "category_level_0_name_th" : "แม่และเด็ก", "category_level_1_ID_th" : "3572", "category_level_1_ID_en" : "3572", "category_level_1_name_th" : "อุปกรณ์อาบน้ำและการแต่งตัว", "category_level_2_ID_th" : "3575", "category_level_2_ID_en" : "3575", "category_level_2_name_th" : "ผลิตภัณฑ์บำรุงผิวและทาตัว", "normal_price" : "245.0000", "discount_price" : "245.0000", "company" : "wemall" } }, "commit": {} }
${delete_product_request_body}    { "delete": { "query":"product_id:99999" } ,"commit": {} }
${product_search_user_id}    2006115

*** Test Cases ***
# TEST DATA: PRODUCT_SEARCH_AUTHORISATION_TEST_DATA
TC_O2O_22649
    [Documentation]     User can search for a product by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Get Product Search    ${product_search_wemall_project_id_${ENV}}    collection=wemall&q=gaming pc
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    endPoint    /search
    Response Property Should Be Equal As String    actualQuery    gaming pc
    Get Product Search    ${product_search_wemall_project_id_${ENV}}    collection=weshop&q=gaming pc
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Product Search    ${invalid_wemall_project_id}    collection=wemall&q=gaming pc
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_22650
    [Documentation]     User can create a product by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${create_product_request_body}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number Value    responseHeader.status    0
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    weshop    ${create_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Put Create Update Product    ${invalid_wemall_project_id}    wemall    ${create_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    
TC_O2O_22651
    [Documentation]     User can update a product by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${update_product_request_body}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number Value    responseHeader.status    0
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    weshop    ${update_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Put Create Update Product    ${invalid_wemall_project_id}    wemall    ${update_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_22652
    [Documentation]     User can delete a product by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Delete Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${delete_product_request_body}
    Response Correct Code    ${SUCCESS_CODE}
    Response Should Contain Property With Number Value    responseHeader.status    0
    Delete Product    ${product_search_wemall_project_id_${ENV}}    weshop    ${delete_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Delete Product    ${invalid_wemall_project_id}    wemall    ${delete_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_22653
    [Documentation]     User can get auto suggestion by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Get Auto Complete    ${product_search_wemall_project_id_${ENV}}    collection=wemall&q=gaming
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status    ok
    Get Auto Complete    ${product_search_wemall_project_id_${ENV}}    collection=weshop&q=gaming
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Auto Complete    ${invalid_wemall_project_id}    collection=wemall&q=gaming
    Response Correct Code    ${FORBIDDEN_CODE}
    
TC_O2O_22654
    [Documentation]     User can get product personalization by using BiFrost API
    [Tags]    Regression    Smoke     High    bifrost    wemall
    Get Product Personalize    ${product_search_wemall_project_id_${ENV}}    user_id=${product_search_user_id}&domain=wemall
    Response Correct Code    ${SUCCESS_CODE}
    Response Property Should Be Equal As String    status    ok
    Get Product Personalize    ${product_search_wemall_project_id_${ENV}}    user_id=${product_search_user_id}&domain=weshop
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Product Personalize    ${invalid_wemall_project_id}    user_id=${product_search_user_id}&domain=wemall
    Response Correct Code    ${FORBIDDEN_CODE}

TC_O2O_22655
    [Documentation]     Request with user without scope, that matched with BiFrost configuration returns 403
    [Tags]    Regression    Smoke     High    bifrost    wemall
    [Setup]    Generate Robot Automation Header    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER}    ${ROBOT_AUTOMATION_ROLE_ADMIN_AND_USER_PASSWORD}    gateway=we-platform    client_id_and_secret=robotautomationclientnoscope
    Get Product Search    ${product_search_wemall_project_id_${ENV}}    collection=wemall&q=gaming pc
    Response Correct Code    ${FORBIDDEN_CODE}
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${update_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Put Create Update Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${create_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Delete Product    ${product_search_wemall_project_id_${ENV}}    wemall    ${delete_product_request_body}
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Auto Complete    ${product_search_wemall_project_id_${ENV}}    collection=wemall&q=gaming
    Response Correct Code    ${FORBIDDEN_CODE}
    Get Product Personalize    ${product_search_wemall_project_id_${ENV}}    user_id=${product_search_user_id}&domain=wemall
    Response Correct Code    ${FORBIDDEN_CODE}