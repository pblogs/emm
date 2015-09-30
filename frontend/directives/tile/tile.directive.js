'use strict';

/**
 * Directive for displaying Tile
 */
angular.module('app')
  .directive('tile', function (Restangular) {

    function controller($scope) {
      $scope.content = $scope.tile.content;
    }

    return {
      restrict: 'E',
      replace: true,
      controller: controller,
      templateUrl: 'directives/tile/tile.html',
      scope: {
        tile: '='
      }
    };
  });
