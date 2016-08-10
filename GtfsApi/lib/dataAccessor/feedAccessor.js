var sqlHelper = require('../sqlHelper/sqlHelper.js')
var log = require('../log/log.js')


var exports = module.exports = {}

exports.getAllFeeds = function (callback) {
	sqlHelper.acquire(function (err, client) {
		if (err) return callback(err)
		
		client.query("CALL `rosebud_data`.`GetAllFeeds`", [], function (err, rows) {
			sqlHelper.release(client)
			
			if (err) return callback(err)
			
			callback(null, rows[0])
		})
	})
}

exports.getFeedDetails = function (feedId, callback) {
	sqlHelper.acquire(function (err, client) {
		if (err) return callback(err)

		client.query("CALL `rosebud_data`.`GetFeedDetails`(?)", [feedId], function (err, rows) {
			sqlHelper.release(client)
				
			if (err) return callback(err)
				
			callback(null, rows[0])
		})
	})
}