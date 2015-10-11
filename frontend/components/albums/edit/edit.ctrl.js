'use strict';

angular.module('app')
  .controller('AlbumsEditModalCtrl', function($scope, $timeout, CurrentUser, Notification, Restangular, content) {
    $scope.submit = submit;
    $scope.changeStep = changeStep;
    $scope.step = 'components/albums/new/step1.html';
    $scope.album = _.cloneDeep(content);
    $scope.privacyList = [{label: 'Public', value: 'for_all'}, {label: 'Friends', value: 'for_friends'}];
    if ($scope.album.location_name) $scope.album.location = { description: $scope.album.location_name };
    Restangular.all('users').getList().then(function(users) {
      $scope.users = users;
    });

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function() {
      $scope.showCanvas = true;
    }, 100);

    changeStep(1);

    function changeStep(i) {
      $scope.step = i;
    }

    function submit() {
      $scope.errors = {};
      if (_.isObject($scope.album.location)) {
        $scope.album.location_name = $scope.album.location.description;
        $scope.album.latitude = $scope.album.location.latlng.lat();
        $scope.album.longitude = $scope.album.location.latlng.lng();
      }
      var updateData = Restangular.one('users', CurrentUser.id()).one('albums', content.id);
      _.assign(updateData, $scope.album);
      updateData.put().then(function(response) {
        Notification.show('Album was successfully updated', 'success');
        $scope.$close(response.plain());
      }).catch(function (response) {
        $scope.errors = response.data.errors;
      });
    }
  });
