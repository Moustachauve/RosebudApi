DROP PROCEDURE IF EXISTS `rosebud_data`.`ExecuteQuery`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`ExecuteQuery`
(
	IN pSqlQuery TEXT
)
BEGIN
	SET @sqlQuery = pSqlQuery;
	PREPARE stmt FROM @sqlQuery;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;