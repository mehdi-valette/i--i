angularApp.controller("mapController", [->
	# --- prepare variables for showing the map
	
	# - array of events
	events = []
	
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
		
	# --- open the "eventDetail" page
	goToDetail = (event) ->
		fw.goToPage "/eventDetail", event
	
	# --- requests events information and display them on the map
	filterEvents = (events) ->
		fw.requestServer(
			app: "map"
			controller: "filterEvents"
			callback: (results) ->
		
				# - put the results into the events array
				events = results
				
				# - loop through events and show them as markers
				for event, index in events
					do (event, index) ->
						# - prepare the latitude and longitude, as well as the picture's name
						lng = event.location.coordinates[0]
						lat = event.location.coordinates[1]
						pictureName = event.category + "_" + event.type
						
						# - prepare the text for the date
						textDate = ""
						for range, i in event.timetables
							do (range) ->
								if i > 0
									textDate += ", "
								for date, j in range.dates
									if j > 0
										textDate += ", "
									textDate += date
						
						# - creates the link in the popup allowing transition to detailEvent
						popupLink = document.createElement "a"
						popupLink.href = "#"
						popupLink.innerHTML = event.title
						popupLink.onclick = ->
							goToDetail event
						
						# - creates the pop up content, with date + link
						popupContent = document.createElement "span"
						popupContent.innerHTML = textDate + "<br />"
						popupContent.appendChild popupLink
						
						# - add the content into the popup
						L.marker [lat, lng], icon: getIcon pictureName
						.bindPopup popupContent
						.addTo(eventLayer)
			)
	
			
	# --- subscribes to the channel "filterEvents" and listen with the function filterEvents
	fw.pubsub.subscribe "filterEvents", filterEvents, true
	
	
	# - fires the event "filterEvents" and asks to filter events within a radius
	fw.pubsub.publish "filterEvents", {}

]) # end of mapController

fw.pubsub.publish "documentReady", "mapAPP"