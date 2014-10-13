app = require("express")();
server = require("http").createServer app;

app.use (req, res) ->
	res.sendFile( __dirname + "/index.html" )

io = require("socket.io").listen(server);

io.sockets.on "connection", (socket) ->
	socket.emit "message", "Vous êtes connecté !"
	
	socket.on "message", (message) ->
		console.log "received a message"
		socket.broadcast.emit "message", message
	
	socket.on "new", (pseudo) ->
		socket.broadcast.emit "new", pseudo
		console.log pseudo + " just connected"

server.listen 8080;