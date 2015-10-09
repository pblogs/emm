'use strict';

/**
 * Config for the router
 */
angular.module('app')
  .config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
    $locationProvider.html5Mode(true);

    $stateProvider
      .state('app', {
        abstract: true,
        controller: 'AppCtrl',
        templateUrl: 'components/app/app.html',
        resolve: {
          currentUser: function (CurrentUser) {
            return CurrentUser.get();
          }
        }
      })
      .state('app.main', {
        url: '/',
        templateUrl: 'components/main/main.html',
        controller: 'MainCtrl'
      })

      // Authorization states

      .state('app.confirmation', {
        url: '/users/confirmation/{token:[a-zA-Z0-9-_]+}',
        controller: 'ConfirmationCtrl'
      })
      .state('app.recovery', {
        url: '/recovery/{token:[a-zA-Z0-9-_]+}',
        controller: function ($scope, $state, AuthModal) {
          $state.go('app.main');
          AuthModal('finishRecovery');
        }
      })

      // User states
      .state('app.user', {
        url: '/users/{userId:[0-9]+}',
        template: '<div ui-view=""></div>',
        controller: function (user, Background) {
          Background.set(user);
        },
        resolve: {
          user: function (Restangular, $stateParams, Handle404) {
            return Restangular.one('users', $stateParams.userId).get()
              .catch(Handle404);
          }
        },
        onExit: function (Background) {
          Background.reset();
        }
      })
      .state('app.user.show', {
        url: '/profile?{page:[0-9]+}',
        templateUrl: 'components/users/show/show.html',
        controller: 'UsersShowCtrl',
        reloadOnSearch: false
      })
      .state('app.user.edit', {
        abstract: true,
        url: '/settings',
        templateUrl: 'components/users/edit/edit.html',
        onEnter: function (Handle404, currentUser, user) {
          if (currentUser.id !== user.id) Handle404();
        },
        data: {
          permissions: {
            except: ['anonymous'],
            redirectTo: 'app.main'
          }
        }
      })
      .state('app.user.edit.general', {
        url: '/general',
        templateUrl: 'components/users/edit/general/general.html',
        controller: 'UsersEditGeneralCtrl'
      });

    // Page not found

    $urlRouterProvider.otherwise(function ($injector) {
      $injector.get('Handle404')();
    });

    // Helpers

    function loadResource(resource) {
      return /*@ngInject*/ function (Restangular, $stateParams, Handle404) {
        return Restangular.one(resource, $stateParams.id).get()
          .catch(Handle404);
      }
    }
  });
