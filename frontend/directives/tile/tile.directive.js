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
      controller: function ($scope, $modal, MediaTypeSelectModal) {
        $scope.content = $scope.tile.content;
        $scope.MediaTypeSelectModal = MediaTypeSelectModal;
        $scope.getTemplate = 'directives/tile/templates/' + $scope.tile.widget_type + '/' + ($scope.tile.content_type || 'tile') + '.html';
        $scope.showTile = showTile;

        function showTile(tile) {
          if (tile.widget_type != 'media' || tile.content_type == 'album' || tile.content_type == 'tribute') return false;
          $modal
            .open({
              templateUrl: 'components/' + tile.content_type + 's/show/show.html',
              controller: 'ShowModalCtrl',
              windowClass: 'e-modal tile-show-modal',
              size: 'lg',
              resolve: {
                content: function() { return tile.content; },
                contentType: function() { return tile.content_type; }
              }
            });
        }
      }
    };
  });
