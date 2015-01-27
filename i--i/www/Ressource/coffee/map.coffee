map = L.map('map')

# --- choose the tiles server to use with the map
L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
	maxZoom: 22,
	attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
	'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
	'Imagery © <a href="http://mapbox.com">Mapbox</a>',
	id: 'examples.map-i875mjb7'
}).addTo(map)

# --- called after the geolocalisation was possible
# --- set the view and place the user marker on the map
showMap = (userPos)->	
	map.setView userPos, 19
	
	userMarker = L.marker userPos
	.addTo(map)
	.bindPopup "Vous êtes par là... à peu près"
	.openPopup()

# --- call the geolocalisation system and call "showMap" with a LatLng object
navigator.geolocation.getCurrentPosition (pos) ->
	showMap new L.LatLng pos.coords.latitude, pos.coords.longitude