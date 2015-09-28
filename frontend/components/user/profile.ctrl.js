'use strict';

angular.module('app')
  .controller('ProfileCtrl', function($scope, $stateParams, Restangular) {
    $scope.user = {};
    Restangular.one('users', $stateParams.id).get().then(function(user) {
      $scope.user = user;
    })
  });
