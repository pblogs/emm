'use strict';

/**
 * Config for the roles
 */
angular.module('app')
  .run(function Roles(Permission, $auth, CurrentUser, $q) {

    Permission.defineRole('anonymous', function () {
      return !$auth.isAuthenticated();
    });

    _.forEach(['member', 'admin'], function (role) {
      Permission.defineRole(role, function () {
        if (!$auth.isAuthenticated()) return false;

        var deferred = $q.defer();
        CurrentUser.get('roles')
          .then(function (user) {
            user.role === role ? deferred.resolve() : deferred.reject();
          })
          .catch(function () {
            deferred.reject();
          });

        return deferred.promise;
      });
    });
  });
