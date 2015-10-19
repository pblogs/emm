'use strict';

angular.module('app')
  .factory('VisibleUser', function(Restangular, CurrentUser) {
    var currentUser, displayingUser;

    CurrentUser.get()
      .then(function (user) {
        currentUser = user;
      });

    return {
      get: function () {
        return displayingUser;
      },

      set: function set(user) {
        displayingUser = user ? user : currentUser;
      }
    };
  });
