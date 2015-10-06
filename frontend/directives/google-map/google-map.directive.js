'use strict';

angular.module('app')
  .directive('googleMap', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/google-map/google-map.html',
      scope: {
        ngModel: '='
      },
      controller: function($scope) {
        $scope.map = new google.maps.Map(document.getElementById('e-map'), {
          center: {
            lat: 34.0204989,
            lng: -118.4117325
          },
          zoom: 12
        });

        var marker = new google.maps.Marker({
          map: $scope.map
        });

        $scope.$watch('ngModel', function() {
          if ($scope.ngModel) {
            $scope.map.setCenter($scope.ngModel);
            marker.setPosition($scope.ngModel);
          }
        })
      }
    }
  });
