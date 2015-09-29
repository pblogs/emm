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
      $scope.tilesLoader = Restangular.one('users', user.id).all('tiles').toCollection(10);
    }

    $scope.getTileSize = function(tile) {
      switch (tile.size) {
        case "small" :
          return {x: 1, y: 1};
          break;
        case "medium" :
          return {x: 1, y: 2};
          break;
        case "large" :
          return {x: 2, y: 2};
          break;
      }
    }
  });
