DROP PROCEDURE IF EXISTS `PROC_DROP_INDEX_KEY`;

DELIMITER $$
CREATE PROCEDURE `PROC_DROP_INDEX_KEY`(IN tableName VARCHAR(64), IN indexName VARCHAR(64))
BEGIN
        IF EXISTS(
            SELECT * FROM information_schema.statistics
            WHERE 
                table_schema    =  DATABASE() AND
                table_name      = tableName collate utf8_general_ci AND
                index_name = indexName collate utf8_general_ci)
        THEN
            SET @query = CONCAT('drop index ', indexName, ' on ', tableName,';');
            PREPARE stmt FROM @query; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        END IF; 
    END$$
DELIMITER ;