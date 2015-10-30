'use strict';

angular.module('app')
  .controller('TextsNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $state, $rootScope, caller) {
    $scope.text = {
      tagged_users: []
    };
    $scope.submit = submit;
    $scope.back = back;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
        $scope.text.album_id = $state.params.user_id == CurrentUser.id() && $state.params.album_id ? $state.params.album_id : albums[0].id;
      });

    function submit() {
      $scope.errors = {};
      $scope.text.replace_tags_attributes = _.map($scope.text.tagged_users, function(user) { return {user_id: user.id}});
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
          } else  if ($state.includes('app.user.album', {user_id: text.user.id, album_id: text.album_id})) {
            $rootScope.$broadcast('recordAdded', _.merge(text.record, {content: text.plain()}));
          } else {
            $state.go('app.user.album', {user_id: text.user.id, album_id: text.album_id});
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
