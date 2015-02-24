
class fw
	@baseUrl: "/"
		
	waitingList: {}
	loadedApp: {}
		
	pubsub: new pubsub()
	
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
		"ionicCSS": @baseUrl + "Library/ionic.css"
		"leafletCSS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css"
		"mapCSS": @baseUrl + "Ressource/css/map.css"
		"markerClusterCSS": @baseUrl + "Library/markerCluster.css"
		"eventDetailCSS": @baseUrl + "Ressource/css/eventDetail.css"
		
		# - JS
		"angularJS": @baseUrl + "Library/angular.js"
		"angularLeafletDirectiveJS": @baseUrl + "Library/angular-leaflet-directive.js"
		"angularUIAnimateJS": @baseUrl + "Library/angular-ui-animate.js"
		"angularRouteJS": @baseUrl + "Library/angular-route.js"
		"angularUIRouterJS": @baseUrl + "Library/angular-ui-router.js"
		"angularResourceJS": @baseUrl + "Library/angular-resource.js"
		"angularSanitizeJS": @baseUrl + "Library/angular-sanitize.js"
		"eventDetailJS": @baseUrl + "Ressource/js/eventDetail.js"
		"indexJS": @baseUrl + "Ressource/js/index.js"
		"ionicJS": @baseUrl + "Library/ionic.js"
		"ionicAngularJS": @baseUrl + "Library/ionic-angular.js"
		"leafletJS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js"
		"mapJS": @baseUrl + "Ressource/js/map.js",
		"markerClusterJS": @baseUrl + "Library/markerCluster.js"
		
	dependencies:
		"mapAPP": ["mapCSS", "markerClusterCSS", "leafletCSS", "leafletJS", "markerClusterJS", "mapJS"]
		"eventDetailAPP": ["eventDetailCSS", "eventDetailJS"]
	
	getDependencies: (url) =>
		start = url.lastIndexOf("/") + 1
		if start == 0
			@dependencies[url]
		else
			end = url.lastIndexOf "."
			dependency = url.substring(start, end) + "APP"
			@dependencies[dependency]

	# --- return a ressource's directory by its name
	getRessource: (ressourceName) =>
		@ressources[ressourceName]
		
	# --- loads dynamically css and js files (filenames) into the document (doc)
	getJsCss: (fileNames, doc, callback) ->
		# --- initial index is -1, so it will be at 0 at the first call of index++
		index = -1
		
		# --- method called for each file
		eachFile = =>
			index++
			name = fileNames[index]

			# --- method called after a file loaded so we can load the next one (if there's one)
			again = =>
				if index < (fileNames.length - 1)
					eachFile()
				else if callback != null
					callback()
			
			# --- create the appropriate tag at the appropriate place for each file type
			if name.slice(-3) is "CSS"
			
				# - if the file already exists, we just load the next one
				alreadyExists = false
				links = document.getElementsByTagName("link");
				for link in links
					do (link) =>
						if link.href == @getRessource name
							alreadyExists = true
					
				if alreadyExists
					again()
				
				# - adds a link element and loads the next one
				file = doc.createElement "link"
				file.href = @getRessource name
				file.rel = "stylesheet"
				file.type = "text/css"
					
				doc.head.appendChild file
				again();
				
			# - .js file
			else if name.slice(-2) is "JS"
			
				# - if the file already exists, we just load the next one
				alreadyExists = false
				links = document.getElementsByTagName("script");
				for link in links
					do (link) =>
						if link.src == @getRessource name
							alreadyExists = true
					
				if alreadyExists
					again()
				
				# - adds
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
			
		eachFile()
	
	# --- make request to the server
	requestServer: (request) ->
		result = [
			{
			category: "sport"
			type: "amateur"
			location:
				type: "Point",
				coordinates: [ 8.227512, 46.818188 ]
			title: "compétition de course à pied"
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
				coordinates: [ 8.1, 46.83 ]
			title: "tournoi de poker"
			description: "Un tournoi de poker entre joueurs"
			timetables: [
				"dates": ["30.01.2015", "01.02.2015"]
				"times": ["08:00", "15:00"]
				
				{"dates": ["05.02.2015", "10.02.2015"]
				"times": ["09:00", "17:00"]}
			]
			address:
				street: "Av. des alpes"
				streetNbr: "16"
				npa: "3960"
				town: "Sierre"
				country: "CH"
			images: [
			    width: 1000
			    height: 750
			    url: "https://nslpoker.files.wordpress.com/2011/09/floating-poker-table-action-norris-m.jpg"
			    {width: 550
			    height: 414
			    url: "http://mobword.ru/wp-content/uploads/2011/07/Texas-Hold%E2%80%99em-Inflatable-Pool-Table.jpg"
			    }
			]
			}
			
			{
			category: "spectacle"
			type: "unsure"
			location:
				type: "Point",
				coordinates: [ 8.0, 46.1 ]
			title: "marionettes"
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
			title: "Michael Jackson"
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
				coordinates: [ 8.0, 46.86 ]
			title: "école de danse \"les danseuses\" - portes ouvertes"
			timetables: [{
				"dates": ["29.01.2015", "01.02.2015"],
				"times": ["08:00", "15:00"]
			}]
			}
		]
		request.callback(result)
	
	# --- called by apps to change page
	goToPage: (uri, params) =>
		# - get the $timeout object
		$injector = angular.element(document.querySelector "body").injector()
		$location = $injector.get "$location"
		$timeout = $injector.get "$timeout"
		
		$timeout ->
			# - change the page
			$location.url uri
			
			# - depending on the uri, execute some functions
			switch uri
				when "/eventDetail"
					wl = window.fw.waitingList
					la = window.fw.loadedApp
					
					###
					# - if the page is already loaded, just publish the parameters
					if la[uri] is true
						window.fw.pubsub.publish "eventDetail", params
						return
					###
					
					# - if the page is not loaded, add the publication to the waiting list
					try
						wl[uri].push ->
							window.fw.pubsub.publish "eventDetail", params
					catch
						wl[uri] = []
						wl[uri].push ->
							window.fw.pubsub.publish "eventDetail", params
		, 1
	
	# --- called when an event was waiting for a page to download
	executeAction: (page) =>
		
		# - indicates the page has been loaded					
		window.fw.loadedApp[page] = true
		
		# - execute the action linked to the page
		wl = window.fw.waitingList
		if !wl[page] or wl[page].length == 0
			null
		else
			p() for p in wl[page]
			delete wl[page]

window.fw = new fw()