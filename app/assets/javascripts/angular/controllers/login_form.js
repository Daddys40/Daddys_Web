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
  .controller('MainCtrl', ["$scope", function ($scope) {
  }])
  .controller('UsersIndexCtrl', ["$scope", "User", function ($scope, User) {
    $scope.totalMetric = {}

    User.totalMetric(function(totalMetric){
      $scope.totalMetric = totalMetric
    })

    User.countChart(function(countChart){
      $scope.countChart = countChart
    })
  }])
  .controller('ApplicationCtrl', ["$scope", "Session", function ($scope, Session) {
    $scope.session = Session;
  }]);
  

  