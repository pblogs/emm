'use strict';

angular.module('app')
  .factory('WindowSize', function ($window) {
    return {
      get: function () {
        if ($window.innerWidth >= 1200) return 'lg';
        if ($window.innerWidth >= 992 && $window.innerWidth <= 1999) return 'md';
        if ($window.innerWidth <= 991) return 'sm';
      }
    };
  });
