DROP PROCEDURE IF EXISTS drop_column_if_exists;
DELIMITER $$
CREATE PROCEDURE drop_column_if_exists (IN schemaName VARCHAR(64), IN tableName VARCHAR(64), IN columnName VARCHAR(64))
BEGIN

	SET @query = CONCAT('SELECT count(*) into @inc FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = \'', schemaName, '\' AND TABLE_NAME = \'', tableName, '\' AND COLUMN_NAME = \'', columnName, '\' ;');
    PREPARE stmt FROM @query; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt;
	
	if (@inc > 0) then
		SET @alterTable = CONCAT('ALTER TABLE ', schemaName, '.', tableName, ' DROP column ', columnName, ' ;');
		PREPARE stmt FROM @alterTable; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt;
	end if;
 
END$$
DELIMITER ;
