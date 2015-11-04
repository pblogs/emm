'use strict';

angular.module('app')
  .controller('UsersTributesCtrl', function($scope, $stateParams, Restangular, user, CurrentUser) {
    $scope.loadTributes = loadTributes;
    $scope.user = user;
    $scope.canEdit = user.id == CurrentUser.id();

    loadTributes();
    function loadTributes() {
      $scope.tributesLoader = Restangular.one('users', $stateParams.user_id).all('tributes').toCollection(24);
    }
  });
