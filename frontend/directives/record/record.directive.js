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
        $scope.getTemplate = 'directives/record/templates/' + $scope.record.content_type + '.html';
        $scope.getColor = getColor;
        $scope.showRecord = showRecord;

        function showRecord(record) {
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
