'use strict';

/**
 * Service for the current user
 */
angular.module('app')
  .factory('CurrentUser', function ($auth, Restangular, $q) {
    var promise;
    var currentUser = Restangular.one('users');

    return {
      get: function () {
        return promise || load();
      },
      reload: function () {
        return load();
      },
      id: function () {
        return userId();
      }
    };

    function load() {
      if ($auth.isAuthenticated()) {
        promise = Restangular.one('users', userId()).get()
          .then(function (user) {
            _.extend(currentUser, user);
            return currentUser;
          })
          .catch(function () {
            resetCurrentUser();
            return currentUser;
          });
      }
      else {
        resetCurrentUser();
        promise = $q.when(currentUser);
      }
      return promise;
    }

    function userId() {
      return _.result($auth.getPayload(), 'user.id');
    }

    function resetCurrentUser() {
      _.forEach(currentUser, function (val, key, obj) {
        !_.isFunction(val) && delete obj[key];
      });
    }
  });
