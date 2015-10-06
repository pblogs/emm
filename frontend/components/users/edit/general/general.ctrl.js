'use strict';

angular.module('app')
  .controller('UsersEditGeneralCtrl', function ($scope, $http, Notification, CurrentUser) {
    $scope.user = $scope.currentUser.clone();
    $scope.submit = submit;

    function submit(password) {
      $scope.errors = {};
      var url = password ? $scope.currentUser.getRestangularUrl() + '/password' : $scope.currentUser.getRestangularUrl();
      $http.put(url, {resource: $scope.user})
        .then(function (responce) {
          $scope.user = responce.data.resource;
          CurrentUser.reload();
          Notification.show('Changes was successfully saved!', 'success')
        })
        .catch(function (response) {
          $scope.errors = _.result(response.data, 'errors');
        })
    }
  });
