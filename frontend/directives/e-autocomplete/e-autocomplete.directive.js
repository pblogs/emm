'use strict';

angular.module('app')
  .directive('eAutocomplete', function() {
    return {
      restrict: "E",
      replace: true,
      templateUrl: "directives/e-autocomplete/e-autocomplete.html",
      scope: {
        ngModel: "=",
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
