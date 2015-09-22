'use strict';

angular.module('app')
  .controller('AppCtrl', function($scope, $modal) {
    $scope.signUpModal = signUpModal;

    function signUpModal() {
      $modal.open({
        templateUrl: 'components/auth/sign-up/modal.html',
        controller: 'SignUpModalCtrl',
        windowClass: 'e-modal'
      })
    }
  });
