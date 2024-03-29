#= require "./index.js"

angular.module('frenddy.provider.api', ['ngResource'])
	.factory("Auth", ['$resource', function($resource){
  	return $resource(
  		"/users/:action",
  		{},
  		{
  			validate: {
  				method: 'POST',
  				params: {
  					action: "validate"
  				}
  			},
  			signIn: {
	  			method: 'POST',
	  			params: { 
	  				action: "sign_in"
	  			}
	  		},
	  		signOut: {
	  			method: 'DELETE',
	  			params: {
	  				action: "sign_out"
	  			}
	  		}
 			}
  	);
	}])
  .factory("User", ['$resource', function($resource){
    return $resource(
      "/users/:id", 
      {
        id: "@id"
      }, 
      {
        totalMetric: {
          method: "GET",
          params: {
            id: "total_metric"
          }
        },
        countChart: {
          method: "GET",
          params: {
            id: "count_chart"
          }
        }
      }
    );
  }])
  .factory("Feedback", ['$resource', function($resource){
    return $resource(
      "/feedbacks/:id", 
      {
        id: "@id"
      } 
    );
  }]);
