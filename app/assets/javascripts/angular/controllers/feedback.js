# = require "./index.js"

angular.module('frenddy.controller')
  .controller('FeedbacksIndexCtrl', ["$scope", "Feedback",
    function($scope, Feedback) {
      $scope.feedbacks = []
      $scope.inLoading = false
      $scope.loadMoreFeedback = function () {
        if ($scope.inLoading) return;
        $scope.inLoading = true
        Feedback.query({}, function(feedbacks) {
          Array.prototype.push.apply($scope.feedbacks, feedbacks)
          $scope.inLoading = false
        });
      }
      $scope.loadMoreFeedback();
    } 
  ]);