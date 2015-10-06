'use strict';

angular.module('app')
  .controller('UserAvatarPopupCtrl', function ($scope, $http, Notification, CurrentUser, $timeout) {
    $scope.submit = submit;

    CurrentUser.get().then(function (user) {
      $scope.user = user.clone();
    });

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function () {
      $scope.showCanvas = true;
    }, 100);

    function submit() {
      $scope.errors = {};
      $http.put($scope.user.getRestangularUrl(), {resource: $scope.user})
        .then(function (responce) {
          $scope.user = responce.data.resource;
          CurrentUser.reload();
          Notification.show('Changes was successfully saved!', 'success');
          $scope.$close();
        })
        .catch(function (response) {
          $scope.errors = _.result(response.data, 'errors');
        });
    }
  });
