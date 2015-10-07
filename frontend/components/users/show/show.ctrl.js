'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, $window, TileSizes, user) {
    $scope.loadTiles = loadTiles;
    $scope.destroyTile = destroyTile;

    $scope.user = user;
    var winSize = getWindowSize();
    var columnsForWindowSize = {lg: 6, md: 5, sm: 4};
    $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;
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
        enabled: $scope.canEditTiles,
        handle: '.drag-handle'
      },
      resizable: {
        enabled: $scope.canEditTiles,
        handles: ['e', 's', 'se'],
        // When resize is finished
        stop: function (event, $element, tile) {
          updateTileSize(tile, TileSizes.getServerSize(tile.sizeX, tile.sizeY));
        }
      }
    };

    loadTiles();

    $scope.$watch(function () {
        return $window.innerWidth;
      },
      function (newVal, oldVal) {
        if (newVal != oldVal) winResizeHandler();
      });

    $scope.$watch('currentUser.id', function (newVal, oldVal) {
      if (newVal != oldVal) {
        $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;
        $scope.gridsterOptions.draggable.enabled = $scope.canEditTiles;
        $scope.gridsterOptions.resizable.enabled = $scope.canEditTiles;
      }
    });
    
    function loadTiles() {
      $scope.tilesLoader = Restangular.one('users', user.id).all('tiles').toCollection(10, {}, gridsterizeTile);
    }

    function updateTileSize(tile, size) {
      var restTile = Restangular.one('users', user.id).one('tiles', tile.id);
      restTile.size = size;
      restTile.put()
        .then(function (tileFromServer) {
          _.assign(tile, gridsterizeTile(tileFromServer));
        });
    }

    function destroyTile(tile) {
      Restangular.one('users', user.id).one('tiles', tile.id).remove()
        .then(function () {
          _.pull($scope.tilesLoader.items, tile);
        });
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
