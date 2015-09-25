'use strict';

/* Controllers */

angular.module('app')
  .controller('ConfirmationCtrl', function ($scope, $auth, $stateParams, $state, $http, CurrentUser, Notification) {

    $http.get('api/confirmation', {params: {confirmation_token: $stateParams.token}})
      .then(function (response) {
        $auth.setToken(response.data.auth_token);
        // There may already be another signed in user, so we need to reload current user to get those who confirmed email
        CurrentUser.reload();
        Notification.show('Your email was successfully confirmed!', 'success');
        $state.go('app.main');
      })
      .catch(function (response) {
        Notification.showValidationErrors(response.data.errors);
        $state.go('app.main');
      });
  });
