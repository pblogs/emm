'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, $window, TileSizes, user) {
    $scope.loadPage = loadPage;
    $scope.destroyTile = destroyTile;

    $scope.user = user;
    $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;

    $scope.$watch('currentUser.id', function (newVal, oldVal) {
      if (newVal != oldVal) {
        $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;
        $scope.gridsterOptions.draggable.enabled = $scope.canEditTiles;
        $scope.gridsterOptions.resizable.enabled = $scope.canEditTiles;
      }
    });

    loadPages();

    function loadPages() {
      Restangular.one('users', user.id).all('pages').getList()
        .then(function (pages) {
          $scope.pages = pages;
          loadPage(pages[0]);
        });
    }

    function loadPage(page) {
      Restangular.one('users', user.id).one('pages', page.id).get()
        .then(function (pageFromServer) {
          _.forEach(pageFromServer.tiles, gridsterizeTile);
          $scope.currentPage = pageFromServer;
        });
    }

    function gridsterizeTile(tile) {
      tile.sizeX = TileSizes.getGridsterSize(tile.size).sizeX;
      tile.sizeY = TileSizes.getGridsterSize(tile.size).sizeY;
      return tile;
    }

    function serverizeTile(tile) {
      tile.size = TileSizes.getServerSize(tile.sizeX, tile.sizeY);
      return tile;
    }

    function updateTiles() {
      _.forEach($scope.currentPage.tiles, serverizeTile);
      $scope.currentPage.customPUT(null, 'update_tiles', {screen_size: getWindowSize()})
        .then(function (pageFromServer) {
          _.forEach(pageFromServer.tiles, gridsterizeTile);
          $scope.currentPage = pageFromServer;
        });
    }

    function destroyTile(tile) {
      Restangular.one('pages', tile.page_id).one('tiles', tile.id).remove()
        .then(function () {
          _.pull($scope.currentPage.tiles, tile);
        });
    }

    // TODO: Move code below into "grid" directive

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
        enabled: $scope.canEditTiles,
        handle: '.drag-handle',
        stop: updateTiles // When dragging is finished
      },
      resizable: {
        enabled: $scope.canEditTiles,
        stop: updateTiles // When resize is finished
      }
    };

    $scope.$watch(function () {
        return $window.innerWidth;
      },
      function (newVal, oldVal) {
        if (newVal != oldVal) winResizeHandler();
      });

    function winResizeHandler() {
      var newSize = getWindowSize();
      if (winSize != newSize) {
        winSize = newSize;
        var tiles = _.cloneDeep($scope.currentPage.tiles);
        _.forEach(tiles, function (e) {
          e.row = undefined;
          e.col = undefined;
        });
        $scope.currentPage.tiles = [];
        $scope.gridsterOptions.columns = columnsForWindowSize[winSize];
        $scope.$applyAsync(function () {
          $scope.currentPage.tiles = tiles;
        });
      }
    }

    function getWindowSize() {
      if ($window.innerWidth >= 1200) return 'lg';
      if ($window.innerWidth >= 992 && $window.innerWidth <= 1999) return 'md';
      if ($window.innerWidth <= 991) return 'sm';
    }
  });
