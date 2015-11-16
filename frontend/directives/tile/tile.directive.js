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
      controller: function ($scope, $modal, MediaTypeSelectModal, CurrentUser, Restangular) {
        $scope.showTile = showTile;
        $scope.sendRelationshipRequest = sendRelationshipRequest;
        $scope.currentUserId = CurrentUser.id();
        $scope.content = $scope.tile.content;
        $scope.MediaTypeSelectModal = MediaTypeSelectModal;
        $scope.getTemplate = 'directives/tile/templates/' + $scope.tile.widget_type + '/' + ($scope.tile.content_type || 'tile') + '.html';

        function showTile(tile) {
          if (tile.widget_type != 'media' || _.include(['album', 'tribute', 'relationship'], tile.content_type)) return false;
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

        function sendRelationshipRequest(id, type) {
          Restangular.one('users', id).all('relationships').post()
            .then(function(resource) {
              $scope.tile.content.relations_with_current_user['relation_with_' + type] = resource.status
            })
        }
      }
    };
  });
