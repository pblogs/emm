'use strict';

angular.module('app')
  .factory('Handle404', function ($state, Notification) {
    return function () {
      $state.go('app.main');
      Notification.show("Page wasn't found", 'warning');
    };
  });
