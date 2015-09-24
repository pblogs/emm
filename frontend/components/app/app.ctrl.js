'use strict';

angular.module('app')
  .controller('AppCtrl', function($scope, $modal, CurrentUser, $auth, $state) {
    $scope.signUpModal = signUpModal;
    $scope.signInModal = signInModal;
    $scope.startRecoveryModal = startRecoveryModal;
    $scope.logout = logout;

    $scope.$watch($auth.isAuthenticated, function(newVal, oldVal) {
        if (newVal) {
          CurrentUser.get().then(function(user) {
            $scope.currentUser = user;
          });
        } else {
          delete $scope.currentUser;
          CurrentUser.reset();
        }
      }
    );

    function logout() {
      $auth.logout();
      $state.go('app.main');
    }

    function signUpModal() {
      $modal.open({
        templateUrl: 'components/auth/sign-up/modal.html',
        controller: 'SignUpModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
        if (reason === 'signIn') {
          signInModal();
        }
      });
    }
    function startRecoveryModal() {
      $modal.open({
        templateUrl: 'components/auth/recovery/start.html',
        controller: 'StartRecoveryModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
          if (reason === 'signIn') {
            signInModal();
          }
        });
    }
    function signInModal() {
      $modal.open({
        templateUrl: 'components/auth/sign-in/modal.html',
        controller: 'SignInModalCtrl',
        windowClass: 'e-modal'
      }).result.catch(function(reason) {
        if (reason === 'signUp') {
          signUpModal();
        }
        if (reason === 'recovery') {
          startRecoveryModal();
        }
      });
    }
  });
