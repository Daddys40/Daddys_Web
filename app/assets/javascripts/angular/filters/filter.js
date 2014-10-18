angular.module('daddysFilters', [])
  .filter('notificationsDays', function () {
 		return function (input) {
 			days = ["일", "월", "화", "수", "목", "금", "토"];
 			days.forEach(function(value, key) {
				input = input.replace(key.toString(), value); 				
 			});
 			console.log(input);
 			return input;
 		}
  });  
