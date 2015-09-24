'use strict';

angular.module('app')
  .controller('AppCtrl', function($scope, $modal) {
    $scope.signUpModal = signUpModal;
    $scope.signInModal = signInModal;
    $scope.startRecoveryModal = startRecoveryModal;

    function signUpModal() {
      $modal.open({
        templateUrl: 'components/auth/sign-up/modal.html',
        controller: 'SignUpModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
        if (reason === 'signIn') {
          signInModal();
        }
      });
    }
    function startRecoveryModal() {
      $modal.open({
        templateUrl: 'components/auth/recovery/start.html',
        controller: 'StartRecoveryModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
          if (reason === 'signIn') {
            signInModal();
          }
        });
    }
    function signInModal() {
      $modal.open({
        templateUrl: 'components/auth/sign-in/modal.html',
        controller: 'SignInModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
        if (reason === 'signUp') {
          signUpModal();
        }
        if (reason === 'recovery') {
          startRecoveryModal();
        }
      });
    }
  });
