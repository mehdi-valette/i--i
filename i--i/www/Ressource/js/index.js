// Generated by CoffeeScript 1.8.0
(function() {
  var angularApp;

  angularApp = angular.module("app", ["ionic"]);

  window.angularApp = angularApp;


  /*
  resolveController = (app) ->
  	alert app + " " + $q
  	defered = $q.defer()
  
  	fw.getJsCss fw.getDependencies(app), document
  	, ->
  		$scope.$apply deferred.resolve()
  		
  	deferred.promised
   */

  angularApp.service("resolveController", [
    "$q", function($q) {
      return {
        resolve: function(app) {
          var deferred, sub;
          deferred = $q.defer();
          sub = fw.pubsub.subscribe("documentReady", function(readyDoc) {
            if (readyDoc === app) {
              alert("just resolved now");
              deferred.resolve();
              return fw.pubsub.unsubscribe("documentReady", sub);
            }
          }, true);
          fw.getJsCss(fw.getDependencies(app), document, function() {
            return null;
          });
          return deferred.promised;
        }
      };
    }
  ]);

  angularApp.config([
    "$stateProvider", "$urlRouterProvider", "$controllerProvider", function($stateProvider, $urlRouterProvider, $controllerProvider) {
      $urlRouterProvider.otherwise("/map");
      $stateProvider.state("map", {
        url: "/map",
        templateUrl: "map.html"
      }).state("eventDetail", {
        url: "/eventDetail",
        templateUrl: "eventDetail.html",
        controller: "eventDetailController"
      });
      angularApp._controller = angularApp.controller;
      return angularApp.controller = function(name, constructor) {
        alert("index: angularApp.controller called");
        $controllerProvider.register(name, constructor);
        return this;
      };
    }
  ]);

  angularApp.controller('loadingController', [
    "$scope", function($scope) {
      return $scope.getUrl = (function(_this) {
        return function(ressourceName) {
          return fw.getRessource(ressourceName);
        };
      })(this);
    }
  ]);

  fw.pubsub.subscribe("documentReady", fw.executeAction, true);

}).call(this);
