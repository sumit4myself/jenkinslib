update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.external.paymentgateway.PaypalGateway' where pgw_class = 'com.accenture.avs.rpgw_temp.external.paymentgateway.PaypalGateway';
update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.external.paymentgateway.InvoiceGateway' where pgw_class = 'com.accenture.avs.rpgw_temp.external.paymentgateway.InvoiceGateway';
update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.external.paymentgateway.InAppGateway' where pgw_class = 'com.accenture.avs.rpgw_temp.external.paymentgateway.InAppGateway';
update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.external.paymentgateway.CartasiGateway' where pgw_class = 'com.accenture.avs.rpgw_temp.external.paymentgateway.CartasiGateway';
update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.external.paymentgateway.BraintreeCreditCardGateway' where pgw_class = 'com.accenture.avs.rpgw_temp.external.paymentgateway.BraintreeCreditCardGateway';
update pgw_temp.payment_method set pgw_class = 'com.accenture.avs.be.pgw.framework.plugin.PaypalGateway' where pgw_class = 'com.accenture.avs.be.pgw_temp.framework.plugin.PaypalGateway';
UPDATE `rpgw`.`payment_method` SET `method` = 'BT_CC', `validator_class` = 'com.accenture.avs.rpgw.validator.BTCCRequestValidator' WHERE `id` = '6';
UPDATE `rpgw_temp`.`payment_method` SET `validator_class` = 'com.accenture.avs.rpgw.validator.BTCCRequestValidator' WHERE `id` = '6';
update rpgw_temp.payment_method set pgw_class = 'com.accenture.avs.rpgw.validator.BTCCRequestValidator' where pgw_class = 'com.accenture.avs.rpgw_temp.validator.BTCCRequestValidator';
	
	
	
SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF EXISTS avs_be.update_index_value;
DELIMITER $$
CREATE PROCEDURE avs_be.update_index_value (IN tableName VARCHAR(64), IN schemaTemp VARCHAR(64), IN sourceSchemaName VARCHAR(64), IN columnJoinName VARCHAR(64), IN columnName VARCHAR(64))
BEGIN
    SET @inc := 0;

	SET @query = CONCAT('UPDATE ', schemaTemp, '.',  tableName, ' JOIN ',  sourceSchemaName, '.',  tableName,' ON ', schemaTemp, '.',  tableName, '.', columnJoinName, '  = ',  sourceSchemaName, '.',  tableName, '.', columnJoinName, '  SET  ', schemaTemp, '.',  tableName, '.', columnName, '  = ',  sourceSchemaName, '.',  tableName, '.', columnName, ';');
	PREPARE stmt FROM @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt;
	
END$$
DELIMITER ;


call avs_be.update_index_value("sys_parameter_group", "avs_be_temp", "avs_be", "param_group", "param_group_id");
call avs_be.update_index_value("sys_parameters", "avs_be_temp", "avs_be", "param_name", "param_id");
call avs_be.update_index_value("sys_parameters", "rpgw_temp", "rpgw", "param_name", "param_id");
call avs_be.update_index_value("ref_device_channel", "csmdb_tenant_1_temp", "csmdb_tenant_1", "DEVICE_CHANNEL_NAME", "DEVICE_CHANNEL_ID");
DROP PROCEDURE IF EXISTS avs_be.update_index_value;

DROP PROCEDURE IF EXISTS avs_be.update_index_values;
DELIMITER $$
CREATE PROCEDURE avs_be.update_index_values (IN tableName VARCHAR(64), IN schemaTemp VARCHAR(64), IN sourceSchemaName VARCHAR(64), IN columnJoinName1 VARCHAR(64), IN columnJoinName2 VARCHAR(64), IN columnName VARCHAR(64))
BEGIN
    SET @inc := 0;

	SET @query = CONCAT('UPDATE ', schemaTemp, '.',  tableName, ' JOIN ',  sourceSchemaName, '.',  tableName,' ON ( ', schemaTemp, '.',  tableName, '.', columnJoinName1, '  = ',  sourceSchemaName, '.',  tableName, '.', columnJoinName1, ' and ',  schemaTemp, '.',  tableName, '.', columnJoinName2, '  = ',  sourceSchemaName, '.',  tableName, '.', columnJoinName2, ') SET  ', schemaTemp, '.',  tableName, '.', columnName, '  = ',  sourceSchemaName, '.',  tableName, '.', columnName, ';');
	PREPARE stmt FROM @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt;
	
END$$
DELIMITER ;
call avs_be.update_index_values("payment_method_migration_rule", "avs_be_temp", "avs_be", "payment_type_in_id", "payment_type_out_id", "pm_migration_rule_id");
DROP PROCEDURE IF EXISTS avs_be.update_index_values;

DROP PROCEDURE IF EXISTS avs_be.update_auto_increment;
DELIMITER $$
CREATE PROCEDURE avs_be.update_auto_increment (IN tableName VARCHAR(64), IN targetSchemaName VARCHAR(64), IN sourceSchemaName VARCHAR(64))
BEGIN
    SET @inc := 0;

	SET @query = CONCAT('SELECT `AUTO_INCREMENT` INTO @inc FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = \'', sourceSchemaName, '\' AND   TABLE_NAME   = \'', tableName, '\';');
	PREPARE stmt FROM @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    
    SET @up := CONCAT('ALTER TABLE ', targetSchemaName, '.',  tableName, ' AUTO_INCREMENT = ', @inc, ';');
    PREPARE stmt FROM @up;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

CALL  avs_be.update_auto_increment("payment_method_migration_rule", "avs_be_temp", "avs_be");
CALL  avs_be.update_auto_increment("sys_parameter_group", "avs_be_temp", "avs_be");
CALL  avs_be.update_auto_increment("sys_parameters", "avs_be_temp", "avs_be");
CALL  avs_be.update_auto_increment("ref_device_channel", "csmdb_tenant_1_temp", "csmdb_tenant_1");
CALL  avs_be.update_auto_increment("sys_parameters", "rpgw_temp", "rpgw");
DROP PROCEDURE IF EXISTS avs_be.update_auto_increment;

DROP PROCEDURE IF EXISTS avs_be.fix_unavailable_primary_keys;
DELIMITER $$
CREATE PROCEDURE avs_be.fix_unavailable_primary_keys ()
BEGIN
 DECLARE v_finished INTEGER DEFAULT 0;
 DECLARE v_table_schema varchar(256) DEFAULT "";
 DECLARE v_table_name varchar(256) DEFAULT "";
 DECLARE tables_with_no_primary_keys CURSOR FOR
 SELECT 
    tables.table_schema, tables.table_name
FROM
    information_schema.tables
        LEFT JOIN
    (SELECT 
        table_schema, table_name
    FROM
        information_schema.statistics
    GROUP BY table_schema , table_name , index_name
    HAVING SUM(CASE
        WHEN non_unique = 0 AND nullable != 'YES' THEN 1
        ELSE 0
    END) = COUNT(*)) puks ON tables.table_schema = puks.table_schema
        AND tables.table_name = puks.table_name
WHERE
    puks.table_name IS NULL
        AND tables.table_type = 'BASE TABLE'
	and tables.table_schema not in ('information_schema','mysql','performance_schema','test'); 
 
 -- declare NOT FOUND handler
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
 OPEN tables_with_no_primary_keys;
 
 fix_pk: LOOP
	FETCH tables_with_no_primary_keys INTO v_table_schema,v_table_name;
	IF v_finished = 1 THEN 
		LEAVE fix_pk;
	END IF;
 
	SET @up := CONCAT('ALTER TABLE ', v_table_schema, '.',  v_table_name, ' ADD COLUMN fake_pk_id INTEGER NOT NULL auto_increment PRIMARY KEY;');
    PREPARE stmt FROM @up;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	
 END LOOP fix_pk;
 
 CLOSE tables_with_no_primary_keys;
 
END$$
DELIMITER ;

call avs_be.fix_unavailable_primary_keys ();
DROP PROCEDURE IF EXISTS avs_be.fix_unavailable_primary_keys;

DROP PROCEDURE IF EXISTS avs_be.fix_dateTime;
DELIMITER $$
CREATE PROCEDURE avs_be.fix_dateTime ()
BEGIN
 DECLARE v_finished INTEGER DEFAULT 0;
 DECLARE v_table_schema varchar(256) DEFAULT "";
 DECLARE v_table_name varchar(256) DEFAULT "";
 DECLARE v_column_name varchar(256) DEFAULT "";
 
DECLARE tables_with_no_datatime CURSOR FOR
SELECT DISTINCT
    COLUMNS.table_schema, COLUMNS.table_name, COLUMNS.column_name
FROM
    information_schema.COLUMNS,
    information_schema.TABLES
WHERE
	COLUMNS.table_name=TABLES.table_name and 
    TABLES.table_type='BASE TABLE' and
	COLUMNS.column_name in ('creation_date', 'update_date', 'UPDATED_DATE', 'last_mod_date', 'created_date') and  
 	COLUMNS.table_schema not in ('information_schema','mysql','performance_schema','test')
	and COLUMNS.table_schema NOT LIKE '%_temp'
	order by COLUMNS.table_name;
 
 -- declare NOT FOUND handler
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
 
 OPEN tables_with_no_datatime;
  START TRANSACTION;
 fix_dt: LOOP
	FETCH tables_with_no_datatime INTO v_table_schema,v_table_name, v_column_name;
	IF v_finished = 1 THEN 
		LEAVE fix_dt;
	END IF;
	
    set @isToUpdate = 0;
    
	SET @query := CONCAT('SELECT count(', v_column_name, ') INTO @isToUpdate FROM ', v_table_schema, '.',  v_table_name, ' WHERE ', v_column_name, ' IS NOT NULL;');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
 
	if (@isToUpdate > 0) then 
		SET @up := CONCAT('UPDATE ', v_table_schema, '.',  v_table_name, ' SET ', v_column_name, '=''0000-00-00 00:00:00'';');
		PREPARE stmt FROM @up;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
        
        SET @up := CONCAT('UPDATE ', v_table_schema, '_temp.',  v_table_name, ' SET ', v_column_name, '=''0000-00-00 00:00:00'';');
		PREPARE stmt FROM @up;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	end if;
	
 END LOOP fix_dt;
 commit;
 CLOSE tables_with_no_datatime;
 
END$$
DELIMITER ;


call avs_be.fix_dateTime ();

DROP PROCEDURE IF EXISTS avs_be.fix_dateTime;


SET SQL_SAFE_UPDATES = 1;
commit;