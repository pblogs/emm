'use strict';

angular.module('app')
  .controller('UsersTributeCtrl', function($scope, $stateParams, Restangular, user, CurrentUser, tribute) {
    $scope.addNewComment = addNewComment;
    $scope.getComments = getComments;
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
  });
