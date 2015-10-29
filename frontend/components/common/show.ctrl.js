'use strict';

angular.module('app')
  .controller('ShowModalCtrl', function($scope, content, Restangular, contentType) {
    $scope.comments = [];
    $scope.content = content;
    $scope.contentType = contentType;
    $scope.addNewComment = addNewComment;
    getComments();

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getComments() {
      Restangular.one(contentType, content.id).all('comments').getList()
        .then(function(comments) {
          $scope.comments = comments;
        })
    }
  });
