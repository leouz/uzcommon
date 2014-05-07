jQuery(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();
  
  $(".datetimepicker").datepicker({
    dateFormat: "D, dd M yy"
  });

  $(".datepicker").datepicker({
    dateFormat: "D, dd M yy"
  });


  $body = $("body");
  $(document).on({
    ajaxStart: function() { $body.addClass("loading");    },
    ajaxStop: function() { $body.removeClass("loading"); }    
  });

  $('.permalink').each(function () {
    var update = function () {
      var content = "your link will be <b>/" + $(this).val() + "</b>";
      $(this).parent().parent().children(".permalink-help-block").html(content);
    }
    $(this).keydown(update);
    $(this).change(update);
    $(this).change();    
  })

  $('.sort-last').click(function () {
    $thisTr = $(this).parent().parent().parent();    
    $thisTr.parent().append($thisTr);
  });

  $('.sort-first').click(function () {
    $thisTr = $(this).parent().parent().parent();    
    $thisTr.parent().prepend($thisTr);
  });

  $('.sort-down').click(function () {
    $thisTr = $(this).parent().parent().parent();
    $thisTr.insertAfter($thisTr.next());
  });

  $('.sort-up').click(function () {
    $thisTr = $(this).parent().parent().parent(); 
    $thisTr.insertBefore($thisTr.prev());
  });
});