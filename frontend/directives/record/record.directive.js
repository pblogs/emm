'use strict';

angular.module('app')
  .directive('record', function() {
    return {
      restrict: 'E',
      replace: 'true',
      templateUrl: 'directives/record/record.html',
      scope: {
        record: "=",
        canEdit:"=",
        onEdit: '=?',
        onRemove: "=?",
        onPin: "=?",
        color: "="
      },
      controller: function($scope, $modal) {
        $scope.getColor = getColor;
        $scope.showRecord = showRecord;
        if ($scope.record.target_type) {
          $scope.record.content = $scope.record.target;
          $scope.record.content_type = $scope.record.target_type.toLowerCase();
        }
        $scope.getTemplate = 'directives/record/templates/' + $scope.record.content_type + '.html';

        function showRecord(record) {
          if (record.content_type == 'album') return false;
          $modal
            .open({
              templateUrl: 'components/' + record.content_type + 's/show/show.html',
              controller: 'ShowModalCtrl',
              windowClass: 'e-modal record-show-modal',
              size: 'lg',
              resolve: {
                content: function() { return record.content; },
                contentType: function() { return record.content_type; }
              }
            });
        }

        function getColor() {
          if (_.isObject($scope.record.content.tile)) return {color: $scope.color || '#b4504e'};
        }
      }
    }
  });
