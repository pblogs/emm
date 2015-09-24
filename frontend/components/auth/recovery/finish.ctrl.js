'use strict';

angular.module('app')
  .controller('FinishRecoveryModalCtrl', function($scope, $modalInstance, $stateParams, $http, Notification) {
    $scope.submit = submit;
    $scope.user = {
      reset_password_token: $stateParams.token
    };

    function submit() {
      $scope.errors = {};
      $http.put('/api/passwords', {user: $scope.user}).then(function(response) {
        var token = _.result(response.data, 'auth_token');
        $modalInstance.close(token);
      }, function(response) {
        $scope.errors = response.data.errors;
        if ($scope.errors.reset_password_token) {
          Notification.show($scope.errors.reset_password_token, 'danger');
        }
      });
    }
  });
