'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, WindowSize, TileSizes, $state, $location, $modal, Handle404, user) {
    $scope.loadPage = loadPage;
    $scope.editTile = editTile;
    $scope.updateTiles = updateTiles;
    $scope.destroyTile = destroyTile;

    $scope.user = user;
    $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;

    $scope.$watch('currentUser.id', function (newVal, oldVal) {
      if (newVal != oldVal)
        $scope.canEditTiles = $scope.user.id === $scope.currentUser.id;
    });

    loadPages();

    function loadPages() {
      Restangular.one('users', user.id).all('pages').getList()
        .then(function (pages) {
          $scope.pages = pages;
          if ($state.params.page) {
            var pageToLoad = pages[$state.params.page - 1]; // zero-based pages array
            pageToLoad == null ? Handle404() : loadPage(pageToLoad);
          }
          else loadPage(pages[0]);
        });
    }

    function loadPage(page) {
      Restangular.one('users', user.id).one('pages', page.id).get()
        .then(function (pageFromServer) {
          _.forEach(pageFromServer.tiles, gridsterizeTile);
          $scope.currentPage = pageFromServer;
          var pageIdx = _.findIndex($scope.pages, {id: pageFromServer.id});
          $location.search('page', pageIdx > 0 ? pageIdx + 1 : null);
        });
    }

    function editTile(tile) {
      $modal
        .open({
          templateUrl: 'components/' + tile.content_type + 's/new/modal.html',
          controller: _.capitalize(tile.content_type) + 'sEditModalCtrl',
          windowClass: 'e-modal',
          size: 'lg',
          resolve: {
            content: function () {
              return tile.content;
            }
          }
        }).result.then(function (response) {
          _.assign(tile.content, response);
        })
    }

    function updateTiles() {
      _.forEach($scope.currentPage.tiles, serverizeTile);
      $scope.currentPage.customPUT(null, 'update_tiles', {screen_size: WindowSize.get()})
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

    function gridsterizeTile(tile) {
      tile.sizeX = TileSizes.getGridsterSize(tile.size).sizeX;
      tile.sizeY = TileSizes.getGridsterSize(tile.size).sizeY;
      if (tile.screen_size != WindowSize.get()) {
        tile.row = undefined;
        tile.col = undefined;
      }
      return tile;
    }

    function serverizeTile(tile) {
      tile.size = TileSizes.getServerSize(tile.sizeX, tile.sizeY);
      return tile;
    }
  });
