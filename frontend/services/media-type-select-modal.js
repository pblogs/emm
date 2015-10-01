'use strict';

/**
 * Service for displaying "What are you going to add" modal
 */
angular.module('app')
  .factory('MediaTypeSelectModal', function ($modal) {

    return function () {
      $modal
        .open({
          templateUrl: 'components/select-media-type/modal.html',
          controller: 'SelectMediaTypeModalCtrl',
          windowClass: 'e-modal'
        });
    };
  });
