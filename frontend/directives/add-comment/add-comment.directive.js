'use strict';

angular.module('app')
.directive('addComment', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/add-comment/add-comment.html',
      scope: {
        commentable: "=",
        onCreate: "="
      },
      controller: function($scope, CurrentUser, $http) {
        $scope.comment = {
          author: CurrentUser.id()
        };
        $scope.submit = submit;

        function submit() {
          $scope.errors = {};
          $http.post('api/' + $scope.commentable.content_type + '/' + $scope.commentable.id + '/comments', {resource: $scope.comment})
            .then(function(response) {
              $scope.comment.text = '';
              $scope.onCreate(_.result(response.data, 'resource'));
            })
            .catch(function(response) {
              $scope.errors = _.result(response.data, 'errors');
            });
        }
      }
    }
  });
