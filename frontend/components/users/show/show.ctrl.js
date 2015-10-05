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
      draggable: {
        enabled: false
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
          tile.size = {x: 1, y: 1};
          break;
        case 'medium':
          tile.size = {x: 1, y: 2};
          break;
        case 'large':
          tile.size = {x: 2, y: 2};
          break;
      }
      return tile;
    }
  });
