'use strict';

angular.module('app')
  .directive('imageShow', function() {
    return {
      restrict: "E",
      replace: true,
      templateUrl: "directives/image-show/image-show.html",
      scope: {
        img: '='
      },
      controller: function($scope, $modal) {
        $scope.openImage = openImage;

        function openImage() {
          $modal
            .open({
              templateUrl: 'directives/image-show/modal.html',
              size: 'lg',
              windowClass: 'e-modal image-modal',
              controller: function($scope, img) {
                $scope.img =img;
              },
              resolve: {
                img: function() {
                  return $scope.img;
                }
              }
            })
        }
      }
    }
  });
