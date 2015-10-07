'use strict';

/**
 * Service for notification
 */
angular.module('app')
  .factory('Notification', function (notify, $sce) {
    return {
      show: showNotification,
      showValidationErrors: showValidationErrors
    };

    function showNotification(message, type) {
      notify({
        templateUrl: 'services/notification/notify.html',
        classes: normalizeClass(type),
        message: $sce.trustAsHtml(message),
        position: 'right',
        html: true
      });
    }

    function showValidationErrors(errorsHash) {
      var text = _.map(errorsHash, function (errors, field) {
        return '<b>' + field + ':</b> ' + errors.join('; ');
      }).join('<br/>');
      showNotification(text, 'danger');
    }

    function normalizeClass(type) {
      return 'alert-' + (type || 'success');
    }
  });
