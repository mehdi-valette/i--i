
# --- service to load transmitted data before imageViewer
angularApp.service "imageViewerService"
, [ "$q", ($q) ->
	loadData: ->
		$q (resolve, reject) ->
		
			# --- called once the subscriber (imageViewer) recieves the information
			# - from the publisher (eventDetail)
			init = (data) ->
				# - cancel the handler
				fw.pubsub.unsubscribe "/imageViewer", subHandler
				
				# - resolve the data
				resolve(data)
			
			# - listens on "imageViewer"
			subHandler = fw.pubsub.subscribe "/imageViewer", init, true
			
			# - tell the framework the application is ready
			fw.pubsub.publish "documentReady", "/imageViewer"
]

# --- controller for imageViewer
angularApp.controller "imageViewerController"
, ["$scope", "$ionicSlideBoxDelegate", "$timeout", "imageViewerResolver"
, ($scope, $ionicSlideBoxDelegate, $timeout, imageViewerResolver) ->

	$scope.images = imageViewerResolver.images
	
	$timeout =>
		$ionicSlideBoxDelegate.slide(imageViewerResolver.index, 200)
	, 500
	
	# -- each image has a url, width and height
	$scope.imageStyle = (image) ->
		
		style = {}
		style["background-image"] = "url(" + image.url + ")"
		
		if image.width < image.height
			style.width = "100%"
		else
			style.height = "100%"
	
		style
	
	# --- goes back to eventDetail
	$scope.close = ->
		fw.goToPage imageViewerResolver.backTo, {}
]