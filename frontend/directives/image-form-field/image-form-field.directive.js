'use strict';

angular.module('app')
  .directive('imageFormField', function () {

    function controller($scope) {
      $scope.removeImage = removeImage;

      var field = $scope.field;
      var fieldUrl = $scope.fieldUrl = $scope.field + '_url';
      var removeField = $scope.removeField = 'remove_' + $scope.field;

      $scope.$watch('object.' + field, function (newVal, oldVal) {
        if (newVal != oldVal && newVal != null) {
          $scope.object[removeField] = null;
        }
      });

      function removeImage() {
        $scope.object[field] = null;
        $scope.object[fieldUrl] = null;
        $scope.object[removeField] = true;
      }
    }

    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/image-form-field/image-form-field.html',
      scope: {
        object: '=',
        field: '@fieldName',
        errors: '=?',
        height: '=?',
        pictureName: '@?',
        keepAspect: '=?'
      },
      controller: controller
    };
  });
