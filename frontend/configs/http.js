'use strict';

/**
 * Config for the auth
 */
angular.module('app').config(function($httpProvider) {
  $httpProvider.defaults.withCredentials = true;
  $httpProvider.interceptors.push(function($injector) {
    var $auth;
    return {
      request: function(config) {
        $auth = $auth || $injector.get('$auth');
        config.headers['X-User-Token'] = $auth.getToken();
        return config;
      }
    };
  });
});
