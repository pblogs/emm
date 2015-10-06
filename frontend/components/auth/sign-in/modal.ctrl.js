'use strict';

angular.module('app')
  .controller('SignInModalCtrl', function ($scope, $modalInstance, $auth, $http, $state, CurrentUser, Notification) {
    $scope.user = {};
    $scope.submit = submit;

    function submit() {
      $scope.errors = {};
      $http.post('/api/login', {user: $scope.user})
        .then(function (response) {
          var token = _.result(response.data, 'auth_token');
          if (token) {
            $auth.setToken(token);
            Notification.show('Welcome!', 'success');
            $modalInstance.close();
            $state.go('app.user.show', {userId: CurrentUser.id()});
          }
        })
        .catch(function (response) {
          $scope.errors.email = response.data.errors;
        });
    }
  });
