//Factory
myApp.factory('Roles', ['$resource', function ($resource) {
  return $resource('/roles.json', {}, {
    query: { method: 'GET', isArray: false },
    create: { method: 'POST' }
  })
}]);

myApp.factory('Role', ['$resource', function ($resource) {
  return $resource('/roles/:id.json', {}, {
    show: { method: 'GET', params: {id: '@id'} },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

myApp.factory('EditRoleGet', ['$resource', function ($resource) {
  return $resource('/roles/:id/edit.json', {}, {
    edit: { method: 'GET', params: {id: '@id'} }
  });
}]);

myApp.factory('NewRoleGet', ['$resource', function ($resource) {
  return $resource('/create_new_role.json', {}, {
    new: { method: 'GET' }
  });
}]);

//Controller
myApp.controller("RoleListCtr", ['$scope', '$http', '$resource', 'Roles', 'Role', '$location', function ($scope, $http, $resource, Roles, Role, $location) {
  $scope.roles = Roles.query();
  $scope.deleteRole = function (roleId) {
    if (confirm("Are you sure you want to delete this role?")) {
      Role.delete({ id: roleId }, function () {
        $scope.roles = Roles.query();
        $location.path('/roles');
      });
    }
  };
}]);


myApp.controller("RoleShowCtr", ['$scope', '$resource', 'Role', '$location', '$routeParams', 'flash', function ($scope, $resource, Role, $location, $routeParams, flash) {
  $scope.flash = flash;
  $scope.role = Role.show({id: $routeParams.id});
}]);

myApp.controller("RoleUpdateCtr", ['$scope', '$resource', 'Role', 'EditRoleGet', '$location', '$routeParams', 'flash', function ($scope, $resource, Role, EditRoleGet, $location, $routeParams, flash) {

  EditRoleGet.edit({id: $routeParams.id}, function(data, status, headers, config) {
    $scope.role = data.role;
    $scope.is_admin = data.is_admin;
  }, function(error, status, headers, config) {
    // Error handler code
  });

  $scope.update_role = function () {
    if ($scope.roleForm.$valid) {
      Role.update({id: $scope.role.id}, {role: $scope.role}, function (data) {
        console.log(data);
        flash.setMessage("Role was successfully updated.");
        $location.path('/roles/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  };
}]);

myApp.controller("RoleAddCtr", ['$scope', '$resource', 'NewRoleGet', 'Roles', '$location', 'flash', function ($scope, $resource, NewRoleGet, Roles, $location, flash) {
  NewRoleGet.new(function(data, status, headers, config) {
    $scope.role = data.role;
    $scope.is_admin = data.is_admin;
  }, function(errors, status, headers, config) {
    // Error handler code
  });

  $scope.save = function () {
    if ($scope.roleForm.$valid) {
      Roles.create({role: $scope.role}, function (data) {
        console.log(data);
        flash.setMessage("Role was successfully created.");
        $location.path('/roles/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  }
}]);

