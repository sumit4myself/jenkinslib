DROP PROCEDURE IF EXISTS `PROC_DROP_PRIMARY_KEY`;

DELIMITER $$
CREATE PROCEDURE `PROC_DROP_PRIMARY_KEY`(IN tableName VARCHAR(64))
BEGIN
        IF EXISTS(
            SELECT * FROM information_schema.table_constraints
            WHERE 
                table_schema    =  DATABASE() AND
                table_name      = tableName collate utf8_general_ci AND
                constraint_type = 'PRIMARY KEY')
        THEN
            SET @query = CONCAT('ALTER TABLE ', tableName, ' DROP PRIMARY KEY', ';');
            PREPARE stmt FROM @query; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        END IF; 
    END$$
DELIMITER ;