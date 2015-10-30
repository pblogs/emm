'use strict';

angular.module('app')
  .controller('TextsEditModalCtrl', function ($scope, Restangular, CurrentUser, Notification, $state, content) {
    $scope.text = _.cloneDeep(content);
    $scope.submit = submit;

    Restangular.one('users', CurrentUser.id()).all('albums').getList()
      .then(function (albums) {
        $scope.albums = albums;
      });

    Restangular.one('texts', content.id).all('tags').getList()
      .then(function(tags) {
        $scope.text.tagged_users =  _.pluck(tags, 'user');
      });

    function submit() {
      $scope.errors = {};
      $scope.text.replace_tags_attributes = _.map($scope.text.tagged_users, function(user) { return {user_id: user.id}});
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
