var express = require('express')
var morgan = require('morgan')
var serveIndex = require('serve-index')

var app = express()
app.use(morgan('short'));
// Serve URLs like /ftp/thing as public/ftp/thing
// The express.static serves the file contents
// The serveIndex is this module serving the directory
app.use('/', serveIndex('./public', { 'icons': true }), express.static('./public'))

// Listen
app.listen(8080)