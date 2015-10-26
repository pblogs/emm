'use strict';

angular.module('app')
  .directive('ngClickConfirm', function() {
    return {
      restrict: 'A',
      controller: function($scope, $modal) {
        $scope.showModal = showModal;
        function showModal() {
          return $modal
            .open({
              templateUrl: 'directives/confirm-modal/confirm-modal.html',
              size: 'xs',
              windowClass: 'e-modal'
            });
        }
      },
      link:  function(scope, element, attrs) {
        element.bind('click', function() {
          scope.showModal().result.then(function() {
            scope.$eval(attrs.ngClickConfirm);
          });
        });
      }
    }
  });
