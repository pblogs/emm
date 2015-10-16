'use strict';

angular.module('app')
  .controller('VideosEditModalCtrl', function ($scope, Restangular, CurrentUser, Notification, $timeout, content) {
    $scope.video = _.cloneDeep(content);
    $scope.submit = submit;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
      });

    function submit() {
      $scope.errors = {};
      var updateData = Restangular.one('albums', content.album_id).one('videos', $scope.video.id);
      _.assign(updateData, $scope.video);
      updateData.put()
        .then(function (response) {
          Notification.show('Video was successfully updated', 'success');
          $scope.$close(response.plain());
        })
        .catch(function (response) {
          $scope.errors = response.data.errors;
        });
    }
  });
