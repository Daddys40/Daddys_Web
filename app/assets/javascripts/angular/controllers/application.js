#= require "./index.js"

angular.module('frenddy.controller')
  .controller('ApplicationCtrl', ["$scope", "Session", function ($scope, Session) {
    $scope.session = Session;
  }]);