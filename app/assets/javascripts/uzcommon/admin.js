jQuery(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();
  
  $(".datepicker").datepicker({
    dateFormat: "D, dd M yy"
  });

  $body = $("body");
  $(document).on({
      ajaxStart: function() { $body.addClass("loading");    },
       ajaxStop: function() { $body.removeClass("loading"); }    
  });  
});