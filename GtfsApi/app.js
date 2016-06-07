﻿var express = require('express')
var path = require('path')
var morgan = require('morgan')
var log = require('./lib/log/log.js')
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser')

var home = require('./routes/index')
var users = require('./routes/users')
var feeds = require('./routes/feeds')
var routes = require('./routes/routes')

var app = express()

app.use(morgan("combined", { "stream": log.stream }))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))

app.use('/', home)
app.use('/users', users)
app.use('/feeds', feeds)
app.use('/routes', routes)

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found')
    err.status = 404
    next(err)
})

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500)
        res.json({
            message: err.message,
            error: err
        })
    })
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
    res.status(err.status || 500)
    res.json({
        message: err.message,
        error: {}
    })
})


module.exports = app
