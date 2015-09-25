'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, currentUser) {
    $scope.AuthModal = AuthModal;
    $scope.logout = logout;
    $scope.currentUser = currentUser;

    $scope.$watch($auth.isAuthenticated, CurrentUser.reload);

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }
  });
