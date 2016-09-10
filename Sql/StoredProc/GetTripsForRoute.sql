DROP PROCEDURE IF EXISTS `rosebud_data`.`GetTripsForRoute`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetTripsForRoute`
(
	IN pFeedId INT,
	IN pRouteId varchar(30),
    IN pDayDate char(8)
)
BEGIN
	
	DECLARE schemaName VARCHAR(20) DEFAULT `rosebud_data`.`GetSchemaFromFeedId`(pFeedId);
	DECLARE serviceId VARCHAR(100);
    DECLARE dateDayOfWeek INT;
    
    SET dateDayOfWeek = (SELECT DAYOFWEEK(pDayDate));
    CALL `rosebud_data`.`GetServiceId`(pFeedId, dateDayOfWeek, pDayDate, serviceId);
                
	CALL ExecuteQuery(CONCAT('SELECT `trips`.`trip_id`, ',
									'`trip_headsign`, ',
									'`trip_short_name`, ',
									'`direction_id`, ',
									'`block_id`, ',
									'`shape_id`, ',
									'`wheelchair_accessible`, ',
									'`bikes_allowed`, ',
									'`headway_secs`, ',
									'`note_fr`, ',
									'`note_en`, ',
                                    'CASE WHEN `headway_secs` IS NOT NULL THEN `frequencies`.`start_time`',
                                    'ELSE (',
										'SELECT `departure_time` ',
										'FROM `',schemaName,'`.`stop_times` ',
										'WHERE `stop_times`.`trip_id` = `trips`.`trip_id` ',
										'ORDER BY `stop_sequence` ASC ',
										'LIMIT 1 ',
									') END AS start_time, ',
                                    'CASE WHEN `headway_secs` IS NOT NULL THEN `frequencies`.`end_time`',
									'ELSE ( ',
										'SELECT `departure_time` ',
										'FROM `',schemaName,'`.`stop_times` ',
										'WHERE `stop_times`.`trip_id` = `trips`.`trip_id` ',
										'ORDER BY `stop_sequence` DESC ',
										'LIMIT 1 ',
									') END AS end_time ',
		'FROM `',schemaName,'`.`trips` ',
        'LEFT JOIN `',schemaName,'`.`calendar_dates` ON `calendar_dates`.`service_id` = `trips`.`service_id` AND `calendar_dates`.`date` = \'',pDayDate,'\' ',
        'LEFT JOIN `',schemaName,'`.`frequencies` ON `frequencies`.`trip_id` = `trips`.`trip_id` ',
		'JOIN `',schemaName,'`.`routes` ON `routes`.`route_id` = `trips`.`route_id` ',
		'WHERE `routes`.`route_id` = \'',pRouteId,'\' ',
		'AND \'',@serviceId,'\' LIKE CONCAT(\'%[\', `trips`.`service_id`, \']%\') ',
        'AND COALESCE(`exception_type`, 1) = 1 '
		'ORDER BY `direction_id`, `start_time`'));

END$$

DELIMITER ;

/*
	CALL `rosebud_data`.`GetTripsForRoute`(4, '1', '20160620')

	CALL `rosebud_data`.`GetTripsForRoute`(1, '34', '20160623')

	CALL `rosebud_data`.`GetTripsForRoute`(6, '8401', '20160620')
*/