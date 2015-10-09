'use strict';

angular.module('app')
  .directive('addedByAt', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/added-by-at/added-by-at.html',
      scope: {
        author: '=',
        createdAt: '=?',
        onLinkFollow: '&?'
      }
    }
  });
