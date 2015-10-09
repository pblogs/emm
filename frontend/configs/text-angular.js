'use strict';

/**
 * Config for the textAngular
 */

angular.module('app')
  .config(['$provide', function($provide){
    // this demonstrates how to register a new tool and add it to the default toolbar
    $provide.decorator('taOptions', ['$delegate', function(taOptions){
      taOptions.toolbar = [
        ['bold', 'italics', 'underline', 'strikeThrough'], ['justifyLeft', 'justifyCenter', 'justifyRight'],
        ['indent', 'outdent'], ['ul', 'ol']
      ];
      return taOptions;
    }]);
  }]);
