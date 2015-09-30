'use strict';

/**
 * Directive for displaying form field
 */
angular.module('app')
  .directive('eDatepicker', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: "directives/e-datepicker/e-datepicker.html" ,
      scope: {
        ngModel: "=",
        ngRequired: '=',
        datepickerMode: "="
      }
    };
  });
