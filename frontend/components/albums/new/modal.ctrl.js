'use strict';

angular.module('app')
  .controller('AlbumsNewModalCtrl', function($scope, $timeout, CurrentUser, $modalInstance, Notification, Restangular, MediaTypeSelectModal, $state, caller) {
    $scope.submit = submit;
    $scope.changeStep = changeStep;
    $scope.back = back;
    $scope.album = {
      cover: null,
      privacy: 'for_all',
      color: '#b4504e',
      start_date: null,
      end_date: null,
      tagged_users: []
    };
    $scope.privacyList = [{label: 'Public', value: 'for_all'}, {label: 'Friends', value: 'for_friends'}];
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
      $scope.album.replace_tags_attributes = _.map($scope.album.tagged_users, function(user) { return {user_id: user.id}});
      if (_.isObject($scope.album.location)) {
        $scope.album.location_name = $scope.album.location.description;
        $scope.album.latitude = $scope.album.location.latlng.lat();
        $scope.album.longitude = $scope.album.location.latlng.lng();
      }
      Restangular.one('users', CurrentUser.id()).all('albums').post($scope.album)
        .then(function(album) {
          Notification.show('Album "' + $scope.album.title + '" has been created!', 'success');
          $modalInstance.close();
          $state.go('app.user.album', {user_id: album.user.id, album_id: album.id});
        })
        .catch(function(response) {
          $scope.errors = response.data.errors;
          Notification.showValidationErrors(response.data.errors);
        })
    }

    function back() {
      if (caller == 'SelectMediaTypeModal') MediaTypeSelectModal();
      $scope.$close();
    }
  });
