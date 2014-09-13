angular.module('daddysControllers', ['daddysAuth'])
  .controller('LoginFormCtrl', ["$scope", "$rootScope", "AuthService", "AUTH_EVENTS", function ($scope, $rootScope, AuthService, AUTH_EVENTS) {
    $scope.credentials = {
      username: '',
      password: ''
    };
    
    $scope.login = function (credentials) {
      AuthService.signIn(credentials).then(function (user) {
        $rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
      }, function () {
        $rootScope.$broadcast(AUTH_EVENTS.loginFailed);
      });
    };
  }]);