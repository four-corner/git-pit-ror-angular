var myApp = angular.module('myapplication', ['ngRoute', 'ui.router', 'ngResource', 'Devise', 'templates']);

// Interceptor
function resourceErrorHandler(response) {
  console.log(response);
  var result = response.resource;
  result.$status = response.status;
  return result;
};

//common factory
myApp.factory("flash", function($rootScope) {
  var queue = [];
  var currentMessage = "";

  $rootScope.$on("$routeChangeSuccess", function() {
    currentMessage = queue.shift() || "";
  });

  return {
    setMessage: function(message) {
      queue.push(message);
    },
    getMessage: function() {
      return currentMessage;
    }
  };
});

myApp.service('sessionService', ['Auth', function(Auth) {
  var cuser;
  Auth.currentUser().then(function(user) {
    cuser = user;
    return cuser;
  }, function(error) {
    cuser = null;
    return cuser;
  });

  var factory;
  factory = {
    is_authenticated: function(){
      return Auth.isAuthenticated();
    },
    current_user: function() {
      return Auth._currentUser;
    }
  };
  return factory;
}]);

myApp.directive('bsActiveLink', ['$location', function ($location) {
  return {
    restrict: 'A', //use as attribute
    replace: false,
    link: function (scope, elem) {
      //after the route has changed
      scope.$on("$routeChangeSuccess", function () {
        var hrefs = ['/#' + $location.path(),
          '#' + $location.path(), //html5: false
          $location.path()]; //html5: true
        angular.forEach(elem.find('a'), function (a) {
          a = angular.element(a);
          if (-1 !== hrefs.indexOf(a.attr('href'))) {
            a.parent().addClass('active');
          } else {
            a.parent().removeClass('active');
          };
        });
      });
    }
  }
}]);

myApp.directive('includeReplace', function () {
  return {
    restrict: 'A', /* optional */
    link: function (scope, elem, attrs) {
      var lastEle = angular.element(elem.children().last());
      lastEle.remove();
    }
  };
});

myApp.directive('extraScope', function () {
  return {
    restrict: 'A', /* optional */
    link: function (scope, elem, attrs) {
      var lastEle = angular.element(elem.children().last());
      lastEle.remove();
    }
  };
});

myApp.controller("HeaderController", ['sessionService', '$scope', '$location', function (sessionService, $scope, $location) {
  $scope.isAuthenticated = function(){
    return sessionService.is_authenticated();
  };
  $scope.current_user = function(){
    return sessionService.current_user();
  };
}]);


myApp.run(['$rootScope', '$location', 'sessionService', function ($rootScope, $location, sessionService) {
  $rootScope.$on('$routeChangeStart', function (ev, next, curr) {
    var role = sessionService.current_user().role_type;
    var controllers = ['RoleListCtr', 'RoleShowCtr', 'RoleAddCtr', 'RoleUpdateCtr', 'UserAddCtr'];
    if (role == 'Regular' && $.inArray(next.$$route.controller, controllers) !== -1) {
      $location.path('/users');
    }
  })
}]);

//Routes
myApp.config([
  '$routeProvider', '$locationProvider', '$stateProvider', function ($routeProvider, $locationProvider, $stateProvider) {
    $routeProvider.when('/users', {
      templateUrl: 'assets/angular/templates/users/index.html',
      controller: 'UserListCtr'
    });
    $routeProvider.when('/users/:id', {
      templateUrl: 'assets/angular/templates/users/show.html',
      controller: "UserShowCtr"
    });
    $routeProvider.when('/create_new_user', {
      templateUrl: 'assets/angular/templates/users/new.html',
      controller: 'UserAddCtr'
    });
    $routeProvider.when('/users/:id/edit', {
      templateUrl: 'assets/angular/templates/users/edit.html',
      controller: "UserUpdateCtr"
    });
    $routeProvider.when('/roles', {
      templateUrl: 'assets/angular/templates/roles/index.html',
      controller: 'RoleListCtr'
    });
    $routeProvider.when('/roles/:id', {
      templateUrl: 'assets/angular/templates/roles/show.html',
      controller: "RoleShowCtr"
    });
    $routeProvider.when('/create_new_role', {
      templateUrl: 'assets/angular/templates/roles/new.html',
      controller: "RoleAddCtr"
    });
    $routeProvider.when('/roles/:id/edit', {
      templateUrl: 'assets/angular/templates/roles/edit.html',
      controller: "RoleUpdateCtr"
    });
    $routeProvider.when('/projects', {
      templateUrl: 'assets/angular/templates/projects/index.html',
      controller: 'ProjectListCtr'
    });
    $routeProvider.when('/projects/:id', {
      templateUrl: 'assets/angular/templates/projects/show.html',
      controller: "ProjectShowCtr"
    });
    $routeProvider.when('/create_new_project', {
      templateUrl: 'assets/angular/templates/projects/new.html',
      controller: "ProjectAddCtr"
    });
    $routeProvider.when('/projects/:id/edit', {
      templateUrl: 'assets/angular/templates/projects/edit.html',
      controller: "ProjectUpdateCtr"
    });
    $routeProvider.when('/sign_in', {
      templateUrl: 'assets/angular/templates/sessions/new.html',
      controller: "SessionLoginCtr"
    });
    $routeProvider.when('/users/password/new', {
      templateUrl: 'assets/angular/templates/passwords/new.html',
      controller: "PasswordNewCtr"
    });
//    $stateProvider.state('abcd', {
//      url: '/users/password/edit?reset_password_token',
//      templateUrl: 'assets/angular/templates/passwords/edit.html',
//      controller: 'PasswordEditCtr'
//    });
//    $stateProvider.state('abcd', {
//      views:{
//        "modal": {
//          templateUrl: 'assets/angular/templates/passwords/edit.html'
//        }
//      }
//    });
    $routeProvider.when('/users/password/edit/:reset_password_token', {
      templateUrl: 'assets/angular/templates/passwords/edit.html'
    });
    $routeProvider.when('/', {
      templateUrl: 'assets/angular/templates/landing/landing.html'
    })
    $routeProvider.otherwise({
      redirectTo: '/'
    });
  }
]);

