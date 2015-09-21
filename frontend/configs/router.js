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
        templateUrl: 'components/app/app.html'
      })
      .state('app.main', {
        url: '/',
        templateUrl: 'components/main/main.html',
        controller: 'MainCtrl'
      });
  });
