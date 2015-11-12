'use strict';

angular.module('app')
  .directive('grid', function ($window, WindowSize) {

    function controller($scope) {
      var winSize = WindowSize.get();
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
          enabled: $scope.editable,
          handle: '.drag-handle',
          // When dragging is finished
          stop: function (event, $element, tile) {
            if (tile.widget_type == 'content-tooltip') return;
            if ($scope.onResize) $scope.onResize(tile);
          }
        },
        resizable: {
          enabled: $scope.editable,
          // When resize is finished
          stop: function (event, $element, tile) {
            if (tile.widget_type == 'content-tooltip') return;
            if ($scope.onResize) $scope.onResize(tile);
          }
        }
      };

      $scope.$watch('editable', function (newVal, oldVal) {
        if (newVal != oldVal) {
          $scope.gridsterOptions.draggable.enabled = $scope.editable;
          $scope.gridsterOptions.resizable.enabled = $scope.editable;
        }
      });

      $scope.$watch(function () {
          return $window.innerWidth;
        },
        function (newVal, oldVal) {
          if (newVal != oldVal) winResizeHandler();
        });

      function winResizeHandler() {
        var newSize = WindowSize.get();
        if (winSize != newSize) {
          winSize = newSize;
          var tiles = _.cloneDeep($scope.tiles);
          _.forEach(tiles, function (tile) {
            if (tile.screen_size != WindowSize.get()) {
              tile.row = undefined;
              tile.col = undefined;
            }
          });
          $scope.tiles = [];
          $scope.gridsterOptions.columns = columnsForWindowSize[winSize];
          $scope.$applyAsync(function () {
            $scope.tiles = tiles;
          });
        }
      }
    }

    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/grid/grid.html',
      scope: {
        tiles: '=',
        editable: '=',   // Is it allowed to resize, drag and remove tiles
        onResize: '=?',  // Required if editable == true
        onEdit: '=?', // Required if editable == true
        onReorder: '=?', // Required if editable == true
        onRemove: '=?',  // Required if editable == true
        user: '=?'       // User to display on avatar/info tiles
      },
      controller: controller
    };
  });
