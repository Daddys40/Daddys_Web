angular.module('daddysControllers')
  .controller('NavbarCtrl', ["$scope", "Session", "AuthService", function ($scope, Session, AuthService) {
    $scope.session = Session;
    $scope.signOut = function () {
      AuthService.signOut(); 
    };
  }]);
  