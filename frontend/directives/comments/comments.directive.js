'use strict';

angular.module('app')
.directive('comments', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/comments/comments.html'
    }
  });
