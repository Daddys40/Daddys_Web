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
    this.create = function (sessionId, userId) {
      this.id = sessionId;
      this.userId = userId;
    };
    this.destroy = function () {
      this.id = null;
      this.userId = null;
    };
    return this;
  })
  .factory('AuthService', function ($http, Session, Auth) {
    var authService = {};
   
    authService.signIn = function (credentials) {
      return Auth.signIn(
        credentials, 
        function(response) {
          console.log(arguments);
        }).$promise
      // Tag.delete(parameters
      //   , () ->
      //     $element.modal("hide")
      //     if $scope.onRemove
      //       $scope.onRemove()
      //   , (response) ->
      //       $scope.errorMessage = response.data.error
      // )
      // return $http
      //   .post('/login', credentials)
      //   .then(function (res) {
      //     Session.create(res.data.id, res.data.user.id,
      //                    res.data.user.role);
      //     return res.data.user;
      //   });
    };
   
    authService.isAuthenticated = function () {
      return !!Session.userId;
    };

    // Should be handled by passing cancan abilities to AngularJS side.
    //  
    // authService.isAuthorized = function (authorizedRoles) {
    //   if (!angular.isArray(authorizedRoles)) {
    //     authorizedRoles = [authorizedRoles];
    //   }
    //   return (authService.isAuthenticated() &&
    //     authorizedRoles.indexOf(Session.userRole) !== -1);
    // };
   
    return authService;
  });

