# --- subsribe to "eventDetail" topic and publish its ready state
angularApp.controller "eventDetailController"
, ["$scope", "$timeout", "$ionicTabsDelegate", ($scope, $timeout, $ionicTabsDelegate) ->

	$scope.event = "salut !"
	alert "scope event is " + $scope.event

	# --- method called to bind data and select the second tab
	$scope.init = (data) ->
		
		$timeout ->
			$ionicTabsDelegate.select(1)

			$scope.event = "test"
			alert "$scope.event = test"
		, 100
	
	# --- when user clicks on "close" we go back to map
	$scope.close = ->
		fw.goToPage "/map", {}

	# - listens on "eventDetail"
	if not fw.pubsub.topicExists "eventDetail"
		fw.pubsub.subscribe "eventDetail", $scope.init, true
	
	# - tell the framework the application is ready
	fw.pubsub.publish "documentReady", "/eventDetail"
]