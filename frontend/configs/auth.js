'use strict';

/**
 * Config for the auth
 */
angular.module('app')
  .config(function ($authProvider) {
    $authProvider.loginUrl = '/api/login';
    $authProvider.signupUrl = '/api/registration';
    $authProvider.tokenName = 'auth_token';
    $authProvider.tokenPrefix = 'satellizer';
    $authProvider.signupRedirect = false;
    $authProvider.loginRedirect = false;
    $authProvider.logoutRedirect = false;
    $authProvider.loginOnSignup = true;
  });
