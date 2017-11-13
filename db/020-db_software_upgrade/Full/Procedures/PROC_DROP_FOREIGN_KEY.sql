DROP PROCEDURE IF EXISTS `PROC_DROP_FOREIGN_KEY`;

DELIMITER $$
CREATE PROCEDURE `PROC_DROP_FOREIGN_KEY`(IN tableName VARCHAR(64), IN constraintName VARCHAR(64))
BEGIN
        IF EXISTS(
            SELECT * FROM information_schema.table_constraints
            WHERE 
                table_schema    =  DATABASE() AND
                table_name      = tableName collate utf8_general_ci AND
                constraint_name = constraintName collate utf8_general_ci AND
                constraint_type = 'FOREIGN KEY')
        THEN
            SET @query = CONCAT('ALTER TABLE ', tableName, ' DROP FOREIGN KEY ', constraintName,';');
            PREPARE stmt FROM @query; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        END IF; 
    END$$
DELIMITER ;