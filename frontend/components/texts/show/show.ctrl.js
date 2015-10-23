'use strict';

angular.module('app')
  .controller('TextsShowModalCtrl', function($scope, content, Restangular) {
    $scope.content = content;
    $scope.addNewComment = addNewComment;
    $scope.comments = [];
    getComments();

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getComments() {
      Restangular.one('text', content.id).all('comments').getList()
        .then(function(comments) {
          $scope.comments = comments;
        })
    }
  });
