'use strict';

/**
 * Directive for displaying form field
 */
angular.module('app')
  .directive('eDatepicker', function() {
    return {
      restrict: 'E',
      transclude: true,
      templateUrl: "directives/e-datepicker/e-datepicker.html" ,
      scope: {
        ngModel: "=",
        ngRequired: '='
      }
    };
  });
