'use strict';

angular.module('app')
  .controller('NewsfeedCtrl', function($scope, Restangular, TileSizes) {
    loadTiles();

    function loadTiles() {
      $scope.newsLoader = Restangular.all('news_feeds').toCollection(24, {}, gridsterizeTile);
    }

    function gridsterizeTile(tile) {
      var gridTile = tile.plain();
      _.assign(gridTile, TileSizes.getGridsterSize(gridTile.size));
      return gridTile;
    }
  });
