'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, MediaTypeSelectModal, currentUser, Background) {
    $scope.AuthModal = AuthModal;
    $scope.MediaTypeSelectModal = MediaTypeSelectModal;
    $scope.logout = logout;
    $scope.getBackground = getBackground;
    $scope.currentUser = currentUser;

    var setBg = true;
    function getBackground() {
      if (setBg) {
        Background.set(currentUser);
        setBg = false;
      }
      return Background.get();
    }

    // When user logs in/out we reload CurrentUser service and all bindings will be updated
    $scope.$watch($auth.isAuthenticated, CurrentUser.reload);

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }
  });
