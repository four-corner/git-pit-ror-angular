//Factory
myApp.factory('Passwords', ['$resource', function ($resource) {
  return $resource('/users/password.json', {}, {
    create: { method: 'POST' }
  })
}]);

myApp.factory('Password', ['$resource', function ($resource) {
  return $resource('/users/password.json', {}, {
    update: { method: 'PUT', isArray: false }
  });
}]);

//Controllers
myApp.controller('PasswordNewCtr', ['$location', '$scope', 'Passwords', 'flash', function($location, $scope, Passwords, flash) {
  this.credentials = { email: '' }
  this.getNew = function() {
    Passwords.create({user: this.credentials}, function (data) {
      alert("Password reset instructions sent successfully.");
      $location.path('/sign_in');
    }, function (errors, status, headers, config) {
      $scope.errors = ["Email not found"];
    });

  }
}]);

myApp.controller('PasswordEditCtr', ['$location', '$routeParams', '$scope', 'Password', 'flash', function($location, $routeParams, $scope, Password, flash) {
  this.credentials = { password: '', password_confirmation: '', reset_password_token: $routeParams.reset_password_token };
  this.setNew = function() {
    Password.update({user: this.credentials}, function (data, status, headers, config) {
      console.log(data);
      flash.setMessage("Password successfully reset.");
      alert("Password successfully reset.");
      $location.path('/sign_in');
    }, function (errors, status, headers, config) {
      console.log(errors);
      $scope.errors = errors.data;
    });
  }
}]);