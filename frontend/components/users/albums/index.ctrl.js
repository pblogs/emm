'use strict';

angular.module('app')
  .controller('UsersAlbumsCtrl', function($scope, Restangular, Notification, $http, user) {
    $scope.albums = [];
    $scope.user = user;
    $scope.canEditAlbum = $scope.user.id === $scope.currentUser.id;
    $scope.removeAlbum = removeAlbum;
    $scope.pinAlbum = pinAlbum;
    $scope.getPinColor = getPinColor;

    getAlbumsList();

    function getAlbumsList() {
      Restangular.one('users', user.id).all('albums').getList().then(function(albums) {
        $scope.albums = albums;
      })
    }

    function getPinColor(album) {
      if (album.tile) {
        return {'color': album.color || '#b4504e'}
      }
    }

    function removeAlbum(album) {
      album.remove()
        .then(function() {
          _.pull($scope.albums, album);
          Notification.show('Album "' + album.title + '" was removed!', 'info');
        })
        .catch(function(response) {
          Notification.showValidationErrors(response.data.errors);
        });
    }

    function pinAlbum(album) {
      if (_.isObject(album.tile)) {
        Restangular.one('pages', album.tile.page_id).one('tiles', album.tile.id).remove()
          .then(function() {
            album.tile = null;
            Notification.show('Album "' + album.title + '" was removed from your profile page', 'info');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/album/' + album.id + '/tiles', {resource: {size: null}})
          .then(function(response) {
            album.tile = response.data.resource;
            Notification.show('Album "' + album.title + '" was pinned on your profile page', 'success');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }
  });
