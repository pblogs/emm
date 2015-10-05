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
      resizable: {
        stop: function(event, $element, widget) {
          console.log(widget);
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
        case 'medium':
          tile.sizeX = 1;
          tile.sizeY = 2;
          break;
        case 'large':
          tile.sizeX = 2;
          tile.sizeY = 2;
          break;
      }
      return tile;
    }
  });
