'use strict';

/**
 * Directive for displaying Tile
 */
angular.module('app')
  .directive('tile', function () {
    return {
      restrict: 'E',
      transclude: true,
      replace: true,
      templateUrl: 'directives/tile/tile.html',
      scope: {
        tile: '=',
        editable: '=',
        onRemove: '=',
        user: '='
      },
      controller: function ($scope) {
        $scope.content = $scope.tile.content;
        $scope.getTemplate = 'directives/tile/templates/' + $scope.tile.widget_type + '/' + ($scope.tile.content_type || 'tile') + '.html';
      }
    };
  });
