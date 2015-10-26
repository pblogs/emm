'use strict';

angular.module('app')
.directive('relationshipBtn', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/relationship-btn/relationship-btn.html',
      scope: {
        user: "="
      },
      controller: function($scope, Restangular) {
        $scope.removeRelationship = removeRelationship;
        $scope.createRelationship = createRelationship;
        $scope.incomingRequestAction = incomingRequestAction;

        function removeRelationship() {
          Restangular.one('users', $scope.user.id).one('relationships', $scope.user.relationship.id).remove()
            .then(function() {
              $scope.user.relationship = null;
            })
        }

        function createRelationship() {
          Restangular.one('users', $scope.user.id).all('relationships').post()
            .then(function(resource) {
              $scope.user.relationship = resource;
            })
        }

        function incomingRequestAction(action) {
          Restangular.one('users', $scope.user.id).one('relationships', $scope.user.relationship.id).customPUT({status: action})
            .then(function(relationship) {
              $scope.user.relationship = relationship;
            });
        }
      }
    }
  });
