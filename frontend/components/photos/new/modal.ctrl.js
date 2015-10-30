'use strict';

angular.module('app')
  .controller('PhotosNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $timeout, $state, $rootScope, caller) {
    $scope.photo = {
      image: null,
      tagged_users: []
    };
    $scope.submit = submit;
    $scope.back = back;

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function () {
      $scope.showCanvas = true;
    }, 100);

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
        $scope.photo.album_id = $state.params.user_id == CurrentUser.id() && $state.params.album_id ? $state.params.album_id : albums[0].id;
      });

    function submit() {
      $scope.errors = {};
      $scope.photo.replace_tags_attributes = _.map($scope.photo.tagged_users, function(user) { return {user_id: user.id}});
      Restangular.one('albums', $scope.photo.album_id).all('photos').post($scope.photo)
        .then(function (photo) {
          Notification.show('Photo was successfully added', 'success');
          $scope.$close();
          if (photo.tile) {
            if ($state.includes('app.user.show', {user_id: photo.user.id})) {
              $rootScope.$broadcast('tileAdded', _.merge(photo.tile, {content: photo.plain()}));
            }
            else {
              $state.go('app.user.show', {user_id: photo.user.id, page_id: photo.tile.page_id});
            }
          } else  if ($state.includes('app.user.album', {user_id: photo.user.id, album_id: photo.album_id})) {
            $rootScope.$broadcast('recordAdded', _.merge(photo.record, {content: photo.plain()}));
          } else {
            $state.go('app.user.album', {user_id: photo.user.id, album_id: photo.album_id});
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
