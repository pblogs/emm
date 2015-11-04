'use strict';

angular.module('app')
  .controller('TributesNewModalCtrl', function ($scope, Restangular, CurrentUser, Notification, MediaTypeSelectModal, $state, $rootScope, caller) {
    $scope.submit = submit;
    $scope.back = back;

    function submit() {
      $scope.errors = {};
      if (!$scope.user.id) {
        $scope.errors.user = ['Required'];
      } else {
        Restangular.one('users', $scope.user.id).all('tributes').post({description: $scope.description || ''})
          .then(function(resource) {
            Notification.show('Tribute for ' + $scope.user.first_name + ' ' + $scope.user.last_name + ' was successfully created', 'success');
            $state.go('app.user.tribute', {user_id: $scope.user.id, tribute_id: resource.id});
            $scope.$close();
          })
          .catch(function(response) {
            $scope.errors = response.data.errors;
          });
      }
    }
    function back() {
      if (caller == 'SelectMediaTypeModal') MediaTypeSelectModal();
      $scope.$close();
    }
  });
