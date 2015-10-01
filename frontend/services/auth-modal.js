'use strict';

/**
 * Service for auth modal windows
 */
angular.module('app')
  .factory('AuthModal', function ($modal) {
    var map = {
      signIn: {
        templateUrl: 'components/auth/sign-in/modal.html',
        controller: 'SignInModalCtrl'
      },
      signUp: {
        templateUrl: 'components/auth/sign-up/modal.html',
        controller: 'SignUpModalCtrl'
      },
      startRecovery: {
        templateUrl: 'components/auth/recovery/start.html',
        controller: 'StartRecoveryModalCtrl'
      },
      finishRecovery: {
        templateUrl: 'components/auth/recovery/finish.html',
        controller: 'FinishRecoveryModalCtrl'
      }
    };

    function showModal(type) {
      $modal
        .open({
          templateUrl: map[type].templateUrl,
          controller: map[type].controller,
          windowClass: 'e-modal'
        })
        .result
        .catch(function (reason) {
          if (reason === 'signIn') showModal('signIn');
          if (reason === 'signUp') showModal('signUp');
          if (reason === 'startRecovery') showModal('startRecovery');
          if (reason === 'finishRecovery') showModal('finishRecovery');
        });
    }

    return showModal;
  });
