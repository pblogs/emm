'use strict';

angular.module('app')
  .controller('StartRecoveryModalCtrl', function($scope, $modalInstance, $auth, $http, Notification) {
    $scope.submit = submit;
    $scope.user = {};

    function submit() {
      $scope.errors = {};
      $http.post('/api/passwords', {user: $scope.user}).then(function() {
        Notification.show('Please, check your email: ' + $scope.user.email, 'info');
        $modalInstance.close();
      }, function(response) {
        $scope.errors = response.data.errors;
      });
    }
  });
