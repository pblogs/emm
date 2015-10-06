'use strict';

angular.module('app')
  .directive('eSelect', function() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var wrapper = angular.element('<div class="e-select"></div>');
        element.after(wrapper);
        wrapper.prepend(element);
      }
    }
  });
