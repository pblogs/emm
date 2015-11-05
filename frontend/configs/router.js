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
        templateUrl: 'components/app/app.html',
        resolve: {
          currentUser: function (CurrentUser) {
            return CurrentUser.get();
          }
        }
      })
      .state('app.main', {
        url: '/',
        templateUrl: 'components/main/main.html',
        controller: 'MainCtrl'
      })

      // Authorization states

      .state('app.confirmation', {
        url: '/users/confirmation/{token:[a-zA-Z0-9-_]+}',
        controller: 'ConfirmationCtrl'
      })
      .state('app.recovery', {
        url: '/recovery/{token:[a-zA-Z0-9-_]+}',
        controller: function ($scope, $state, AuthModal) {
          $state.go('app.main');
          AuthModal('finishRecovery');
        }
      })

      // User states
      .state('app.user', {
        url: '/users/{user_id:int}',
        template: '<div ui-view=""></div>',
        controller: function (user, Background, VisibleUser) {
          Background.set(user);
          VisibleUser.set(user);
        },
        resolve: {
          user: function (Restangular, $stateParams, Handle404, currentUser) {
            if ($stateParams.user_id == currentUser.id) {
              return currentUser;
            } else {
              return Restangular.one('users', $stateParams.user_id).get()
                .catch(Handle404);
            }
          }
        },
        onExit: function (Background, VisibleUser) {
          Background.reset();
          VisibleUser.set();
        }
      })
      .state('app.user.show', {
        url: '/profile?{page:int}{page_id:int}',
        templateUrl: 'components/users/show/show.html',
        controller: 'UsersShowCtrl',
        reloadOnSearch: false
      })
      .state('app.user.tributes', {
        url: '/tributes',
        templateUrl: 'components/users/tributes/index.html',
        controller: 'UsersTributesCtrl'
      })
      .state('app.user.tribute', {
        url: '/tributes/{tribute_id:int}',
        templateUrl: 'components/users/tributes/tribute/tribute.html',
        controller: 'UsersTributeCtrl',
        resolve: {
          tribute: function(Restangular, $stateParams) {
            return Restangular.one('users', $stateParams.user_id).one('tributes', $stateParams.tribute_id).get();
          }
        }
      })
      .state('app.user.albums', {
        url: '/albums',
        templateUrl: 'components/users/albums/index.html',
        controller: 'UsersAlbumsCtrl'
      })
      .state('app.user.album', {
        url: '/albums/{album_id:int}',
        templateUrl: 'components/users/albums/show/album.html',
        controller: 'UserAlbumCtrl',
        resolve: {
          album: function(Restangular, $stateParams) {
            return Restangular.one('users', $stateParams.user_id).one('albums', $stateParams.album_id).get();
          }
        }
      })
      .state('app.user.edit', {
        abstract: true,
        url: '/settings',
        templateUrl: 'components/users/edit/edit.html',
        onEnter: function (Handle404, currentUser, user) {
          if (currentUser.id !== user.id) Handle404();
        },
        data: {
          permissions: {
            except: ['anonymous'],
            redirectTo: 'app.main'
          }
        }
      })
      .state('app.user.edit.general', {
        url: '/general',
        templateUrl: 'components/users/edit/general/general.html',
        controller: 'UsersEditGeneralCtrl'
      })
      .state('app.user.edit.security', {
        url: '/security',
        templateUrl: 'components/users/edit/security/security.html',
        controller: 'UsersEditSecurityCtrl'
      })
      .state('app.user.relationships', {
        url: '/relationships',
        templateUrl: 'components/users/relationships/relationships.html',
        controller: 'UsersRelationshipsCtrl'
      })
      .state('app.relationship', {
        url: '/relationships/{relationship_id:int}/?user_id&friend_id',
        templateUrl: 'components/users/relationships/show/show.html',
        controller: 'UsersRelationshipShowCtrl',
        resolve: {
          user: function (Restangular, $stateParams, Handle404, currentUser) {
            if (currentUser.id == $stateParams.user_id) {
              return currentUser;
            } else {
              return Restangular.one('users', $stateParams.user_id).get()
                .catch(Handle404);
            }
          },
          friend: function (Restangular, $stateParams, Handle404) {
            return Restangular.one('users', $stateParams.friend_id).get()
              .catch(Handle404);
          }
        },
        onExit: function (Background, VisibleUser) {
          Background.reset();
          VisibleUser.set();
        }
      });

    // Page not found

    $urlRouterProvider.otherwise(function ($injector) {
      $injector.get('Handle404')();
    });

    // Helpers

    function loadResource(resource) {
      return /*@ngInject*/ function (Restangular, $stateParams, Handle404) {
        return Restangular.one(resource, $stateParams.id).get()
          .catch(Handle404);
      }
    }
  });
