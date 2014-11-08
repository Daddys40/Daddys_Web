#= require "./index.js"

angular.module('frenddy.controller')
  .controller('UsersIndexCtrl', ["$scope", "User", function ($scope, User) {
    $scope.totalMetric = {}
    $scope.notificationsDaysChartConfig = {
		  "options": {
		    "chart": {
		      "type": "areaspline"
		    },
		    "plotOptions": {
		      "series": {
		        "stacking": ""
		      }
		    }
		  },
		  "series": [
		    {
		      "name": "Some data",
		      "data": [
		        1,
		        2,
		        4,
		        7,
		        3
		      ],
		      "id": "series-0"
		    },
		    {
		      "name": "Some data 3",
		      "data": [
		        3,
		        1,
		        null,
		        5,
		        2
		      ],
		      "connectNulls": true,
		      "id": "series-1"
		    },
		    {
		      "name": "Some data 2",
		      "data": [
		        5,
		        2,
		        2,
		        3,
		        5
		      ],
		      "type": "column",
		      "id": "series-2"
		    },
		    {
		      "name": "My Super Column",
		      "data": [
		        1,
		        1,
		        2,
		        3,
		        2
		      ],
		      "type": "column",
		      "id": "series-3"
		    }
		  ],
		  "title": {
		    "text": "Hello"
		  },
		  "credits": {
		    "enabled": true
		  },
		  "loading": false,
		  "size": {}
		}

    User.totalMetric(function(totalMetric){
      $scope.totalMetric = totalMetric

    })

    User.countChart(function(countChart){
      $scope.countChart = countChart
    })
  }]);