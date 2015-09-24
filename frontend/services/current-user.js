'use strict';

/**
 * Service for the current user
 */
angular.module('app')
  .factory('CurrentUser', function($auth, Restangular) {
    var promise;

    return {
      get: function() {
        return promise || load();
      },
      reload: function() {
        return load();
      },
      reset: function() {
        promise = undefined;
      },
      id: function() {
        return userId();
      }
    };

    function load() {
      return (promise = Restangular.one('users', userId()).get());
    }

    function userId() {
      return _.result($auth.getPayload(), 'user.id');
    }
  });
