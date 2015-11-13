'use strict';

angular.module('app')
  .directive('eNotification', function() {
    return {
      restrict: 'E',
      transclude: true,
      templateUrl: 'directives/e-notification/e-notification.html',
      scope: {
        notification: "=",
        unreadNotificationsCount: "="
      },
      controller: function ($scope, $modal, Restangular) {
        $scope.template = 'directives/e-notification/templates/' + $scope.notification.event + '.html';
        $scope.showPost = showPost;
        $scope.incomingRequestAction = incomingRequestAction;
        $scope.viewNotification = viewNotification;

        function viewNotification() {
          if (!$scope.notification.viewed) {
            $scope.notification.viewed = true;
            $scope.notification.put()
              .then(function(model) {
                $scope.unreadNotificationsCount--;
                $scope.notification.viewed = model.viewed;
              });
          }
        }

        function showPost() {
          var type, content;
          if ($scope.notification.event == 'comment') {
            content = $scope.notification.content.commentable;
            type = $scope.notification.content.commentable_type.toLowerCase();
          }
          if ($scope.notification.event == 'like' || $scope.notification.event == 'tag') {
            type = $scope.notification.content.target.commentable ? $scope.notification.content.target.commentable_type.toLowerCase() : $scope.notification.content.target_type.toLowerCase();
            content= $scope.notification.content.target.commentable ? $scope.notification.content.target.commentable : $scope.notification.content.target;
          }
          $modal
            .open({
              templateUrl: 'components/' + type + 's/show/show.html',
              controller: 'ShowModalCtrl',
              windowClass: 'e-modal tile-show-modal',
              size: 'lg',
              resolve: {
                content: function() { return content; },
                contentType: function() { return type; }
              }
            });
        }

        function incomingRequestAction(action) {
          Restangular.one('users', $scope.notification.user_id).one('relationships', $scope.notification.content.id).customPUT({status: action})
            .then(function(relationship) {
              $scope.notification.content.status = relationship.status;
            });
        }
      }
    }
  });
