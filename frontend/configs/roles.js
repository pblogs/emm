'use strict';

/**
 * Config for the roles
 */
angular.module('app')
  .run(function Roles(Permission, $auth, CurrentUser, $q) {
    Permission.defineRole('anonymous', function() {
      return !$auth.isAuthenticated();
    });

    _.each(['member', 'admin'], function(role) {
      Permission.defineRole(role, function() {
        if (!$auth.isAuthenticated()) {
          return false;
        }

        var deferred = $q.defer();
        CurrentUser.get().then(function(user) {
          if (user.role === role) {
            deferred.resolve();
          } else {
            deferred.reject();
          }
        }, function() {
          deferred.reject();
        });

        return deferred.promise;
      });
    });
  });
