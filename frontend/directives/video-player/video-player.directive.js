'use strict';

angular.module('app')
  .directive('videoPlayer', function (Restangular, $sce, Notification) {

    function controller($scope) {
      if (!$scope.video) throw new Error('Video player: Parameter "video" is required!');
      if (!$scope.video.video_id || !$scope.video.album_id) throw new Error('Video player: Attributes "album_id" and "video_id" for video are required!');
      $scope.showMsg = showMsg;

      if ($scope.video.id && (!$scope.video.duration || !$scope.video.preview_url))
        updateMetaInfo();

      setIframeUrl();

      function updateMetaInfo() {
        Restangular.one('albums', $scope.video.album_id).one('videos', $scope.video.id).customPUT({}, 'update_meta_info')
          .then(function (video) {
            $scope.video.duration = video.duration;
            $scope.video.preview_url = video.preview_url;
            setIframeUrl();
          });
      }

      function setIframeUrl() {
        // If duration is present means that video have been already processed
        if ($scope.video.duration)
          $scope.video.iframeUrl = $sce.trustAsResourceUrl('https://player.vimeo.com/video/' + $scope.video.video_id + '?color=908E7C&title=0&byline=0&portrait=0');
      }

      function showMsg() {
        Notification.show('Your video was successfully uploaded, but is not ready yet to be played.<br>You could continue your work and return later.', 'info', 'left');
      }
    }

    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/video-player/video-player.html',
      scope: {
        video: '='
      },
      controller: controller
    };
  });
