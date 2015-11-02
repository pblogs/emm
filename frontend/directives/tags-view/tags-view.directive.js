'use strict';

angular.module('app')
  .directive('tagsView', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/tags-view/tags-view.html',
      scope: {
        tags: "=",
        onLinkFollow: "&?"
      }
    }
  });
