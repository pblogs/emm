'use strict';

angular.module('app')
  .controller('UsersShowCtrl', function ($scope, Restangular, user) {
    $scope.user = user;
    $scope.loadTiles = loadTiles;

    function loadTiles() {
      $scope.tilesLoader = Restangular.one('users', user.id).all('tiles').toCollection(5);
    }

    loadTiles();
  });
