jQuery(function() {
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();
  
  $(".datetimepicker").datepicker({ dateFormat: "D, dd M yy" });
  $(".datepicker").datepicker({ dateFormat: "D, dd M yy" });

  $body = $("body");
  $(document).on({
    ajaxStart: function() { $body.addClass("loading"); },
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
  });

  $('.sortable').each(function () {
    $(this).sortable({
      axis: 'y',
      dropOnEmpty:false,
      handle: '.drag',
      cursor: 'crosshair',
      items: 'tr',
      opacity: 0.4,
      scroll: true,
      update: function () {
        $this = $(this);
        $.ajax({
          type: 'post',
          data: $this.sortable('serialize'),
          dataType: 'script',
          url: $this.attr('data-url')
        });
      }
    });
  });
});