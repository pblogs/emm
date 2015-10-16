'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, MediaTypeSelectModal, currentUser, Background, Restangular, $rootScope) {
    $scope.AuthModal = AuthModal;
    $scope.MediaTypeSelectModal = MediaTypeSelectModal;
    $scope.Background = Background;
    $scope.logout = logout;
    $scope.currentUser = currentUser;

    $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams){
      setVisibleUser();
    });

    function setVisibleUser() {
      if ($state.params.user_id) {
        Restangular.one('users', $state.params.user_id).get().then(function(user) {
          $scope.visibleUser = user;
        })
      } else {
        $scope.visibleUser = $scope.currentUser;
      }
    }

    // When user logs in/out we reload CurrentUser service and all bindings will be updated
    $scope.$watch($auth.isAuthenticated, function(newVal, oldVal) {
      if (newVal != oldVal) CurrentUser.reload();
      setVisibleUser();
    });

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }
  });
