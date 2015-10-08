'use strict';

angular.module('app')
  .directive('tileShowAdditional', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/tile-show-additional/tile-show-additional.html'
    }
  });
