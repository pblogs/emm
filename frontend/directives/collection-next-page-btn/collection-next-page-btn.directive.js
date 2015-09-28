'use strict';

angular.module('app')
  .directive('collectionNextPageBtn', function () {
    return {
      restrict: 'E',
      templateUrl: 'directives/collection-next-page-btn/collection-next-page-btn.html',
      scope: {
        collectionLoader: '=collection',
        emptyText: '@'
      }
    };
  });
