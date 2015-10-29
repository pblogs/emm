'use strict';

angular.module('app')
  .controller('UsersRelationshipsCtrl', function($scope, Restangular, user, currentUser) {
    $scope.findConnections = findConnections;
    $scope.user = user;
    $scope.isMyRelationships = user.id == currentUser.id;
    $scope.search = {
      status: $scope.isMyRelationships ? '' : 'friends'
    };

    $scope.$watchGroup(['search.status', 'search.filter'], findConnections);

    function findConnections() {
      $scope.friendsLoader = Restangular.one('users', user.id).all('relationships').toCollection(24, {
        filter: $scope.search.filter,
        status: $scope.search.status
      });

      if ($scope.isMyRelationships) {
        if ($scope.search.filter) {
          $scope.usersLoader = Restangular.all('users').toCollection(24, {
            filter: $scope.search.filter,
            status: $scope.search.status
          });
        } else {
          $scope.usersLoader = {};
        }
      }
    }
  });
