'use strict';

/**
 * Directive for displaying form field
 */
angular.module('app')
  .directive('eDescription', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: "directives/e-description/e-description.html",
      scope: {
        ngModel: '=',
        errors: '='
      }
    }
  });
