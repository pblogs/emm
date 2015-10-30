'use strict';

angular.module('app')
  .directive('like', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/like/like.html',
      scope: {
        target: "=",
        type: "@"
      },
      controller: function($scope, $http, Notification, AuthModal, Restangular) {
        $scope.leaveLike = leaveLike;

        function leaveLike() {
          if ($scope.target.like) {
            Restangular.one('likes', $scope.target.like.id).remove()
              .then(function() {
                $scope.target.likes_count--;
                $scope.target.like = null;
              })
          } else {
            $http.post('api/likes', {resource: {type: $scope.type, id: $scope.target.id}})
              .then(function(response) {
                $scope.target.likes_count++;
                $scope.target.like = response.data.resource;
              })
              .catch(function(response) {
                if (response.status == 403) {
                  Notification.show('You must Sign In to leave there tribute', 'danger');
                  AuthModal('signIn');
                }
              })
          }
        }
      }
    }
  });
