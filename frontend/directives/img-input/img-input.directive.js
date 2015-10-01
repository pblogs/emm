'use strict';

angular.module('app')
  .directive('imgInput', function () {

    function controller($scope) {
      $scope.removeImage = removeImage;

      $scope.sourceImage = null;
      $scope.bounds = {left: 0, right: 0, top: 0, bottom: 0};
      $scope.resultImageSize = {width: 100, height: 100};

      $scope.$watchCollection('bounds', function () {
        if ($scope.bounds.left == 0 && $scope.bounds.right == 0 && $scope.bounds.top == 0 && $scope.bounds.bottom == 0) return;
        var croppedWidth = $scope.bounds.right - $scope.bounds.left;
        var croppedHeight = $scope.bounds.top - $scope.bounds.bottom;
        var ratio = croppedWidth / croppedHeight;
        if (croppedWidth > 1280)
          $scope.resultImageSize = {width: 1280, height: 1280 / ratio};
        else if (croppedHeight > 1280)
          $scope.resultImageSize = {width: 1280 * ratio, height: 1280};
        else
          $scope.resultImageSize = {width: croppedWidth, height: croppedHeight};
      });

      function removeImage() {
        $scope.sourceImage = null;
        $scope.croppedImage = null;
      }
    }

    return {
      restrict: 'E',
      transclude: true,
      replace: true,
      templateUrl: 'directives/img-input/img-input.html',
      scope: {
        croppedImage: '=selectedImage',
        height: '=?',
        pictureName: '@?'
      },
      controller: controller
    };
  });
