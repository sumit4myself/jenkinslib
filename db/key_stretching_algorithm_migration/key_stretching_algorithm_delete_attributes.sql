DROP PROCEDURE IF EXISTS avs_be.deleteAttributes;

DELIMITER $$
CREATE PROCEDURE avs_be.deleteAttributes()
BEGIN
    DECLARE v_purchase_pin_ad_id, v_pc_pin_ad_id INT;
    
    SELECT attribute_detail_id INTO v_purchase_pin_ad_id FROM avs_be.attribute_detail WHERE attribute_detail_name = 'PURCHASE_PIN';
    SELECT attribute_detail_id INTO v_pc_pin_ad_id FROM avs_be.attribute_detail WHERE attribute_detail_name = 'PARENTAL_CONTROL_PIN';

    DELETE FROM avs_be.account_attribute WHERE attribute_detail_id IN (v_purchase_pin_ad_id, v_pc_pin_ad_id);
END
$$
DELIMITER ;

CALL avs_be.deleteAttributes();

DROP PROCEDURE IF EXISTS avs_be.deleteAttributes;