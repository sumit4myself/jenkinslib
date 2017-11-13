DROP PROCEDURE IF EXISTS avs_be.migrateKeys;

DELIMITER $$
CREATE PROCEDURE avs_be.migrateKeys(IN sz INT)
BEGIN
    DECLARE v_row_count, v_current_row, v_user_id, v_purchase_pin_ad_id, v_pc_pin_ad_id INT;
    DECLARE v_purchase_pin_encryption, v_pc_pin_encryption VARCHAR(30);
    DECLARE v_purchase_pin, v_pc_pin, v_salt_key VARCHAR(512);

    SET autocommit = 0;
    
    SELECT COUNT(1) INTO v_row_count FROM avs_be.account_user;
    SET v_current_row = 0;
    
    SELECT attribute_detail_id INTO v_purchase_pin_ad_id FROM avs_be.attribute_detail WHERE attribute_detail_name = 'PURCHASE_PIN';
    SELECT attribute_detail_id INTO v_pc_pin_ad_id FROM avs_be.attribute_detail WHERE attribute_detail_name = 'PARENTAL_CONTROL_PIN';
    
    SELECT param_value INTO v_salt_key FROM avs_be.sys_parameters WHERE param_name = 'ENCRYPTION_SALT_KEY';
    
    WHILE (v_current_row < v_row_count) DO
        SELECT user_id INTO v_user_id FROM avs_be.account_user LIMIT v_current_row, 1;
        
        SELECT encryption_algorithm, attribute_value INTO v_purchase_pin_encryption, v_purchase_pin FROM avs_be.account_attribute WHERE user_id = v_user_id AND attribute_detail_id = v_purchase_pin_ad_id;
        SELECT encryption_algorithm, attribute_value INTO v_pc_pin_encryption, v_pc_pin FROM avs_be.account_attribute WHERE user_id = v_user_id AND attribute_detail_id = v_pc_pin_ad_id;
        
        UPDATE avs_be.account_user
        SET
            purchase_pin_salt_key = v_salt_key,
            purchase_pin_encryption = v_purchase_pin_encryption,
            purchase_pin = v_purchase_pin,
            pc_pin_salt_key = v_salt_key,
            pc_pin_encryption = v_pc_pin_encryption,
            pc_pin = v_pc_pin
        WHERE user_id = v_user_id;

        IF (v_current_row + 1) % sz = 0 THEN
            COMMIT;
        END IF;
        
        SET v_current_row = v_current_row + 1;
    END WHILE;

    COMMIT;

    SET autocommit = 1;
END
$$
DELIMITER ;

CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "purchase_pin_salt_key", "VARCHAR(512)");
CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "purchase_pin_encryption", "VARCHAR(30)");
CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "purchase_pin", "VARCHAR(512)");
CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "pc_pin_salt_key", "VARCHAR(512)");
CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "pc_pin_encryption", "VARCHAR(30)");
CALL avs_be.ADD_COLUMN_TO_TABLE("avs_be", "account_user", "pc_pin", "VARCHAR(512)");

CALL avs_be.migrateKeys(1000);

DROP PROCEDURE IF EXISTS avs_be.migrateKeys;