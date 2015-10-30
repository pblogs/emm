'use strict';

angular.module('app')
  .controller('VideosEditModalCtrl', function ($scope, Restangular, CurrentUser, Notification, $timeout, content) {
    $scope.video = _.cloneDeep(content);
    $scope.submit = submit;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
      });

    Restangular.one('videos', content.id).all('tags').getList()
      .then(function(tags) {
        $scope.video.tagged_users = _.pluck(tags, 'user');
      });

    function submit() {
      $scope.errors = {};
      $scope.video.replace_tags_attributes = _.map($scope.video.tagged_users, function(user) { return {user_id: user.id}});
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
