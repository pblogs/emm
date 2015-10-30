'use strict';

angular.module('app')
  .directive('eTagsInput', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/e-tags-input/e-tags-input.html',
      scope: {
        ngModel: '=',
        errors: "="
      },
      controller: function($scope, Restangular, CurrentUser) {
        $scope.getFriends = getFriends;

        function getFriends(filter) {
          return Restangular.one('users', CurrentUser.id()).all('relationships').getList({status: 'friends', filter: filter})
        }
      }
    }
  });
