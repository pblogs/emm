'use strict';

/**
 * Same as FileUploader, but sends raw file via XHR instead of sending file as a field of FormData object
 */
angular.module('app')
  .factory('RawFileUploader', ['FileUploader', function (FileUploader) {
    FileUploader.inherit(RawFileUploader, FileUploader);

    function RawFileUploader(options) {
      RawFileUploader.super_.apply(this, arguments);
    }

    // Override default _xhrTransport method to not to use FormData
    RawFileUploader.prototype._xhrTransport = function (item) {
      var xhr = item._xhr = new XMLHttpRequest();
      var that = this;

      that._onBeforeUploadItem(item);

      xhr.upload.onprogress = function (event) {
        var progress = Math.round(event.lengthComputable ? event.loaded * 100 / event.total : 0);
        that._onProgressItem(item, progress);
      };

      xhr.onload = function () {
        var headers = that._parseHeaders(xhr.getAllResponseHeaders());
        var response = that._transformResponse(xhr.response, headers);
        var gist = that._isSuccessCode(xhr.status) ? 'Success' : 'Error';
        var method = '_on' + gist + 'Item';
        that[method](item, response, xhr.status, headers);
        that._onCompleteItem(item, response, xhr.status, headers);
      };

      xhr.onerror = function () {
        var headers = that._parseHeaders(xhr.getAllResponseHeaders());
        var response = that._transformResponse(xhr.response, headers);
        that._onErrorItem(item, response, xhr.status, headers);
        that._onCompleteItem(item, response, xhr.status, headers);
      };

      xhr.onabort = function () {
        var headers = that._parseHeaders(xhr.getAllResponseHeaders());
        var response = that._transformResponse(xhr.response, headers);
        that._onCancelItem(item, response, xhr.status, headers);
        that._onCompleteItem(item, response, xhr.status, headers);
      };

      xhr.open(item.method, item.url, true);

      xhr.withCredentials = item.withCredentials;

      angular.forEach(item.headers, function (value, name) {
        xhr.setRequestHeader(name, value);
      });

      // Here is the main difference (original FileUploader uses "xhr.send(form)")
      xhr.send(item._file);
      this._render();
    };

    return RawFileUploader;
  }]);
