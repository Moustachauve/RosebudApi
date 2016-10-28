DROP PROCEDURE IF EXISTS `rosebud_data`.`GetStopsForRoute`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetStopsForRoute`
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

	CALL ExecuteQuery(CONCAT('SELECT  `trip_headsign`,',
									 '`direction_id`,',
                                     '`stops`.`stop_id`,',
									 '`stop_sequence`,',
									 '`stop_code`,',
									 '`stop_name`,',
									 '`stop_desc`,',
									 '`stop_lat`,',
									 '`stop_lon`,',
									 '`stop_url`,',
									 '`location_type`,',
									 '`wheelchair_boarding`,',
									 '`stop_url` ',
							 'FROM `',schemaName,'`.`trips` ',
							 	'JOIN `',schemaName,'`.`stop_times` ON trips.trip_id = stop_times.trip_id AND route_id = \'', pRouteId,'\' ',
								'JOIN `',schemaName,'`.`stops` ON `stop_times`.stop_id = stops.stop_id ',
                                    'AND \'',serviceId,'\' LIKE CONCAT(\'%[\', `trips`.`service_id`, \']%\') ',
							 'GROUP BY stops.stop_id, stops.stop_name, direction_id ',
							 'ORDER BY direction_id, stop_sequence'));

END$$

DELIMITER ;

/*
	CALL `rosebud_data`.`GetStopsForRoute`(1, '30', '20160826')

	CALL `rosebud_data`.`GetStopsForRoute`(31, '1', '20160620')

	CALL `rosebud_data`.`GetStopsForRoute`(1, '40', '20160826')

	CALL `rosebud_data`.`GetStopsForRoute`(6, '8401', '20160620')
*/