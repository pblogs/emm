'use strict';

angular.module('app')
  .controller('UsersTributeCtrl', function($scope, $stateParams, Restangular, $state, Notification, $modal, $http, user, CurrentUser, tribute) {
    $scope.addNewComment = addNewComment;
    $scope.getComments = getComments;
    $scope.removeTribute = removeTribute;
    $scope.pinTribute = pinTribute;
    $scope.editTribute = editTribute;
    $scope.canPinRemoveTribute = user.id == CurrentUser.id();
    $scope.canEditTribute = tribute.author_id == CurrentUser.id();
    $scope.user = user;
    $scope.tribute = tribute;
    $scope.comments = [];

    getComments();

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getComments() {
      Restangular.one('tribute', $scope.tribute.id).all('comments').getList()
        .then(function(comments) {
          $scope.comments = comments;
        })
    }

    function pinTribute() {
      if (_.isObject($scope.tribute.tile)){
        Restangular.one('pages', $scope.tribute.tile.page_id).one('tiles', $scope.tribute.tile.id).remove()
          .then(function() {
            $scope.tribute.tile = null;
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/tribute/' + $scope.tribute.id + '/tiles', {resource: {size: null}})
          .then(function(response) {
            $scope.tribute.tile = response.data.resource;
            Notification.show('Tribute from ' + $scope.tribute.author.first_name + ' ' + $scope.tribute.author.last_name + ' was pinned on your profile page', 'success');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }

    function removeTribute() {
      $scope.tribute.remove()
        .then(function() {
          Notification.show('Tribute from ' + $scope.tribute.author.first_name + ' ' + $scope.tribute.author.last_name + ' was deleted!', 'info');
          $state.go('app.user.tributes', {user_id: CurrentUser.id()});
        })
    }

    function editTribute() {
      $modal
        .open({
          templateUrl: 'components/tributes/edit/edit.html',
          controller: 'TributesEditModalCtrl',
          windowClass: 'e-modal',
          size: 'lg',
          resolve: {
            tribute: function() {
              return tribute;
            },
            user: function() {
              return user;
            }
          }
        }).result.then(function(model) {
          console.log(model);
          _.assign($scope.tribute, model);
        })
    }
  });
