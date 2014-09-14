angular.module('daddysControllers', ['daddysAuth'])
  .controller('LoginFormCtrl', ["$scope", "AuthService", "AUTH_EVENTS", function ($scope, AuthService, AUTH_EVENTS) {
    $scope.credentials = {
      email: '',
      password: ''
    };

    $scope.errorMessage = ""
    
    $scope.login = function (credentials) {
      AuthService.signIn(credentials).then(
        function () {
        }, 
        function (response) {
          $scope.errorMessage = response.data.errors;
        }
      );
    };
  }])
  .controller('MainCtrl', ["$scope", "Session", function ($scope, Session) {
    $scope.session = Session;
  }]);
  