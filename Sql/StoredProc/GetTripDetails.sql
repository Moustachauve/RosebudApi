DROP PROCEDURE IF EXISTS `rosebud_data`.`GetTripDetails`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetTripDetails`
(
	IN pFeedId INT,
	IN pTripId varchar(30))
BEGIN

	DECLARE schemaName VARCHAR(20) DEFAULT `rosebud_data`.`GetSchemaFromFeedId`(pFeedId);
    
	CALL ExecuteQuery(CONCAT('SELECT * ',
		'FROM `', schemaName, '`.`stops` ',
		'JOIN `stop_times` ON `stop_times`.`stop_id` = `stops`.`stop_id` ',
		'WHERE `stop_times`.`trip_id` = \'', pTripId, '\' ',
		'GROUP BY `stops`.`stop_id` ',
		'ORDER BY `stop_sequence`'));
    
    
END$$

DELIMITER ;
