'use strict';

angular.module('app')
.directive('addAlbumBtn', function() {
    return {
      restrict: 'E',
      replace: true,
      template: "<div class='btn e-btn btn-brown' ng-click=createAlbumModal()><div class='fa fa-plus'></div> Add album</div>",
      scope: {
        target: '=',
        albums: '='
      },
      controller: function($scope, MediaModal) {
        $scope.createAlbumModal = createAlbumModal;

        function createAlbumModal() {
          MediaModal('album')
            .result.then(function(album) {
              $scope.albums.push(album);
              $scope.target.album_id = album.id;
            });
        }
      }
    }
  });
