var express = require('express')
var stopAccessor = require('../lib/dataAccessor/stopAccessor.js')
var router = express.Router({mergeParams: true})

router.get('/', function (req, res, next) {
	stopAccessor.getStopsForTrip(req.params.feedId, req.params.tripId, function (err, data) {
		if (err) return next(err)
		
		res.json(data)
	})
})

router.get('/time', function (req, res, next) {
	stopAccessor.getStopTimes(req.params.feedId, req.params.routeId, req.params.tripId, req.query.date, function (err, data) {
		if (err) return next(err)
		
		res.json(data)
	})
})


module.exports = router