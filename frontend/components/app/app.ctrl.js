'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, MediaTypeSelectModal, currentUser) {
    $scope.AuthModal = AuthModal;
    $scope.MediaTypeSelectModal = MediaTypeSelectModal;
    $scope.logout = logout;
    $scope.currentUser = currentUser;

    // When user logs in/out we reload CurrentUser service and all bindings will be updated
    $scope.$watch($auth.isAuthenticated, CurrentUser.reload);

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }
  });
