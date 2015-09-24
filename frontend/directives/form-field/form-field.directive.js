'use strict';

/**
 * Directive for displaying form field
 */
angular.module('app')
  .directive('formField', function() {
    return {
      restrict: 'E',
      transclude: true,
      templateUrl: function(elem, attr) {
        var template = attr.type ? 'input' : 'textarea';
        return 'directives/form-field/' + template + '.html';
      },
      scope: {
        type: '@',
        ngModel: "=",
        errors: '=',
        ngRequired: '=',
        placeholder: '@'
      }
    };
  });
