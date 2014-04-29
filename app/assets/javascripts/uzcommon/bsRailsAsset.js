$(document).ready(function() {
  $.fn.extend({
    bsRailsAsset: function (options) {            
      this.options = {};
      this.options.getImagesUrl = "/admin/assets/get";
      this.options.destroyImagesUrl = "/admin/assets/destroy";      

      var _options = this.options;

      $('.uncheck-all').hide();
      $(document).on('click', '.check-all', function() {
        $('.check-all').hide();
        $('.uncheck-all').show();
        $('.check').prop('checked', true);    
      });
      $(document).on('click', '.uncheck-all', function() {
        $('.check-all').show();
        $('.uncheck-all').hide();
        $('.check').prop('checked', false);
      });

      $(document).on('click', '#image-upload-remove-selected', function() {
        var $checked = $('input.img.check:checked');
        var data = $checked.map(function() { return $(this).val(); }).get();
        $.post(_options.destroyImagesUrl, { assets: data }, function () {
          $.each($checked, function (i, e) {
            $(e).parent().fadeOut(1500, function() { $(this).remove(); });
          });
        })
      });

      var crateAssetThumb = function (id, url, thumbUrl) {
        return $('<a>').attr({href: url}).append(
          $('<div>').addClass('thumb img img-thumbnail').css({"background-image": "url('" + thumbUrl + "')"}).append(
            $('<input>').addClass('img check').attr({value: id, type: "checkbox"})
          )
        );
      }

      var crateAssetThumbLoading = function () {
        return  $('<div>').addClass('thumb img img-thumbnail')
          .append($('<span>').addClass('label label-info').html('0%'));
      }

      $.get(_options.getImagesUrl, function(data) {
        $.each(data, function(i, e) {
          $('#image-upload-images').append(crateAssetThumb(e.id, e.file.url, e.file.thumb.url));
        });
      });
      
      $(this).fileupload({
        dataType: 'json',
        replaceFileInput: false,    
        add: function(e, data) {      
          var types = /(\.|\/)(gif|jpe?g|png)$/i;
          var file = data.files[0];
          if (types.test(file.type) || types.test(file.name)) {      
            data.context = crateAssetThumbLoading(file.name)
            $('#image-upload-images').prepend(data.context);
            return data.submit();
          } else {
            alert("" + file.name + " is not a gif, jpeg, or png image file");
          }
        },

        progress: function(e, data) {
          var progress;
          if (data.context) {
            progress = parseInt(data.loaded / data.total * 100, 10);
            data.context.find('span').html(progress + '%');
          }
        },

        done: function (e, data) {  
          alert('done'); 
          $(data.context).replaceWith(crateAssetThumb(data.result.id, data.result.url, data.result.thumb));
          $(this).val("");
        },

        fail: function (e, data) { alert(data.result.error); },

        always: function (e, data) { $(data.context).remove(); }
      });
    }    
  });
});


