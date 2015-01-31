# --- prepare variables for showing the map

# - choose the tiles' server to use with the map
tiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
	maxZoom: 18,
	attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
	'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
	'Imagery © <a href="http://mapbox.com">Mapbox</a>',
	id: 'examples.map-i875mjb7'
})

# - create the map
map = L.map 'map',
		center: [46.818188, 8.227512]
		zoom: 8
		layers: [tiles]

# - create the events layer
eventLayer = L.markerClusterGroup
		spiderfyDistanceMultiplier: 2
.addTo(map)

# - icon for the user
userIcon = L.icon(
	iconUrl: fw.getRessource "userIMG"
	iconSize: [30, 30]
	iconAnchor: [15, 15]
	popupAnchor: [0, 0]
);

# --- events icon's template and function to build it
eventIcon = L.Icon.extend(
		options:
			iconSize: [46, 46]
			iconAnchor: [23, 23]
			popupAnchor: [0, 0]
	);

getIcon = (iconName) ->
	new eventIcon(
		iconUrl: fw.getRessource iconName + "IMG"
	)

# --- called after the geolocalisation was possible
# --- set the view and place the user marker on the map
showMap = (userPos)->	
	map.setView userPos, 10
	
	userMarker = L.marker userPos, {icon: userIcon}
	.addTo(map)
	.bindPopup "Vous êtes par là... à peu près"
	.openPopup()

# --- call the geolocalisation system and call "showMap" with a LatLng object
navigator.geolocation.getCurrentPosition (pos) ->
	showMap new L.LatLng pos.coords.latitude, pos.coords.longitude
	
# --- subscribes to the channel "filterEvents" and listen with the function filterEvents
filterEvents = (events) ->
	fw.requestServer(
		app: "map"
		controller: "filterEvents"
		callback: (results) ->
			for result in results
				do (result) ->
					lng = result.location.coordinates[0]
					lat = result.location.coordinates[1]
					pictureName = result.category + "_" + result.type
					
					text = ""
					
					for range, i in result.timetables
						do (range, i) ->
							for date, j in range.dates
								if j > 0
									text += ", "
								text += date
								
					text += "<br />" + "<a href='javascript:goToView' >" + result.titles[0].text + "</a>"
					
					L.marker [lat, lng], icon: getIcon pictureName
					.bindPopup text
					.addTo(eventLayer)
		)

fw.pubsub.subscribe "filterEvents", filterEvents, true


# - fires the event "filterEvents" and asks to filter events within a radius
fw.pubsub.publish "filterEvents", {}
