angular.module('daddys')
  .directive('loginDialog', ["AUTH_EVENTS", function (AUTH_EVENTS) {
    return {
      restrict: 'A',
      link: function (scope) {
        scope.visible = false;

        function showDialog () {
          scope.visible = true;
        }
        
        function closeDialog () {
          scope.visible = false;
        }

        scope.$on(AUTH_EVENTS.notAuthenticated, showDialog);
        scope.$on(AUTH_EVENTS.logoutSuccess,    showDialog);

        scope.$on(AUTH_EVENTS.loginSuccess, closeDialog);
      }
    };
  }]);