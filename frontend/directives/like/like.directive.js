'use strict';

angular.module('app')
  .directive('like', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/like/like.html'
    }
  });
