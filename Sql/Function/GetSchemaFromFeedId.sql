DROP FUNCTION IF EXISTS `rosebud_data`.`GetSchemaFromFeedId`;
DELIMITER $$

CREATE FUNCTION `rosebud_data`.`GetSchemaFromFeedId`
(
	pFeedId INT
)
RETURNS VARCHAR(20)
BEGIN
	DECLARE return_value VARCHAR(20);

	SELECT 
		`database_name` INTO return_value
	FROM `rosebud_data`.`feed` 
	WHERE `feed_id` = pFeedId;

	RETURN return_value;
    
END$$

DELIMITER ;
