*** Variables ***
${btn_asoke_shop}    xpath=(//android.widget.Image[@text='อโศก'])[1]
${btn_order_now}    //android.widget.TextView[contains(@text,'สั่งเลย!')]
${lbl_test_shop}    xpath=//android.view.View[contains(@content-desc,'ทดสอบ_ร้านทีมมี่')]
${lbl_shop_title}    xpath=(//android.view.View[@text='ทดสอบ_ร้านทีมมี่'])[2]
${btn_add_to_cart}    xpath=//android.view.View[@text='เพิ่มใส่ตะกร้า']
${btn_to_payment}    xpath=//android.widget.Image[@text='checkout-img']
${lbl_calculation_fee}    xpath=//android.view.View[@text='ค่าจัดส่ง']
${btn_checkout}    xpath=//android.view.View[@text='ชำระเงิน']
${ico_progress}    id=th.co.truemoney.wallet.dev:id/progressBar
${btn_confirm_payment}    xpath=(//android.view.View[@text='ยืนยันการชำระเงิน'])[2]
${btn_pay}    xpath=//android.widget.Button[@content-desc="button_pay"]
#Dynamic
${btn_add_product}    xpath=(//android.view.View[@text='_DYNAMIC_0']//parent::android.view.View//following-sibling::android.view.View)[2]//android.widget.Image