'use strict';

angular.module('app')
  .controller('VideosShowModalCtrl', function($scope, content, Restangular) {
    $scope.comments = [];
    $scope.content = content;
    $scope.addNewComment = addNewComment;
    getComments();

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getComments() {
      Restangular.one('video', content.id).all('comments').getList()
        .then(function(comments) {
          $scope.comments = comments;
        })
    }
  });
