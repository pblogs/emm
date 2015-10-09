'use strict';

angular.module('app')
  .controller('TextsEditModalCtrl', function ($scope, Restangular, CurrentUser, Notification, $state, content) {
    $scope.text = _.cloneDeep(content);
    $scope.submit = submit;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
      });

    function submit() {
      $scope.errors = {};
      var updateData = Restangular.one('albums', content.album_id).one('texts', $scope.text.id);
      _.assign(updateData, $scope.text);
      updateData.put().then(function(response) {
        Notification.show('Text record was successfully updated', 'success');
        $scope.$close(response.plain());
      }).catch(function (response) {
        $scope.errors = response.data.errors;
      });
    }
  });
