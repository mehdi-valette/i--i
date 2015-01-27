class fw
	@baseUrl: "/"
		
	# --- associative array of ressource's name - ressource's directory
	ressources:
		"indexCSS": @baseUrl + "Ressource/css/index.css",
		"mapAPP": @baseUrl + "Component/Map/View/map.html",
		"mapJS": @baseUrl + "Ressource/js/map.js",
		"mapCSS": @baseUrl + "Ressource/css/map.css",
		"leafletJS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.js",
		"leafletCSS": "http://cdn.leafletjs.com/leaflet-0.7.3/leaflet.css",
		"angularJS": "https://ajax.googleapis.com/ajax/libs/angularjs/1.3.10/angular.min.js"

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
			
			# --- create the appropriate tag at the appropriate place for each file type
			if name.slice(-3) is "CSS"
				file = doc.createElement "link"
				file.href = @getRessource name
				file.rel = "stylesheet"
				file.type = "text/css"
					
				doc.head.appendChild file
				
			else if name.slice(-2) is "JS"
				file = doc.createElement "script"
				file.src = @getRessource name
				file.type = "text/javascript"
					
				doc.body.appendChild file
				
			# --- method called after a file loaded so we can load the next one (if there's one)
			again = =>
				if index < (fileNames.length - 1)
					callback()
					
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

window.fw = new fw()