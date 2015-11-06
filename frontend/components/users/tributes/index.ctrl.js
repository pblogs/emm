'use strict';

angular.module('app')
  .controller('UsersTributesCtrl', function($scope, $stateParams, Restangular, Notification, $http, CurrentUser, user) {
    $scope.loadTributes = loadTributes;
    $scope.pinTribute = pinTribute;
    $scope.removeTribute = removeTribute;
    $scope.user = user;
    $scope.canEdit = user.id == CurrentUser.id();

    loadTributes();
    function loadTributes() {
      $scope.tributesLoader = Restangular.one('users', $stateParams.user_id).all('tributes').toCollection(24);
    }

    function removeTribute(tribute) {
      tribute.remove()
        .then(function() {
          _.pull($scope.tributesLoader.items, tribute);
          Notification.show('Tribute from ' + tribute.author.first_name + ' ' + tribute.author.last_name + ' was deleted!', 'info');
        })
    }

    function pinTribute(tribute) {
      if (_.isObject(tribute.tile)){
        Restangular.one('pages', tribute.tile.page_id).one('tiles', tribute.tile.id).remove()
          .then(function() {
            tribute.tile = null;
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      } else {
        $http.post('api/tribute/' + tribute.id + '/tiles', {resource: {size: null}})
          .then(function(response) {
            tribute.tile = response.data.resource;
            Notification.show('Tribute from ' + tribute.author.first_name + ' ' + tribute.author.last_name + ' was pinned on your profile page', 'success');
          })
          .catch(function(response) {
            Notification.showValidationErrors(response.data.errors);
          })
      }
    }
  });
