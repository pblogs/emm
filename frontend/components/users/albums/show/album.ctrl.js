'use strict';

angular.module('app')
  .controller('UserAlbumCtrl', function($scope, Restangular, $stateParams, $modal, Notification, $state, $http, MediaModal, album, user) {
    $scope.updateWeights = updateWeights;
    $scope.editRecord = editRecord;
    $scope.pinAlbum = pinAlbum;
    $scope.pinRecord = pinRecord;
    $scope.removeRecord = removeRecord;
    $scope.getPinColor = getPinColor;
    $scope.editAlbum = editAlbum;
    $scope.removeAlbum = removeAlbum;
    $scope.addNewComment = addNewComment;
    $scope.openMediaPopup = openMediaPopup;
    $scope.user = user;
    $scope.album = album;
    $scope.canEditAlbum = user.id == $scope.currentUser.id;
    $scope.comments = [];
    getRecords();
    getComments();

    $scope.$on('recordAdded', function (event, record) {
      if ($scope.recordsLoader.allReceived) {
        $scope.recordsLoader.items.push(record);
        $scope.album.records_count++;
      } else {
        $scope.album.records_count++;
      }
    });

    function openMediaPopup(mediaType) {
      MediaModal(mediaType, {caller: 'SelectMediaTypeModal'});
    }

    function addNewComment(comment) {
      $scope.comments.push(comment);
    }

    function getComments() {
      Restangular.one('album', $scope.album.id).all('comments').getList()
        .then(function(comments) {
          $scope.comments = comments;
        })
    }
    
    function updateWeights($item, $partFrom, $partTo, $indexFrom, $indexTo) {
      var changesArray = [$indexFrom, $indexTo],
        updateArray = _.slice($scope.recordsLoader.items , _.min(changesArray), _.max(changesArray) + 1),
        weights = _.pluck(updateArray, 'weight');
      _.forEach(updateArray, function(record) {
        record.weight = _.min(weights);
        _.pull(weights, record.weight);
      });
      $http.put($scope.album.getRestangularUrl() + '/update_records', {resource: {records: updateArray}})
    }

    function getRecords() {
      $scope.recordsLoader = Restangular.one('albums', $scope.album.id).all('records').toCollection(20);
    }

    function editRecord(record) {
      $modal
        .open({
          templateUrl: 'components/' + record.content_type + 's/new/modal.html',
          controller: _.capitalize(record.content_type) + 'sEditModalCtrl',
          windowClass: 'e-modal',
          size: 'lg',
          resolve: {
            content: function() {
              return record.content;
            }
          }
        }).result.then(function(response) {
          _.assign(record.content, response);
        })
    }

    function pinRecord(record) {
      if (_.isObject(record.content.tile)) {
        Restangular.one('pages', record.content.tile.page_id).one('tiles', record.content.tile.id).remove()
          .then(function() {
            record.content.tile = null;
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/' + record.content_type + '/' + record.content.id + '/tiles', {resource: {size: null}})
          .then(function(response) {
            record.content.tile = response.data.resource;
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }

    function removeRecord(record) {
      Restangular.one('albums', $scope.album.id).one(record.content_type + 's', record.content.id).remove()
        .then(function() {
          _.pull($scope.recordsLoader.items, record);
          $scope.album.records_count--;
        });
    }

    function removeAlbum() {
      $scope.album.remove()
        .then(function() {
          $state.go('app.user.albums', {user_id: $scope.user.id});
          Notification.show('Album "' + $scope.album.title + '" was removed!', 'info');
        })
        .catch(function(response) {
          Notification.showValidationErrors(response.data.errors);
        });
    }

    function getPinColor() {
      if ($scope.album.tile) {
        return {'color': $scope.album.color || '#b4504e'}
      }
    }

    function pinAlbum() {
      if (_.isObject($scope.album.tile)) {
        Restangular.one('pages', $scope.album.tile.page_id).one('tiles', $scope.album.tile.id).remove()
          .then(function() {
            $scope.album.tile = null;
            Notification.show('Album "' + $scope.album.title + '" was removed from your profile page', 'info');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/album/' + $scope.album.id + '/tiles', {resource: {size: null}})
          .then(function(response) {
            $scope.album.tile = response.data.resource;
            Notification.show('Album "' + $scope.album.title + '" was pinned on your profile page', 'success');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }

    function editAlbum() {
      $modal
        .open({
          templateUrl: 'components/albums/new/modal.html',
          controller: 'AlbumsEditModalCtrl',
          windowClass: 'e-modal',
          size: 'lg',
          resolve: {
            content: function() {
              return $scope.album.plain();
            }
          }
        }).result.then(function(response) {
          _.assign($scope.album, response);
        })
    }
  });
