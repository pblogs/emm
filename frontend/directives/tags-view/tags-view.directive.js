'use strict';

angular.module('app')
  .directive('tagsView', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/tags-view/tags-view.html',
      scope: {
        targetId: "=",
        targetType: "@",
        onLinkFollow: "&?"
      },
      controller: function($scope, Restangular) {
        $scope.tags = [];
        Restangular.one($scope.targetType+'s', $scope.targetId).all('tags').getList()
          .then(function(tags) {
            $scope.tags = tags;
          })
      }
    }
  });
