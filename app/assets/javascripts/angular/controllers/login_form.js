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
          $scope.credentials = {};
        }, 
        function (response) {
          $scope.errorMessage = response.data.errors;
          $scope.$broadcast("loginFailed");
        }
      );
    };
  }])
  .controller('MainCtrl', ["$scope", "Session", function ($scope, Session) {
    $scope.session = Session;
  }])
  .controller('UsersCtrl', ["$scope", "User", function ($scope, User) {
    $scope.users = [];

    User.query(function (users){
      $scope.users = users;
    });
  }]);

  