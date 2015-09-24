'use strict';

angular.module('app')
  .controller('SignInModalCtrl', function($scope, $modalInstance, $auth, $http, Notification) {
    $scope.user = {};
    $scope.submit = submit;

    function submit() {
      var errors = [];
      $http.post('/api/login', {user: $scope.user}).then(function(response) {
        var token = _.result(response.data, 'auth_token');
        if (token) {
          $auth.setToken(token);
          Notification.show('Welcome!', 'success');
          $modalInstance.close();
        }
      }, function(response) {
        errors = response.data.errors;
        Notification.show(errors, 'danger');
      });
    }
  });
