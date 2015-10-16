'use strict';

angular.module('app')
  .controller('VideosNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $timeout, $state, $rootScope, caller) {
    $scope.video = {};
    $scope.submit = submit;
    $scope.back = back;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
        $scope.video.album_id = $state.params.user_id == CurrentUser.id() && $state.params.album_id ? $state.params.album_id : albums[0].id;
      });

    function submit() {
      $scope.errors = {};
      Restangular.one('albums', $scope.video.album_id).all('videos').post($scope.video)
        .then(function (video) {
          Notification.show('Video was successfully added', 'success');
          $scope.$close();
          if (video.tile) {
            if ($state.includes('app.user.show', {user_id: video.user.id})) {
              $rootScope.$broadcast('tileAdded', _.merge(video.tile, {content: video.plain()}));
            }
            else {
              $state.go('app.user.show', {user_id: video.user.id, page_id: video.tile.page_id});
            }
          } else  if ($state.includes('app.user.album', {user_id: video.user.id, album_id: video.album_id})) {
            $rootScope.$broadcast('recordAdded', _.merge(video.record, {content: video.plain()}));
          } else {
            $state.go('app.user.album', {user_id: video.user.id, album_id: video.album_id});
          }
        })
        .catch(function (response) {
          $scope.errors = response.data.errors;
        });
    }

    function back() {
      if (caller == 'SelectMediaTypeModal') MediaTypeSelectModal();
      $scope.$close();
    }
  });