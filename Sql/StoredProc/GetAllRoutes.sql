DROP PROCEDURE IF EXISTS `rosebud_data`.`GetAllRoutes`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetAllRoutes`
(
	IN pFeedId INT
)
BEGIN

	DECLARE schemaName VARCHAR(20) DEFAULT `rosebud_data`.`GetSchemaFromFeedId`(pFeedId);

	SET @sqlQuery= CONCAT('
		SELECT
			`route_id`,
			REPLACE(REPLACE(`route_short_name`, \'\r\', \'\'), \'\n\', \'\') AS route_short_name,
			`route_long_name`,
			`route_desc`,
			`route_type`,
			`route_url`,
			`route_color`,
			`route_text_color`,
			', pFeedId,' AS `feed_id`
            
		FROM `', schemaName,'`.`routes` AS routes 
        ORDER BY `route_short_name` + 0');

    PREPARE stmt FROM @sqlQuery;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END$$

DELIMITER ;

