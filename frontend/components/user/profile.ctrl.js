'use strict';

angular.module('app')
  .controller('ProfileCtrl', function($scope, currentUser) {
    $scope.currentUser = currentUser;
  });
