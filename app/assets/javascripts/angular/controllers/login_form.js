#= require "./index.js"

angular.module('frenddy.controller')
  .controller('LoginFormCtrl', ["$scope", "AuthService", "AUTH_EVENTS", function ($scope, AuthService, AUTH_EVENTS) {
    $scope.credentials = {
      email: '',
      password: ''
    };
    $scope.errorMessage = ""
    $scope.login = function (credentials) {
      AuthService.signIn(credentials).then(
        function () {
          $scope.credentials = {};
        }, 
        function (response) {
          $scope.errorMessage = response.data.errors;
          $scope.$broadcast("loginFailed");
        }
      );
    };
  }])