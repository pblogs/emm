'use strict';

angular.module('app')
.directive('locationSearch', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/location-search/location-search.html',
      scope: {
        ngModel: '='
      },
      controller: function($scope, $q, Notification) {
        $scope.getLocation = getLocation;
        var geocoder = new google.maps.Geocoder();

        function getLocation(search) {
          var addressesService = new google.maps.places.AutocompleteService(),
            request = {input: search},
            deferred = $q.defer();
          addressesService.getPlacePredictions(request, function (addresses) {
            deferred.resolve(addresses);
          });
          return deferred.promise;
        }

        $scope.$watch('ngModel', function() {
          if (_.isObject($scope.ngModel)) geocodeAddress();
        });

        function geocodeAddress() {
          geocoder.geocode({'address': $scope.ngModel.description}, function(results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
              $scope.ngModel.latlng = results[0].geometry.location;
              $scope.$apply();
            } else {
              Notification.show('Something wrong', 'danger')
            }
          });
        }
      }
    }
  });
