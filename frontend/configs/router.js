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
      .state('app.profile', {
        url: '/profile',
        templateUrl: 'components/user/profile.html',
        controller: 'ProfileCtrl'
      })
      .state('app.settings', {
        abstract: true,
        url: '/settings',
        templateUrl: 'components/user/settings/layout.html',
        data: {
          permissions: {
            except: ['anonymous'],
            redirectTo: 'app.main'
          }
        }
      })
      .state('app.settings.security', {
        url: '/security',
        templateUrl: 'components/user/settings/security.html',
        controller: 'SettingsSecurityCtrl'
      });
  });
