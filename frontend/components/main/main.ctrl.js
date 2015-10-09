'use strict';

angular.module('app').controller('MainCtrl', function ($scope, Restangular, TileSizes) {
  $scope.loadTiles = loadTiles;

  loadTiles();

  function loadTiles() {
    $scope.tilesLoader = Restangular.all('main_page').toCollection(24, {}, gridsterizeTile);
  }

  function gridsterizeTile(tile) {
    var gridTile = tile.plain();
    _.assign(gridTile, TileSizes.getGridsterSize(gridTile.size));
    return gridTile;
  }
});
