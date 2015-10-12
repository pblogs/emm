'use strict';

angular.module('app')
  .directive('imgInput', function () {

    function controller($scope) {
      $scope.removeImage = removeImage;

      $scope.cropper = {
        sourceImage: null,
        bounds: {left: 0, right: 0, top: 0, bottom: 0},
        resultImageSize: {width: 100, height: 100}
      };

      $scope.$watchCollection('cropper.bounds', function () {
        var bounds = $scope.cropper.bounds;
        if (bounds.left == 0 && bounds.right == 0 && bounds.top == 0 && bounds.bottom == 0) return;
        var croppedWidth = bounds.right - bounds.left;
        var croppedHeight = bounds.top - bounds.bottom;
        var ratio = croppedWidth / croppedHeight;
        if (croppedWidth > 1280)
          $scope.cropper.resultImageSize = {width: 1280, height: 1280 / ratio};
        else if (croppedHeight > 1280)
          $scope.cropper.resultImageSize = {width: 1280 * ratio, height: 1280};
        else
          $scope.cropper.resultImageSize = {width: croppedWidth, height: croppedHeight};
      });

      function removeImage() {
        $scope.cropper.sourceImage = null;
        $scope.resultImage = null;
        if ($scope.onRemove) $scope.onRemove();
      }

      $scope.$watch('resultImage', function(newVal, oldVal) {
        if (newVal != oldVal && newVal == null)
          $scope.cropper.sourceImage = null;
      });
    }

    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/img-input/img-input.html',
      scope: {
        resultImage: '=selectedImage',
        height: '=?',
        pictureName: '@?',
        onRemove: '=?',
        keepAspect: '=?'
      },
      controller: controller
    };
  });
