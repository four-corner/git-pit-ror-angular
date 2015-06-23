// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$.fn.collect = function(fn) {
    var values = [];
    if (typeof fn == 'string') {
        var prop = fn;
        fn = function() { return this.attr(prop); };
    }
    $(this).each(function() {
        var val = fn.call($(this));
        values.push(val);
    });
    return values;
};

// turbolink on, hence tweak on page change
(function($) {
    $(document).on('page:change', function (e) {
        activeClass($("ul.nav.navbar-nav li.active"));
        var currentUrl = window.location.toString();
        var tabLinks = $('ul.nav.navbar-nav a').collect('href');
        var myTabLinks = getTabLinks(currentUrl, tabLinks);

        $(myTabLinks).each(function(){
            var myTab = $('a[href="' + this + '"]');
            activeClass($(myTab).parent('li'));
        });

    });

    var activeClass = function(obj){
        obj.toggleClass('active');
    };

    var getTabLinks = function(currentUrl, tabLinks){
        var myTabLinks = [];
        $(tabLinks).each(function(){
            if (currentUrl.indexOf(this) >= 0){
              myTabLinks.push(this);
            }
        });
        if(myTabLinks.length > 1){
            myTabLinks.shift();
        }
        return myTabLinks;
    };
})(jQuery);

