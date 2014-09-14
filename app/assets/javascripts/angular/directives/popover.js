angular.module('daddys')
  .directive('popover', [function () {
    return {
      restrict: 'A',
      link: function (scope, element, attrs) {
        if (attrs.popoverEvent) {
          scope.$on(attrs.popoverEvent, function (){
            setTimeout(function (){
              element.popover('show');
            });
          });
        }
      }
    };
  }]);