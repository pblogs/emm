'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, MediaTypeSelectModal, currentUser, Background, $rootScope, VisibleUser) {
    $scope.AuthModal = AuthModal;
    $scope.MediaTypeSelectModal = MediaTypeSelectModal;
    $scope.Background = Background;
    $scope.logout = logout;
    $scope.currentUser = currentUser;
    VisibleUser.set(currentUser);
    $scope.visibleUser = VisibleUser;

    // When user logs in/out we reload CurrentUser service and all bindings will be updated
    $scope.$watch($auth.isAuthenticated, function(newVal, oldVal) {
      if (newVal != oldVal) CurrentUser.reload();
    });

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }
  });
