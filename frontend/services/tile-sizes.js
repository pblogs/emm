'use strict';

angular.module('app')
  .factory('TileSizes', function () {
    return {
      getGridsterSize: function (sizeName) {
        if (sizeName == 'small') return {sizeX: 1, sizeY: 1};
        if (sizeName == 'middle') return {sizeX: 2, sizeY: 1};
        if (sizeName == 'large') return {sizeX: 2, sizeY: 2};
        if (sizeName == 'vertical') return {sizeX: 1, sizeY: 2};
        return {sizeX: 1, sizeY: 1};
      },

      getServerSize: function (sizeX, sizeY) {
        if (sizeX == 1 && sizeY == 1) return 'small';
        if (sizeX == 2 && sizeY == 1) return 'middle';
        if (sizeX == 2 && sizeY == 2) return 'large';
        if (sizeX == 1 && sizeY == 2) return 'vertical';
        return 'small';
      }
    };
  });
