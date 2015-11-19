'use strict';

angular.module('app')
  .controller('UsersRelationshipShowCtrl', function($scope, $stateParams, Restangular, Notification, $http, CurrentUser, Background, VisibleUser, user, friend) {
    $scope.getFriends = getFriends;
    $scope.selectFriend = selectFriend;
    $scope.getComments = getComments;
    $scope.addNewComment = addNewComment;
    $scope.pinRecord = pinRecord;
    $scope.user = user;
    $scope.currentUserId = CurrentUser.id();
    $scope.friend = friend;
    $scope.comments = [];
    $scope.relationship = {
      id: $stateParams.relationship_id
    };

    Background.set(user);
    VisibleUser.set(user);
    getFriends($scope.user, 'first');
    getRecords($stateParams.relationship_id);
    getComments($stateParams.relationship_id);

    function getFriends(user, first) {
      $scope.selectedId = user.id;
      $scope.user = user;
      if (!first) {
        $scope.relationship = {};
        $scope.friend = {};
        $scope.recordsLoader = {};
        $scope.comments = [];
      }
      Restangular.one('users', user.id).all('relationships').getList({status: 'friends'})
        .then(function(friends) {
          $scope.userFriends = friends;
        });
    }

    function selectFriend(userFriend) {
      $scope.friend = userFriend;
      $scope.relationship.id = userFriend.relationship_id;
      getRecords($scope.relationship.id);
      getComments($scope.relationship.id);
    }

    function getComments(relationshipId) {
      Restangular.one('relationship', relationshipId).all('comments').getList()
        .then(function(comments) {
         $scope.comments = comments;
        })
    }

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getRecords(relationshipId) {
      $scope.recordsLoader = Restangular.one('relationships', relationshipId).all('records').toCollection(24);
    }

    function pinRecord(record) {
      if (_.isObject(record.tile)) {
        Restangular.one('pages', record.tile.page_id).one('tiles', record.tile.id).remove()
          .then(function() {
            record.tile = null;
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/relationships/' + $scope.relationship.id + '/records/', undefined, {params: {tag_id: record.id}})
          .then(function(response) {
            Notification.show('Selected ' + record.target_type.toLowerCase() + ' was pinned on our profile page.', 'info');
            record.tile = _.result(response.data, 'resource');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }
});
