'use strict';

angular.module('app')
  .controller('TributesEditModalCtrl', function ($scope, $http, CurrentUser, Notification, MediaTypeSelectModal, $state, tribute, user) {
    $scope.submit = submit;
      $scope.tribute = _.cloneDeep(tribute);
      $scope.user = user;

    function submit() {
      $scope.errors = {};
      $http.put('api/users/' + user.id + '/tributes/' + tribute.id, {resource: {description: $scope.tribute.description}})
        .then(function(response) {
          $scope.$close(response.data.resource);
        })
        .catch(function(response) {
          $scope.errors = response.data.errors;
        })
    }
  });
