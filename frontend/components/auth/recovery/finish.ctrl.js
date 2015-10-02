'use strict';

angular.module('app')
  .controller('FinishRecoveryModalCtrl', function ($scope, $modalInstance, $state, $stateParams, $http, $auth, CurrentUser, Notification) {
    $scope.submit = submit;
    $scope.user = {
      reset_password_token: $stateParams.token
    };

    function submit() {
      $scope.errors = {};
      $http.put('/api/passwords', {user: $scope.user})
        .then(function (response) {
          $auth.setToken(_.result(response.data, 'auth_token'));
          // There may already be another signed in user, so we need to reload current user to get those who changed password
          CurrentUser.reload();
          Notification.show('Password was successfully changed!', 'success');
          $modalInstance.close();
        })
        .catch(function (response) {
          $scope.errors = response.data.errors;
          if ($scope.errors.reset_password_token) {
            Notification.show('<b>Reset password token:</b> ' + $scope.errors.reset_password_token.join('; '), 'danger');
          }
        });
    }
  });
