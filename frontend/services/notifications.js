'use strict';

/**
 * Service for notification
 */
angular.module('app')
  .factory('Notification', function(notify) {
    return {
      show: showNotification
    };

    function showNotification(message, type) {
      notify({
        templateUrl: 'vendor/notify.html',
        classes: normalizeClass(type),
        message: normalizeMessage(message),
        position: 'center'
      });
    }

    function normalizeClass(type) {
      return 'alert-' + (type || 'success');
    }

    function normalizeMessage(message) {
      return _.isArray(message) ? message.join('') : message;
    }
  });
