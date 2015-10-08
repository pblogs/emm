'use strict';

angular.module('app')
  .directive('colorPicker', function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/color-picker/color-picker.html',
      scope: {
        ngModel: "="
      },
      controller: function($scope) {
        $scope.colors = {
          brown: '#aaa897',
          green: '#579942',
          red: '#b4504e',
          yellow: '#B3B04D',
          blue: '#2F6D6B',
          grey: "#8D8D8D"
        };
        $scope.selectColor = selectColor;
        $scope.colorName = colorName;

        function colorName() {
          return _.capitalize(_.findKey($scope.colors, function(color) {
            return color === $scope.ngModel;
          }));
        }

        function selectColor(color) {
          $scope.ngModel = color;
        }
      }
    }
  });
