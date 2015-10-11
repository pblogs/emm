'use strict';

angular.module('app')
  .controller('UsersEditSecurityCtrl', function ($scope, $http, Notification, CurrentUser, user) {
    $scope.user = user.clone();
    $scope.submit = submit;

    function submit() {
      $scope.errors = {};
      var url = $scope.user.getRestangularUrl() + '/password';
      $http.put(url, {resource: $scope.user})
        .then(function (responce) {
          _.assign($scope.user, responce.data.resource);
          _.assign(user, responce.data.resource);
          CurrentUser.reload();
          Notification.show('Changes was successfully saved!', 'success')
        })
        .catch(function (response) {
          $scope.errors = _.result(response.data, 'errors');
        })
    }
  });
