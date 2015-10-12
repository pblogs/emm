'use strict';

angular.module('app')
  .controller('TextsNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $state, $rootScope, caller) {
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
          if (text.tile) {
            if ($state.includes('app.user.show', {user_id: text.user.id})) {
              $rootScope.$broadcast('tileAdded', _.merge(text.tile, {content: text.plain()}));
            }
            else {
              $state.go('app.user.show', {user_id: text.user.id, page_id: text.tile.page_id});
            }
          }
          //else if (text.record) { go to album and show the record }
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
