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

    function showNotification(message, type, align) {
      notify({
        templateUrl: 'services/notification/notify.html',
        classes: normalizeClass(type, align),
        message: $sce.trustAsHtml(message),
        position: 'right',
        html: true
      });
    }

    function showValidationErrors(errorsHash) {
      var text = _.map(errorsHash, function (errors, field) {
        return '<b>' + field + ':</b> ' + errors.join('; ');
      }).join('<br/>');
      showNotification(text, 'danger', 'left');
    }

    function normalizeClass(type, align) {
      return 'alert-' + (type || 'success') + ' text-' + (align || 'center');
    }
  });
