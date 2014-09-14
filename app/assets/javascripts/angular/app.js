'use strict';
angular.module('daddys', ['ngRoute', 'ngAnimate', 'daddysControllers'])
  .config(["$httpProvider", function ($httpProvider) {
    var token = $('meta[name=csrf-token]').attr('content');
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = token;
  }])
  .config(["$routeProvider", function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'assets/main.html',
        controller: 'MainCtrl'
      })
      // .when('/about', {
      //   templateUrl: 'views/about.html',
      //   controller: 'AboutCtrl'
      // })
      // .when('/groups', {
      //   templateUrl: 'views/groups.html',
      //   controller: 'GroupsCtrl'
      // })
      .otherwise({
        redirectTo: '/'
      });
  }]);
