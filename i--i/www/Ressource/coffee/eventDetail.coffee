# --- subsribe to "eventDetail" topic and publish its ready state
angularApp.controller "eventDetailController"
, ["$scope", ($scope) ->
	test = (data) ->
		$scope.event = data

	fw.pubsub.subscribe "eventDetail", test, true
	fw.pubsub.publish "documentReady", "/eventDetail"
	
	$scope.close = ->
		fw.goToPage "/map", {}
]