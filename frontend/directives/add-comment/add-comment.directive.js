'use strict';

angular.module('app')
.directive('addComment', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/add-comment/add-comment.html',
      scope: {
        commentable: "=",
        onCreate: "=",
        contentType: "@"
      },
      controller: function($scope, CurrentUser, $http, Notification, AuthModal) {
        $scope.comment = {
          author: CurrentUser.id()
        };
        $scope.submit = submit;

        function submit() {
          $scope.errors = {};
          $http.post('api/' + $scope.contentType + '/' + $scope.commentable.id + '/comments', {resource: $scope.comment})
            .then(function(response) {
              $scope.comment.text = '';
              $scope.onCreate(_.result(response.data, 'resource'));
            })
            .catch(function(response) {
              $scope.errors = _.result(response.data, 'errors');
              if (response.status == 403) {
                Notification.show('You must Sign In to leave there tribute', 'danger');
                AuthModal('signIn');
              }
            });
        }
      }
    }
  });
