'use strict';

angular.module('app')
  .controller('AppCtrl', function ($scope, CurrentUser, $auth, $state, AuthModal, MediaTypeSelectModal, $http, currentUser, Background, Restangular, VisibleUser) {
    $scope.logout = logout;
    $scope.readAllNotifications = readAllNotifications;
    $scope.AuthModal = AuthModal;
    $scope.MediaTypeSelectModal = MediaTypeSelectModal;
    $scope.Background = Background;
    $scope.currentUser = currentUser;
    
    VisibleUser.set(currentUser);
    $scope.visibleUser = VisibleUser;

    // When user logs in/out we reload CurrentUser service and all bindings will be updated
    $scope.$watch($auth.isAuthenticated, function(newVal, oldVal) {
      if ($auth.isAuthenticated()) getNotifications();
      if (newVal != oldVal) CurrentUser.reload();
    });

    setInterval(function() {
      getNotifications();
    }, 30000);

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }

    function getNotifications() {
      $scope.notificationsLoader = Restangular.all('notifications').toCollection(24);
      $http.get('api/notifications/unread_count')
        .then(function(response) {
          $scope.unreadNotifications = {
            count : response.data.new_notifications
          }
        })
    }

    function readAllNotifications() {
      Restangular.all('notifications').all('mass_update').post()
        .then(function() {
          getNotifications();
        })
    }
  });
