
class fw
	@baseUrl: "/"
		
	# --- associative array of ressource's name - ressource's directory
	ressources:
		# - images
		"userIMG": @baseUrl + "Ressource/img/user.png"
		"sport_sureIMG": @baseUrl + "Ressource/img/sport_sure.png"
		"sport_unsureIMG": @baseUrl + "Ressource/img/sport_unsure.png"
		"sport_amateurIMG": @baseUrl + "Ressource/img/sport_amateur.png"
		"concert_sureIMG": @baseUrl + "Ressource/img/concert_sure.png"
		"concert_unsureIMG": @baseUrl + "Ressource/img/concert_unsure.png"
		"concert_amateurIMG": @baseUrl + "Ressource/img/concert_amateur.png"
		"game_sureIMG": @baseUrl + "Ressource/img/game_sure.png"
		"game_unsureIMG": @baseUrl + "Ressource/img/game_unsure.png"
		"game_amateurIMG": @baseUrl + "Ressource/img/game_amateur.png"
		"spectacle_sureIMG": @baseUrl + "Ressource/img/spectacle_sure.png"
		"spectacle_unsureIMG": @baseUrl + "Ressource/img/spectacle_unsure.png"
		"spectacle_amateurIMG": @baseUrl + "Ressource/img/spectacle_amateur.png"
		"other_sureIMG": @baseUrl + "Ressource/img/other_sure.png"
		"other_unsureIMG": @baseUrl + "Ressource/img/other_unsure.png"
		"other_amateurIMG": @baseUrl + "Ressource/img/other_amateur.png"
		
		# - apps
		"mapAPP": @baseUrl + "App/Map/View/map.html"
		"eventDetailAPP": @baseUrl + "App/EventDetail/View/eventDetail.html"
		
		# - CSS
		"indexCSS": @baseUrl + "Ressource/css/index.css"
		"mapCSS": @baseUrl + "Ressource/css/map.css"
		"leafletCSS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css"
		"markerClusterCSS": @baseUrl + "Library/markerCluster.css"
		"ionicCSS": @baseUrl + "Library/ionic.css"
		
		# - JS
		"angularJS": @baseUrl + "Library/angular.js"
		"angularLeafletDirectiveJS": @baseUrl + "Library/angular-leaflet-directive.js"
		"angularUIAnimateJS": @baseUrl + "Library/angular-ui-animate.js"
		"angularRouteJS": @baseUrl + "Library/angular-route.js"
		"angularUIRouterJS": @baseUrl + "Library/angular-ui-router.js"
		"angularResourceJS": @baseUrl + "Library/angular-resource.js"
		"angularSanitizeJS": @baseUrl + "Library/angular-sanitize.js"
		"indexJS": @baseUrl + "Ressource/js/index.js"
		"ionicJS": @baseUrl + "Library/ionic.js"
		"ionicAngularJS": @baseUrl + "Library/ionic-angular.js"
		"leafletJS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"
		"mapJS": @baseUrl + "Ressource/js/map.js",
		"markerClusterJS": @baseUrl + "Library/markerCluster.js"

	# --- return a ressource's directory by its name
	getRessource: (ressourceName) =>
		@ressources[ressourceName]
		
	# --- loads dynamically css and js files (filenames) into the document (doc)
	getJsCss: (fileNames, doc) =>
		# --- initial index is -1, so it will be at 0 at the first call of index++
		index = -1
		
		# --- method called for each file
		callback = =>
			index++
			name = fileNames[index]

			# --- method called after a file loaded so we can load the next one (if there's one)
			again = =>
				if index < (fileNames.length - 1)
					callback()
			
			# --- create the appropriate tag at the appropriate place for each file type
			if name.slice(-3) is "CSS"
				file = doc.createElement "link"
				file.href = @getRessource name
				file.rel = "stylesheet"
				file.type = "text/css"
					
				doc.head.appendChild file
				again();
				
			else if name.slice(-2) is "JS"
				file = doc.createElement "script"
				file.src = @getRessource name
				file.type = "text/javascript"
					
				doc.body.appendChild file
					
				# --- call the "again" method when a file has been loaded
				if file.readyState #IE
					file.onreadystatechange = ->
			        	if file.readyState is "loaded" ||
			        	file.readyState is "complete"
			        		file.onreadystatechange = null
			        		again()
				else #others
			    	file.onload = ->
			        	again()
			
		callback()
	
	# --- make request to the server
	requestServer: (request) ->
		result = [
			{
			category: "sport"
			type: "amateur"
			location:
				type: "Point",
				coordinates: [ 8.227512, 46.818188 ]
			titles: [{
				lang: "fr",
				text: "compétition de course à pied"
			}]
			timetables: [{
				"dates": ["28.01.2015", "29.01.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
			
			{
			category: "game"
			type: "sure"
			location:
				type: "Point",
				coordinates: [ 8.228, 47.0 ]
			titles: [{
				lang: "fr",
				text: "tournoi de poker"
			}]
			timetables: [{
				"dates": ["30.01.2015", "01.02.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
			
			{
			category: "spectacle"
			type: "unsure"
			location:
				type: "Point",
				coordinates: [ 8.0, 46.1 ]
			titles: [{
				lang: "fr",
				text: "marionettes"
			}]
			timetables: [{
				"dates": ["29.01.2015", "01.02.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
			
			{
			category: "concert"
			type: "amateur"
			location:
				type: "Point",
				coordinates: [ 8.0, 46.1 ]
			titles: [{
				lang: "fr",
				text: "Michael Jackson"
			}]
			timetables: [{
				"dates": ["29.01.2015", "01.02.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
			
			{
			category: "other"
			type: "unsure"
			location:
				type: "Point",
				coordinates: [ 8.0, 46.5 ]
			titles: [{
				lang: "fr",
				text: "école de danse \"les danseuses\" - portes ouvertes"
			}]
			timetables: [{
				"dates": ["29.01.2015", "01.02.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
		]
		request.callback(result)

window.fw = new fw()