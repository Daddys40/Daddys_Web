angular.module('daddys')
  .directive('loginDialog', [ function () {
    return {
      restrict: 'A',
      link: function (scope) {
        scope.visible = false;
        var showDialog = function () {
          scope.visible = true;
        };
        showDialog();
        // scope.visible = false;
        // scope.$on(AUTH_EVENTS.notAuthenticated, showDialog);
        // scope.$on(AUTH_EVENTS.sessionTimeout, showDialog)
      }
    };
  }]);