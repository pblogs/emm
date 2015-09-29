'use strict';

/**
 * Config for the restangular
 */
angular.module('app')
  .config(function (RestangularProvider) {
    RestangularProvider.setBaseUrl('/api');

    RestangularProvider.addResponseInterceptor(function (response, operation, what) {
      if (operation === 'getList') {
        if (response.resources) {
          response.resources.total = _.result(response.meta, 'total');
        }
        return response['resources'];
      }
      if (['get', 'post', 'put'].indexOf(operation) !== -1) {
        return response['resource'];
      }
      return response;
    });

    RestangularProvider.addRequestInterceptor(function (request, operation, what) {
      if (operation === 'post' || operation === 'put') {
        return {resource: request};
      }
      return request;
    });

    RestangularProvider.setDefaultHeaders({'Content-Type': 'application/json'});

    RestangularProvider.setRestangularFields({
      exists: 'exists'
    });
  })
  .run(function (Restangular) {
    Restangular.setOnElemRestangularized(function (elem, isCollection) {
      if (!isCollection) {
        elem.exists = exists;
      }
      if (isCollection) {
        elem.toCollection = toCollection;
      }
      return elem;
    });

    function exists() {
      return this.id !== undefined;
    }

    // Use this method on Restangular collection to request object page by page using "nextPage" method
    function toCollection(itemsPerPage, params) {
      var page = 1,
        itemsPerPageIn = itemsPerPage || 10,
        paramsIn = params,
        toRequest = this,
        result = {
          items: [],
          busy: false,
          allReceivedPage: false,
          nextPage: nextPage
        };

      function nextPage() {
        if (result.busy || result.allReceived) return;
        result.busy = true;

        var params = _.merge({per_page: itemsPerPageIn, page: page}, paramsIn);

        result.nextPagePromise = toRequest.getList(params);
        result.nextPagePromise.then(function (collectionData) {
          result.items = result.items.concat(collectionData);
          if (result.items.length >= collectionData.total || collectionData.length === 0)
            result.allReceived = true;
          else
            page++;
          result.busy = false;
        });
      }

      nextPage();
      return result;
    }
  });
