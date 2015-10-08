'use strict';

angular.module('app')
  .controller('AlbumsNewModalCtrl', function($scope, $timeout, CurrentUser, $modalInstance, Notification, Restangular, MediaTypeSelectModal, $state, caller) {
    $scope.submit = submit;
    $scope.changeStep = changeStep;
    $scope.back = back;
    $scope.step = 'components/albums/new/step1.html';
    $scope.album = {
      cover: null,
      privacy: 'for_all',
      color: '#b4504e',
      start_date: null,
      end_date: null
    };
    $scope.privacyList = [{label: 'Public', value: 'for_all'}, {label: 'Friends', value: 'for_friends'}];
    Restangular.all('users').getList().then(function(users) {
      $scope.users = users;
    });

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function() {
      $scope.showCanvas = true;
    }, 100);

    function changeStep(i) {
      $scope.step = 'components/albums/new/step' + i + '.html';
    }

    function submit() {
      $scope.errors = {};
      if (_.isObject($scope.album.location)) {
        $scope.album.location_name = $scope.album.location.description;
        $scope.album.latitude = $scope.album.location.latlng.lat();
        $scope.album.longitude = $scope.album.location.latlng.lng();
      }
      Restangular.one('users', CurrentUser.id()).all('albums').post($scope.album)
        .then(function() {
          Notification.show('Album "' + $scope.album.title + '" has been created!', 'success');
          $modalInstance.close();
          $state.go('app.user.show', {userId: CurrentUser.id()}, {reload: true});
        })
        .catch(function(response) {
          Notification.showValidationErrors(response.data.errors);
        })
    }

    function back() {
      if (caller == 'SelectMediaTypeModal') MediaTypeSelectModal();
      $scope.$close();
    }
  });
