
angularApp = angular.module("app", ["ionic"])
window.angularApp = angularApp

###
resolveController = (app) ->
	alert app + " " + $q
	defered = $q.defer()

	fw.getJsCss fw.getDependencies(app), document
	, ->
		$scope.$apply deferred.resolve()
		
	deferred.promised
###
		
# --- services
angularApp.service "resolveController"
, ["$q", ($q) ->
	resolve: (app) ->
    	deferred = $q.defer()
	    
	    sub = fw.pubsub.subscribe "documentReady"
	    , (readyDoc) ->
	    	if readyDoc is app
	    		alert "just resolved now"
	    		deferred.resolve()
	    		fw.pubsub.unsubscribe "documentReady", sub
    	, true
	    
	    fw.getJsCss fw.getDependencies(app), document, ->
	    	null
	    
	    deferred.promised
]

# --- configure the routing of the application
angularApp.config [ "$stateProvider", "$urlRouterProvider", "$controllerProvider"
, ($stateProvider, $urlRouterProvider, $controllerProvider) ->
	$urlRouterProvider.otherwise("/map")
		
	$stateProvider
	.state "map",
		url: "/map"
		templateUrl: "map.html"
	.state "eventDetail",
		url: "/eventDetail"
		templateUrl: "eventDetail.html"
		controller: "eventDetailController"
	
	angularApp._controller = angularApp.controller
	
	angularApp.controller = (name, constructor)->
		alert "index: angularApp.controller called"
		$controllerProvider.register(name, constructor)
		@
	]


# --- loads applications
angularApp.controller 'loadingController', [
    "$scope", ($scope) ->
    	# - get the url of a specified application
    	$scope.getUrl = (ressourceName) =>
    		fw.getRessource ressourceName
	]

# --- subscribes to documentReady topic
fw.pubsub.subscribe "documentReady", fw.executeAction, true