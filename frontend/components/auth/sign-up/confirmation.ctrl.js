'use strict';

/* Controllers */

angular.module('app')
  .controller('SignUpConfirmationCtrl', function($scope, $auth, $stateParams, $state, $http, Notification) {

    $http.get('api/confirmation', {params: {confirmation_token: $stateParams.token}})
      .then(function(response) {
        $auth.setToken(response.data.auth_token);
        Notification.show('Your account was successfully confirmed!', 'success');
        $state.go('app.main');
      })
  });
