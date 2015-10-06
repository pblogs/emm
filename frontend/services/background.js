'use strict';

angular.module('app')
  .factory('Background', function (CurrentUser) {
    var currentUser, displayingUser;

    CurrentUser.get()
      .then(function (user) {
        currentUser = user;
      });

    return {
      get: function () {
        var bgUrl = _.get(displayingUser || currentUser, 'background_url.original');
        return bgUrl ? {'background-image': 'url(' + bgUrl + ')'} : {};
      },

      set: function set(user) {
        displayingUser = CurrentUser.id() === user.id ? currentUser : user;
      },

      reset: function() {
        displayingUser = undefined;
      }
    };
  });
