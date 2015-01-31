
app = angular.module("index", ["ionic"])

# --- configure the routing of the application
app.config [ "$stateProvider", "$urlRouterProvider", ($stateProvider, $urlRouterProvider) ->
	$urlRouterProvider.otherwise("/")
		
	$stateProvider
	.state "map",
		url: "/"
		views:
			map:
				templateUrl: "map.html"
	.state "eventDetail",
		url: "/eventDetail"
		views:
			eventDetail:
				templateUrl: "eventDetail.html"
	]

# --- loads applications
app.controller 'loadingController', [
    "$scope", ($scope) ->
    	# - get the url of a specified application
    	$scope.getUrl = (ressourceName) =>
    		fw.getRessource ressourceName
	]