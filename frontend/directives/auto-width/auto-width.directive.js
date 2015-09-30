'use strict';

/**
 * Directive for displaying Tile
 */
angular.module('app')
  .directive('autoWidth', function ($window) {
    return {
      restrict: 'A',
      link: function (scope, element, attrs) {
        function resizeCanvas() {
          element[0].width = element.parent()[0].clientWidth;
        }

        resizeCanvas();

        if (attrs.watchResize == 'true') {
          var win = angular.element($window);
          win.on('resize', _.debounce(resizeCanvas, 500));
          scope.$destroy(function () {
            win.off('resize');
          });
        }
      }
    };
  });
