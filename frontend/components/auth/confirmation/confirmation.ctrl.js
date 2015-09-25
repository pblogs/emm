'use strict';

/* Controllers */

angular.module('app')
  .controller('ConfirmationCtrl', function ($scope, $auth, $stateParams, $state, $http, Notification) {

    $http.get('api/confirmation', {params: {confirmation_token: $stateParams.token}})
      .then(function (response) {
        $auth.setToken(response.data.auth_token);
        Notification.show('Your email was successfully confirmed!', 'success');
        $state.go('app.main');
      })
  });
