DROP PROCEDURE IF EXISTS `rosebud_data`.`GetStopTimes`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetStopTimes`
(
	IN pFeedId INT,
	IN pRouteId varchar(30),
	IN pStopId varchar(30),
    IN pDirectionId char(1),
    IN pDayDate char(8)
)
BEGIN
	
	DECLARE schemaName VARCHAR(20) DEFAULT `rosebud_data`.`GetSchemaFromFeedId`(pFeedId);
    DECLARE serviceId VARCHAR(100);
    DECLARE dateDayOfWeek INT;
    
    SET dateDayOfWeek = (SELECT DAYOFWEEK(pDayDate));
    CALL `rosebud_data`.`GetServiceId`(pFeedId, dateDayOfWeek, pDayDate, serviceId);

	CALL ExecuteQuery(CONCAT('SELECT ',
                             '`trips`.`trip_id`, ',
                             '`arrival_time`, ',
                             '`departure_time`, ',
                             '`stop_headsign`, ',
                             '`pickup_type`, ',
                             '`drop_off_type`, ',
                             '`wheelchair_accessible`, ',
                             '`bikes_allowed` ', 
                             'FROM `',schemaName,'`.`trips` ',
                                'JOIN `',schemaName,'`.`stop_times` ON `trips`.`trip_id` = `stop_times`.`trip_id` ',
                             'WHERE ',
                             '`trips`.`route_id` = \'',pRouteId,'\' ',
                                'AND `stop_id` = \'',pStopId,'\' ',
                                'AND \'',serviceId,'\' LIKE CONCAT(\'%[\', `trips`.`service_id`, \']%\') ',
                                'AND (',
                                  '\'', pDirectionId, '\' = \'*\' ',
                                  'OR `direction_id` = \'', pDirectionId, '\' ',
                                ') ',
                             'GROUP BY `trips`.`trip_id` ',
                             'ORDER BY `departure_time` '));

END$$

DELIMITER ;

/*
	CALL `rosebud_data`.`GetStopTimes`(31, '470', '3601444', 0, '20161020')

	CALL `rosebud_data`.`GetStopTimes`(1, '40', 'SCS10D', 0,'20160826')
    
	CALL `rosebud_data`.`GetStopTimes`(1, '30', 'DEL9A', 1, '20160826')
    
	CALL `rosebud_data`.`GetStopTimes`(1, '34', 'SCS19C', 0, '20160826')
*/