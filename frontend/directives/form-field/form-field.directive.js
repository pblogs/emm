'use strict';

/**
 * Directive for displaying form field
 */
angular.module('app')
  .directive('formField', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: function(elem, attr) {
        var templateName = _.include(['textarea', 'datepicker'], attr.type) ? attr.type : 'text';
        return 'directives/form-field/' + templateName + '.html';
      },
      scope: {
        type: '@',
        ngModel: "=",
        errors: '=',
        ngRequired: '=',
        placeholder: '@',
        rows: '=',
        maxlength: '=',
        cols: '='
      }
    };
  });
