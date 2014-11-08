# = require "./index.js"

angular.module('frenddy.controller')
  .controller('UsersIndexCtrl', ["$scope", "User", "$filter",
    function($scope, User, $filter) {
      $scope.totalMetric = {}

      User.totalMetric(function(totalMetric) {
        $scope.totalMetric = totalMetric

        $scope.notificationsDaysChartConfig = {
          options: {
            chart: {
              type: 'column'
            },
          },
          series: [{
            name: "Notificaion Days",
            data: _.map(totalMetric.notifications_days, function(count, day) {
              return count;
            })
          }],
          title: {
            text: 'Notificaion Days'
          },
          xAxis: {
            categories: (function() {
              daysFilter = $filter("notificationsDays")
              return _.map(totalMetric.notifications_days, function(count, day) {
                return daysFilter(day);
              })
            })()
          }
        };

        $scope.notificateAtChartConfig = {
          options: {
            chart: {
              type: 'column'
            },
          },
          series: [{
            name: "Notificate At",
            data: _.map(totalMetric.notificate_at, function(count, day) {
              return count;
            })
          }],
          title: {
            text: 'Notificate At'
          },
          xAxis: {
            categories: _.map(totalMetric.notificate_at, function(count, hour) {
            	return hour;
            })
          }
        };
      })

      User.countChart(function(countChart) {
        $scope.countChart = countChart
      })
    }
  ]);