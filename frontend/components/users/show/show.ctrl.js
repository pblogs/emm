'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, user) {
    $scope.user = user;
    $scope.gridsterOptions = {
      columns: 6,
      minSizeX: 1,
      minSizeY: 1,
      maxSizeX: 2,
      maxSizeY: 2,
      mobileBreakPoint: 749,
      outerMargin: false,
      maxRows: 1000,
      draggable: {
        enabled: $scope.user.id === $scope.currentUser.id
      },
      resizable: {
        enabled: $scope.user.id === $scope.currentUser.id,
        handles: ['e', 's','se'],
        stop: function(event, $element, widget) {
          var updateData = Restangular.one('users', user.id).one('tiles', widget.id);
          updateData.size = getTileSize({x: widget.sizeX, y: widget.sizeY});
          updateData.put();
        }
      }
    };
    $scope.loadTiles = loadTiles;
    loadTiles();

    function loadTiles() {
      $scope.tilesLoader = Restangular.one('users', user.id).all('tiles').toCollection(10, {}, setTileSize);
    }

    function setTileSize(tile) {
      switch (tile.size) {
        case 'small':
          tile.sizeX = 1;
          tile.sizeY = 1;
          break;
        case 'middle':
          tile.sizeX = 1;
          tile.sizeY = 2;
          break;
        case 'large':
          tile.sizeX = 2;
          tile.sizeY = 2;
          break;
        case 'vertical':
          tile.sizeX = 1;
          tile.sizeY = 2;
      }
      return tile;
    }

    function getTileSize(sizes) {
      if (sizes.x == 1 && sizes.y == 1) { return 'small'; }
      if (sizes.x == 2 && sizes.y == 1) { return 'middle'; }
      if (sizes.x == 2 && sizes.y == 2) { return 'large'; }
      if (sizes.x == 1 && sizes.y == 2) { return 'vertical'; }
    }
  });
