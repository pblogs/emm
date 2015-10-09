'use strict';

/**
 * Directive for displaying Tile
 */
angular.module('app')
  .directive('tile', function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/tile/tile.html',
      scope: {
        tile: '=',
        editable: '=',
        onEdit: '=',
        onRemove: '=',
        user: '='
      },
      controller: function ($scope, $modal) {
        $scope.content = $scope.tile.content;
        $scope.getTemplate = 'directives/tile/templates/' + $scope.tile.widget_type + '/' + ($scope.tile.content_type || 'tile') + '.html';
        $scope.showTile = showTile;

        function showTile(tile) {
          if (tile.widget_type != 'media') return false;
          $modal
            .open({
              templateUrl: 'components/' + tile.content_type + 's/show/show.html',
              controller: _.capitalize(tile.content_type) + 'sShowModalCtrl',
              windowClass: 'e-modal tile-show-modal',
              size: 'lg',
              resolve: {
                content: function() {
                  return tile.content;
                }
              }
            })
        }
      }
    };
  });
