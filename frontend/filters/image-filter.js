'use strict';

angular.module('app')
  .filter('imageFilter', function() {
    var images = {
      avatar: 'no_avatar.jpg',
      album: 'no_cover.jpg'
    };

    return function(url, type) {
      return url ? url : images[type];
    };
  });
