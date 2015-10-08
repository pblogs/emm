'use strict';

angular.module('app')
  .controller('TextsShowModalCtrl', function($scope, content) {
    $scope.content = content;
  });
