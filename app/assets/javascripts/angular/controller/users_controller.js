//Factory
myApp.factory('Users', ['$resource', function ($resource) {
  return $resource('/users.json', {}, {
    query: { method: 'GET', isArray: false },
    create: { method: 'POST' }
  })
}]);

myApp.factory('User', ['$resource', function ($resource) {
  return $resource('/users/:id.json', {}, {
    show: { method: 'GET', params: {id: '@id'} },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

myApp.factory('EditUserGet', ['$resource', function ($resource) {
  return $resource('/users/:id/edit.json', {}, {
    edit: { method: 'GET', params: {id: '@id'} }
  });
}]);

myApp.factory('NewUserGet', ['$resource', function ($resource) {
  return $resource('/create_new_user.json', {}, {
    new: { method: 'GET' }
  });
}]);

myApp.factory('NewUserPost', ['$resource', function ($resource) {
  return $resource('/create_user.json', {}, {
    create: { method: 'POST', isArray: false }
  });
}]);

//Controller
myApp.controller("UserListCtr", ['$scope', '$http', '$resource', 'Users', 'User', '$location', 'flash', function ($scope, $http, $resource, Users, User, $location, flash) {
  $scope.flash = flash;
  $scope.users = Users.query();
  $scope.deleteUser = function (userId) {
    if (confirm("Are you sure you want to delete this user?")) {
      User.delete({ id: userId }, function () {
        $scope.users = Users.query();
        $location.path('/users');
      });
    }
  };
}]);

myApp.controller("UserShowCtr", ['$scope', '$resource', 'User', '$location', '$routeParams', 'flash', function ($scope, $resource, User, $location, $routeParams, flash) {
  $scope.flash = flash;
  $scope.users = User.show({id: $routeParams.id});
}]);

myApp.controller("UserUpdateCtr", ['$scope', '$resource', 'User', 'EditUserGet', '$location', '$routeParams', 'flash', function ($scope, $resource, User, EditUserGet, $location, $routeParams, flash) {

  EditUserGet.edit({id: $routeParams.id}, function(data, status, headers, config) {
    $scope.user = data.user;
    $scope.roles = data.roles;
    $scope.current_user = data.current_user;
    $scope.is_admin = data.is_admin;
    $scope.selectedOpt = data.user.role;
//    $scope.userForm.role_id = data.roles[1].id;
  }, function(error, status, headers, config) {
    // Error handler code
  });

  $scope.update_user = function () {
    $scope.user.role_id = $scope.userForm.role_id.$viewValue.id;
    if ($scope.userForm.$valid) {
      User.update({id: $scope.user.id}, {user: $scope.user}, function (data) {
        console.log(data);
        flash.setMessage("User was successfully updated.");
        $location.path('/users/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  };
}]);

myApp.controller("UserAddCtr", ['$scope', '$resource', 'NewUserGet', 'NewUserPost', '$location', 'flash', function ($scope, $resource, NewUserGet, NewUserPost, $location, flash) {
  NewUserGet.new(function(data, status, headers, config) {
    $scope.user = data.user;
    $scope.roles = data.roles;
    $scope.is_admin = data.is_admin;
    $scope.selectedOpt = data.roles[1];
//    $scope.userForm.role_id = data.roles[1].id;
  }, function(errors, status, headers, config) {
    // Error handler code
  });

  $scope.save = function () {
    $scope.user.role_id = $scope.userForm.role_id.$viewValue.id;
    $scope.user.password = 'test1234';
    $scope.user.password_confirmation = 'test1234';
    if ($scope.userForm.$valid) {
      NewUserPost.create({user: $scope.user}, function (data) {
        console.log(data);
        flash.setMessage("User was successfully created.");
        $location.path('/users/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  }
}]);
