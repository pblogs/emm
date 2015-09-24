'use strict';

angular.module('app')
  .controller('FinishRecoveryCtrl', function($scope, $modal, $auth, Notification, $state) {
    finishRecoveryModal();

    function finishRecoveryModal() {
      $modal.open({
        templateUrl: 'components/auth/recovery/finish.html',
        controller: 'FinishRecoveryModalCtrl',
        windowClass: 'e-modal'
      }).result.then(function(token) {
          if (token) {
            Notification.show('Password was successfully changed!', 'success');
            $auth.setToken(token);
            $state.go('app.main')
          }
        }, function() {
          $state.go('app.main');
        })
    }
  });
