var paginationDefaults;(function(n){n(function(){var i=n(".pagination > div"),u=i.eq(0),t=i.eq(1),f=i.eq(2),r=n('[type="submit"]');paginationDefaults=function(n){return{next:f,prev:u,page:t,pageLength:10,invalidPage:function(){t.tooltipster("content",n),t.tooltipster("show"),r.prop("disabled",!0)},validPage:function(){t.tooltipster("hide"),r.prop("disabled",!1)}}},n(t).tooltipster({animation:"swing",autoClose:"false",contentAsHTML:!0,trigger:"custom",updateAnimation:!1}),r.prop("disabled",!1)})})(jQuery);
