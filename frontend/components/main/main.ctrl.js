'use strict';

angular.module('app').controller('MainCtrl', function ($scope, Restangular) {
  Restangular.all('users').getList().then(function(users) {
    $scope.users = users;
  })

});
