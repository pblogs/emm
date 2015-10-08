'use strict';

angular.module('app')
  .controller('PhotosNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $timeout, $state, caller) {
    $scope.photo = {image: null};
    $scope.submit = submit;
    $scope.back = back;

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function () {
      $scope.showCanvas = true;
    }, 100);

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
        $scope.photo.album_id = albums[0].id.toString();
      });

    function submit() {
      $scope.errors = {};
      Restangular.one('albums', $scope.photo.album_id).all('photos').post($scope.photo)
        .then(function (photo) {
          Notification.show('Photo was successfully added', 'success');
          $scope.$close();
          $state.go('app.user.show', {userId: CurrentUser.id()}, {reload: true});
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
