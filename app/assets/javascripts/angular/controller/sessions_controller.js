//Controller
myApp.controller('SessionLogoutCtr', ['Auth', '$scope', '$location', 'flash', function(Auth, $scope, $location, flash) {
  this.logout = function() {
    Auth.logout().then(function(oldUser) {
      alert("Successfully logged out.");
//      flash.setMessage("Successfully logged out.");
      $location.path("/sign_in");
    }, function(error) {
      // An error occurred logging out.
    });
  }
}]);

myApp.controller('SessionLoginCtr', ['Auth', '$location', '$scope', 'flash', function(Auth, $location, $scope, flash) {
  this.credentials = { email: '', password: '' };
  $scope.flash = flash;

  this.signIn = function() {
    // Code to use 'angular-devise' component
    Auth.login(this.credentials).then(function(user) {
      flash.setMessage("Successfully signed in user.");
      $location.path("/users");
    }, function(errors) {
      console.log(errors);
      $scope.errors = ["Invalid email or password."];
    });
  }
}]);