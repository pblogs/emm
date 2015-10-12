'use strict';

/* Controllers */

angular.module('app')
  .controller('ConfirmationCtrl', function ($scope, $auth, $stateParams, $state, $http, CurrentUser, Notification, $modal) {

    $http.get('api/confirmation', {params: {confirmation_token: $stateParams.token}})
      .then(function (response) {
        $auth.setToken(response.data.auth_token);
        // There may already be another signed in user, so we need to reload current user to get those who confirmed email
        CurrentUser.reload();
        Notification.show('Your email was successfully confirmed!', 'success');
        $modal
          .open({
            templateUrl: 'components/users/avatar-popup/modal.html',
            controller: 'UserAvatarPopupCtrl',
            windowClass: 'e-modal'
          })
          .result.then(goToUserProfile).catch(goToUserProfile);

        function goToUserProfile() {
          $state.go('app.user.show', {user_id: CurrentUser.id()});
        }
      })
      .catch(function (response) {
        Notification.showValidationErrors(response.data.errors);
        $state.go('app.main');
      });
  });
