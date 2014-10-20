angular.module('daddysFilters', [])
  .filter('notificationsDays', function () {
 		return function (input) {
 			if (input) {
	 			var output = []
	 			var days = ["일", "월", "화", "수", "목", "금", "토"];
	 			for (var i = 0, len = input.length; i < len; i++) {
	 				output.push(days[input[i]]);
				}
				return output.join(" ");
 			} else {
	 			return input;
	 		}
 		}
  });  
