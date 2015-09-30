'use strict';

angular.module('app')
  .controller('SelectMediaTypeModalCtrl', function ($scope, MediaModal) {
    $scope.openMediaPopup = openMediaPopup;

    function openMediaPopup(mediaType) {
      MediaModal(mediaType, {caller: 'SelectMediaTypeModal'});
      $scope.$close();
    }
  });
