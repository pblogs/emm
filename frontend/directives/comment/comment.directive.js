'use strict';

angular.module('app')
  .directive('comment', function() {
    return {
      restrict: 'E',
      replace: 'true',
      templateUrl: "directives/comment/comment.html",
      scope: {
        comment: '=',
        onLinkFollow: '&?'
      }
    }
  });
