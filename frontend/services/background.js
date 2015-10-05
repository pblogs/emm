'use strict';

/**
 * Service for the current user
 */
angular.module('app')
  .factory('Background', function () {
    var bg;

    return {
      set: set,
      get: get
    };

    function set(user) {
      bg = undefined;
      if (user && user.background_url) {
        bg =  {'background-image': 'url(' + user.background_url.original + ')'}
      }
    }

    function get() {
        return bg;
    }
  });
