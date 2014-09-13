'use strict';
var app = angular.module('daddys', ['ngRoute', 'daddysControllers'])

app.config(["$httpProvider", function ($httpProvider) {
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
}]);

app.config(["$routeProvider", function ($routeProvider) {
  $routeProvider
    // .when('/', {
    //   templateUrl: 'views/main.html',
    //   controller: 'MainCtrl'
    // })
    // .when('/about', {
    //   templateUrl: 'views/about.html',
    //   controller: 'AboutCtrl'
    // })
    // .when('/groups', {
    //   templateUrl: 'views/groups.html',
    //   controller: 'GroupsCtrl'
    // })
    // .otherwise({
    //   redirectTo: '/'
    // });
}]);
 
app.run([function(){

}]);