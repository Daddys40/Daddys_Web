'use strict';

angular.module('daddysAuth', ['daddysAPI'])
  .constant('AUTH_EVENTS', {
    loginSuccess: 'auth-login-success',
    loginFailed: 'auth-login-failed',
    logoutSuccess: 'auth-logout-success',
    sessionTimeout: 'auth-session-timeout',
    notAuthenticated: 'auth-not-authenticated',
    notAuthorized: 'auth-not-authorized'
  })
  // Singleton service for saving current session
  .service('Session', function () {
    this.create = function (user) {
      this.user = user;
    };
    this.destroy = function () {
      this.user = null;
    };
    this.current = function () {
      return this.user;
    }
    return this;
  })
  .factory('AuthService', [
    "$http", "Session", "Auth", "$rootScope", "AUTH_EVENTS", 
    function ($http, Session, Auth, $rootScope, AUTH_EVENTS) {
      var authService = {};
      authService.signIn = function (credentials) {
        return Auth.signIn(
          {
            user: credentials
          }, 
          function (response) {
            Session.create(response.current_user);
            $rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
          }, 
          function (response) {
            Session.destroy();
            $rootScope.$broadcast(AUTH_EVENTS.loginFailed);
          }
        ).$promise;
      };
      authService.signOut = function() {
        return Auth.signOut(
          {}, 
          function (response) {
            Session.destroy();
            $rootScope.$broadcast(AUTH_EVENTS.logoutSuccess);
          }, 
          function (response) {
            $rootScope.$broadcast(AUTH_EVENTS.loginFailed);
          }
        ).$promise;
      };
      authService.validate = function() {
        return Auth.validate(
          {},
          function (response) {
            Session.create(response.current_user);
            $rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
          },  
          function (response) {
            Session.destroy();
            $rootScope.$broadcast(AUTH_EVENTS.notAuthenticated);
          }
        ).$promise;
      };
      authService.isAuthenticated = function () {
        return !!Session.userId;
      };     
      return authService;
    }
  ])
  .factory('AuthInterceptor',["$rootScope", "$q", "AUTH_EVENTS", function ($rootScope, $q, AUTH_EVENTS) {
    return {
      responseError: function (response) { 
        $rootScope.$broadcast({
          401: AUTH_EVENTS.notAuthenticated,
          403: AUTH_EVENTS.notAuthorized,
          419: AUTH_EVENTS.sessionTimeout,
          440: AUTH_EVENTS.sessionTimeout
        }[response.status], response);
        return $q.reject(response);
      }
    };
  }])
  .config(["$httpProvider", function ($httpProvider) {
    $httpProvider.interceptors.push([
      '$injector',
      function ($injector) {
        return $injector.get('AuthInterceptor');
      }
    ]);
  }])
  .run(["AuthService", function (AuthService) {
    AuthService.validate()
  }]);
