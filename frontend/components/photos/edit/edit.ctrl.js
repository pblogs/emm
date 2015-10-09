'use strict';

angular.module('app')
  .controller('PhotosEditModalCtrl', function ($scope, Restangular, CurrentUser, Notification, $timeout, content) {
    $scope.photo = _.cloneDeep(content);
    $scope.submit = submit;

    // Display canvas only when modal window is rendered so canvas width could be calculated
    $timeout(function () {
      $scope.showCanvas = true;
    }, 100);

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
      });

    function submit() {
      $scope.errors = {};
      var updateData = Restangular.one('albums', content.album_id).one('photos', $scope.photo.id);
      _.assign(updateData, $scope.photo);
      updateData.put().then(function(response) {
        Notification.show('Photo was successfully updated', 'success');
        $scope.$close(response.plain());
      }).catch(function (response) {
        $scope.errors = response.data.errors;
      });
    }
  });
