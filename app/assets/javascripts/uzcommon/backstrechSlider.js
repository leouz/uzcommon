$(document).ready(function() {  
  $.fn.extend({
    backstrechSlider: function(options) {
      this.options = {        
        bulletsSelector: '#bullets',
        descriptionSelector: '#description',
        data: [{ image: "", description: "" }],
        onImageClick: function (index, data) { },
        onImageChange: function (index, data) { }
      }

      this.options = $.extend({}, this.options, options || {});
      var options = this.options;
      var $image = $(this);
      var $bullets = $(this.options.bulletsSelector);      
      var $description = $(this.options.imageSelector);

      var images = _.map(this.options.data, function(i) { return i.image; });
      $image.backstretch(images, { duration: 6000, fade: 2000 });
      
      $.each(images, function (i, e) {          
        $bullets.append($('<div class="bullet" index="' + i + '">').click(function () {
          $image.backstretch("show", parseInt($(this).attr('index')));          
        }));
      });

      $image.click(function () {
        var i = $image.data("backstretch").index;
        options.onImageClick(i, options.data[i]);      
      });

      var refresh = function (index) {        
        $bullet = $('.bullet');
        $bullet.removeClass('active');
        $($bullet[index]).addClass('active'); 
        $(options.descriptionSelector).html(options.data[index].description);
        options.onImageChange(index, options.data[index]);
      }

      $(window).on("backstretch.before", function (e, instance, index) {
        refresh(index);
      });

      refresh(0);
    }
  });
});