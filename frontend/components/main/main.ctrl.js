'use strict';

angular.module('app').controller('MainCtrl', function ($scope, Restangular, $window, TileSizes) {
  $scope.loadTiles = loadTiles;

  var winSize = getWindowSize();
  var columnsForWindowSize = {lg: 6, md: 5, sm: 4};
  $scope.gridsterOptions = {
    columns: columnsForWindowSize[winSize],
    minSizeX: 1,
    minSizeY: 1,
    maxSizeX: 2,
    maxSizeY: 2,
    mobileBreakPoint: 719,
    outerMargin: false,
    maxRows: 1000,
    draggable: {
      enabled: false,
      handle: '.drag-handle'
    },
    resizable: false
  };

  loadTiles();

  $scope.$watch(function () {
      return $window.innerWidth;
    },
    function (newVal, oldVal) {
      if (newVal != oldVal) winResizeHandler();
    });


  function loadTiles() {
    //('retailers').getList(params)
    $scope.tilesLoader = Restangular.all('main_page').toCollection(10, {}, gridsterizeTile);
  }

  function gridsterizeTile(tile) {
    var gridTile = tile.plain();
    _.assign(gridTile, TileSizes.getGridsterSize(gridTile.size));
    return gridTile;
  }

  function winResizeHandler() {
    var newSize = getWindowSize();
    if (winSize != newSize) {
      winSize = newSize;
      var tiles = _.cloneDeep($scope.tilesLoader.items);
      _.forEach(tiles, function (e) {
        e.row = undefined;
        e.col = undefined;
      });
      $scope.tilesLoader.items = [];
      $scope.gridsterOptions.columns = columnsForWindowSize[winSize];
      $scope.$applyAsync(function () {
        $scope.tilesLoader.items = tiles;
      });
    }
  }

  function getWindowSize() {
    if ($window.innerWidth >= 1200) return 'lg';
    if ($window.innerWidth >= 992 && $window.innerWidth <= 1999) return 'md';
    if ($window.innerWidth <= 991) return 'sm';
  }
});
