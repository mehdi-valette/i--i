# --- subsribe to "eventDetail" topic and publish its ready state

# --- service used to collect event data before the view is generated
angularApp.service "eventDetailService"
, [ "$q", ($q) ->
	loadData: ->
		$q (resolve, reject) ->
			
			# --- called once the subscriber (eventDetail) recieves the information
			# - from the publisher (map)
			init = (data) ->
				# - cancel the handler
				fw.pubsub.unsubscribe "eventDetail", subHandler
				
				# - resolve the data
				resolve(data)
		
			# - listens on "eventDetail"
			subHandler = fw.pubsub.subscribe "eventDetail", init, true
			
			# - tell the framework the application is ready
			fw.pubsub.publish "documentReady", "/eventDetail"
]

# --- controller used for the view
angularApp.controller "eventDetailController"
, ["$scope", "$timeout", "$ionicTabsDelegate", "eventDetailResolver"
, ($scope, $timeout, $ionicTabsDelegate, eventDetailResolver) ->
	
	$scope.event = eventDetailResolver.event
	
	$timeout =>
		$ionicTabsDelegate.select(1)
	, 100
	
	# --- when user clicks on "close" we go back to map
	$scope.close = ->
		fw.goToPage eventDetailResolver.backTo, {}
		
	# -- each picture has a width and height that has to be calculated
	$scope.imageStyle = (image) ->
		propertyName = ""
		maxSize = 380
		width = 0
		height = 0
	
		if image.width > image.height
			width = maxSize
			height = Math.round maxSize * (image.height/image.width)
		else
			height = maxSize
			width = Math.round maxSize * (image.width/image.height)
			
		{
		"width": width
		"height": height
		}
]