'use strict';

angular.module('app')
  .directive('videoInput', function (RawFileUploader, Restangular, Notification) {

    window.RawFileUploader = RawFileUploader;

    function controller($scope) {
      $scope.clearUploader = clearUploader;

      $scope.uploader = getUploader();
      $scope.fileInputId = Math.random().toString();

      function getUploader() {
        // Create uploader
        var uploader = new RawFileUploader();
        uploader.queueLimit = 1;

        // Set request parameters before uploading
        uploader.onBeforeUploadItem = function (fileItem) {
          fileItem.headers['Content-Type'] = fileItem.file.type;
        };

        uploader.onAfterAddingFile = function () {
          uploader.isUploadPreparing = true;

          // Prepare video for upload - get upload link and and complete upload uri
          Restangular.all('video_uploads').one('new').get()
            .finally(function () {
              uploader.isUploadPreparing = false;
            })
            .then(function (videoUpload) {
              if (videoUpload.upload_link_secure) {
                var item = uploader.queue[0];
                item.url = videoUpload.upload_link_secure;
                item.complete_uri = videoUpload.complete_uri;
                item.method = 'put';
                item.upload();
              }
              else {
                Notification.show('Unable to upload your video', 'danger');
                clearUploader();
              }
            })
            .catch(function (response) {
              Notification.show('Unable to upload your video', 'danger');
              Notification.showValidationErrors(response.data.errors);
              clearUploader();
            });
        };

        uploader.onSuccessItem = function (item) {
          uploader.isUploadVerifying = true;

          // Submit video upload was completed and get actual vimeo video
          Restangular.all('video_uploads').post({complete_uri: item.complete_uri})
            .finally(function () {
              uploader.isUploadVerifying = false;
              clearUploader();
            })
            .then(function (video) {
              if ($scope.onUploaded) $scope.onUploaded(video);
            })
            .catch(function (response) {
              Notification.show('Unable to verify your video upload', 'danger');
              Notification.showValidationErrors(response.data.errors);
              clearUploader();
            });
        };

        return uploader;
      }

      function clearUploader() {
        $scope.uploader.clearQueue();
        document.querySelector('input[id="' + $scope.fileInputId + '"]').value = null;
      }
    }

    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'directives/video-input/video-input.html',
      scope: {
        height: '=?',
        onUploaded: '='
      },
      controller: controller
    };
  });
