'use strict';

angular.module('app')
  .directive('stopPropagation', function() {
    return {
      restrict: 'A',
      link: function($scope, element, attrs) {
        var event = attrs.event || 'click';

        element.on(event, function(e) {
          e.stopPropagation();
        });
      }
    }
  });
