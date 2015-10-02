'use strict';

angular.module('app')
  .controller('SignUpModalCtrl', function ($scope, $modalInstance, $http, Notification) {
    $scope.user = {
      birthday: new Date()
    };
    $scope.submit = submit;

    function submit() {
      $scope.errors = {};
      $http.post('/api/registration', {user: $scope.user})
        .then(function () {
          Notification.show('Email confirmation sent, please check your email to activate your account.', 'info');
          $modalInstance.close();
        })
        .catch(function (response) {
          $scope.errors = response.data.errors;
        });
    }
  });
