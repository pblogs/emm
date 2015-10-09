'use strict';

angular.module('app')
  .controller('TextsNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $state, caller) {
    $scope.text = {};
    $scope.submit = submit;
    $scope.back = back;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
        $scope.text.album_id = albums[0].id;
      });

    function submit() {
      $scope.errors = {};
      Restangular.one('albums', $scope.text.album_id).all('texts').post($scope.text)
        .then(function (text) {
          Notification.show('Text record was successfully added', 'success');
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
