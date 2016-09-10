DROP PROCEDURE IF EXISTS `rosebud_data`.`GetServiceId`;
DELIMITER $$

CREATE PROCEDURE `rosebud_data`.`GetServiceId`
(
	IN pFeedId INT,
	IN pDayOfWeek INT,
	IN pDayDate char(8),
	OUT pServiceIdOut VARCHAR(100)
)
BEGIN
	DECLARE schemaName VARCHAR(20) DEFAULT `rosebud_data`.`GetSchemaFromFeedId`(pFeedId);

	SET @serviceId = '';

	CALL ExecuteQuery(CONCAT(
		'SELECT GROUP_CONCAT(CONCAT(\'[\', `service_id`, \']\')) INTO @serviceId FROM ( ',
			'SELECT `service_id` ',
			'FROM `',schemaName,'`.`calendar_dates` ',
			'WHERE `date` = \'',pDayDate,'\' ',
				'AND `calendar_dates`.`exception_type` = 1 ',
			'UNION ',
			'SELECT `service_id` ',
			'FROM `',schemaName,'`.`calendar` ',
			'WHERE \'',pDayDate,'\' BETWEEN `start_date` AND `end_date` ',
			'AND CASE ',
				'WHEN ',pDayOfWeek,' = 1 AND sunday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 2 AND monday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 3 AND tuesday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 4 AND wednesday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 5 AND thursday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 6 AND friday = 1 THEN 1 ',
				'WHEN ',pDayOfWeek,' = 7 AND saturday = 1 THEN 1 ',
				'ELSE 0 ',
			'END = 1 ',
        ') AS `service`'));

    IF @serviceId IS NULL THEN
		SET pServiceIdOut = '';
	ELSE
		SET pServiceIdOut = @serviceId;
	END IF;
    
END$$

DELIMITER ;
