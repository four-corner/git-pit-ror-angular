//Factory
myApp.factory('Projects', ['$resource', function ($resource) {
  return $resource('/projects.json', {}, {
    query: { method: 'GET', isArray: false },
    create: { method: 'POST' }
  })
}]);

myApp.factory('Project', ['$resource', function ($resource) {
  return $resource('/projects/:id.json', {}, {
    show: { method: 'GET', params: {id: '@id'} },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

myApp.factory('EditProjectGet', ['$resource', function ($resource) {
  return $resource('/projects/:id/edit.json', {}, {
    edit: { method: 'GET', params: {id: '@id'} }
  });
}]);

myApp.factory('NewProjectGet', ['$resource', function ($resource) {
  return $resource('/create_new_project.json', {}, {
    new: { method: 'GET' }
  });
}]);

//Controller
myApp.controller("ProjectListCtr", ['$scope', '$http', '$resource', 'Projects', 'Project', '$location', function ($scope, $http, $resource, Projects, Project, $location) {
  $scope.projects = Projects.query();
  $scope.deleteProject = function (projectId) {
    if (confirm("Are you sure you want to delete this project?")) {
      Project.delete({ id: projectId }, function () {
        $scope.projects = Projects.query();
        $location.path('/projects');
      });
    }
  };
}]);


myApp.controller("ProjectShowCtr", ['$scope', '$resource', 'Project', '$location', '$routeParams', 'flash', function ($scope, $resource, Project, $location, $routeParams, flash) {
  $scope.flash = flash;
  $scope.project = Project.show({id: $routeParams.id});
}]);

myApp.controller("ProjectUpdateCtr", ['$scope', '$resource', 'Project', 'EditProjectGet', '$location', '$routeParams', 'flash', function ($scope, $resource, Project, EditProjectGet, $location, $routeParams, flash) {

  EditProjectGet.edit({id: $routeParams.id}, function(data, status, headers, config) {
    $scope.project = data.project;
    $scope.is_admin = data.is_admin;
  }, function(error, status, headers, config) {
    // Error handler code
  });

  $scope.update_project = function () {
    if ($scope.projectForm.$valid) {
      Project.update({id: $scope.project.id}, {project: $scope.project}, function (data) {
        console.log(data);
        flash.setMessage("Project was successfully updated.");
        $location.path('/projects/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  };
}]);

myApp.controller("ProjectAddCtr", ['$scope', '$resource', 'NewProjectGet', 'Projects', '$location', 'flash', function ($scope, $resource, NewProjectGet, Projects, $location, flash) {
  NewProjectGet.new(function(data, status, headers, config) {
    $scope.project = data.project;
    $scope.is_admin = data.is_admin;
  }, function(errors, status, headers, config) {
    // Error handler code
  });

  $scope.save = function () {
    if ($scope.projectForm.$valid) {
      Projects.create({project: $scope.project}, function (data) {
        console.log(data);
        flash.setMessage("Project was successfully created.");
        $location.path('/projects/'+data.id);
      }, function (errors, status, headers, config) {
        console.log(errors);
        $scope.errors = errors.data;
      });
    }
  }
}]);

