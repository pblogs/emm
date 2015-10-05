'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, $window, user) {
    $scope.loadTiles = loadTiles;
    $scope.destroyTile = destroyTile;

    $scope.user = user;
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
        enabled: $scope.user.id === $scope.currentUser.id,
        handle: '.drag-handle'
      },
      resizable: {
        enabled: $scope.user.id === $scope.currentUser.id,
        handles: ['e', 's', 'se'],
        stop: function (event, $element, widget) {
          updateTileSize(widget, getTileSize({x: widget.sizeX, y: widget.sizeY}));
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
    
    function loadTiles() {
      $scope.tilesLoader = Restangular.one('users', user.id).all('tiles').toCollection(10, {}, setGridsterTileSize);
    }

    function updateTileSize(tile, size) {
      tile.size = size;
      tile.put()
        .then(function(tileFromServer) {
          _.assign(tile, setGridsterTileSize(tileFromServer));
        });
    }

    function destroyTile(tile) {
      console.log(tile);
      tile.remove()
        .then(function () {
          _.pull($scope.tilesLoader.items, tile);
        });
    }
    
    function setGridsterTileSize(tile) {
      switch (tile.size) {
        case 'small':
          tile.sizeX = 1;
          tile.sizeY = 1;
          break;
        case 'middle':
          tile.sizeX = 2;
          tile.sizeY = 1;
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
      if (sizes.x == 1 && sizes.y == 1) return 'small';
      if (sizes.x == 2 && sizes.y == 1) return 'middle';
      if (sizes.x == 2 && sizes.y == 2) return 'large';
      if (sizes.x == 1 && sizes.y == 2) return 'vertical';
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
