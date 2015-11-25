'use strict';

/**
 * Service for displaying modals for media create/edit
 */
angular.module('app')
  .factory('MediaModal', function ($modal) {

    return function (mediaType, options) {
      options = options || {};
      return $modal
        .open({
          templateUrl: 'components/' + mediaType + 's' + '/new/modal.html',
          controller: _.capitalize(mediaType) + 's' + 'NewModalCtrl',
          size: 'lg',
          windowClass: 'e-modal',
          resolve: {
            caller: function() {
              return options.caller;
            }
          }
        });
    };
  });
