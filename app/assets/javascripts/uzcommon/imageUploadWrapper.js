$(document).ready(function() {
  $.fn.extend({
    imageUploadWrapper: function (options) {
      // input example:
      //<input id="fileupload" type="file" name="asset[file][]"
      // multiple="" get-images-url="/admin/assets/get" destroy-images-url="/admin/assets/destroy"
      // data-url="#{admin_assets_path}" data-group="all" />

      this.options = {
        isMultiple: null,// true/false,
        destroyImagesUrl: null,// "/admin/assets/destroy",
        getImagesUrl: null,// "/admin/assets/get",

        events: {
          onUploadStart: function (data, file) {},
          onUploadProgress: function (data, progress) {},
          onUploadFinish: function (data, result) {},
          onDelete: function () {}
        },
        templates: {
          buttons: function () {
            return $('<div id="image-upload-buttons">').append(
                $('<button id="image-upload-remove-selected" class="btn btn-xs btn-danger" type="submit">').append(
                  $('<span class="glyphicon glyphicon-trash">').append('Remove selected')),
                $('<span class="check-all btn btn-xs btn-info">').append(
                  $('<span class="glyphicon glyphicon-check">').append('Check All')),
                $('<span class="uncheck-all btn btn-xs btn-info">').append(
                  $('<span class="glyphicon glyphicon-check">').append('Uncheck All'))
              );
          },
          displayImageContainer: function () {
            return $('<div id="image-upload-images">');
          },
          imageThumb: function (id, url, thumbUrl) {
            var div = $('<div>').addClass('thumb img img-thumbnail').css({"background-image": "url('" + thumbUrl + "')"});
            div.append($('<input>').addClass('img check').attr({value: id, type: "checkbox"}));            
            return $('<a>').attr({href: url}).append(div);                
          },
          imageThumbLoading: function () {
            return $('<div>').addClass('thumb img img-thumbnail').append(
                $('<span>').addClass('label label-info').html('0%')
              );
          },
          mountSingle: function (element, displayImageContainer) {
            $(element).after(displayImageContainer);
          },
          mountMultiple: function (element, buttons, displayImageContainer) {
            $(element).after(buttons, displayImageContainer);
          }
        }        
      };
      this.options = $.extend(true, {}, this.options, options || {});
      this.reset = function () {
        $('div#image-upload-images').empty();
      };

      var $element = $(this);
      var _options = this.options;
      
      if (_options.isMultiple == null)
        _options.isMultiple = $element.is('[multiple]');
      if (_options.destroyImagesUrl == null)
        _options.destroyImagesUrl = $element.attr('destroy-images-url');
      if (_options.getImagesUrl == null)
        _options.getImagesUrl = $element.attr('get-images-url');

      

      var deleteCheckedImages = function () {
        var $checked = $('input.img.check:checked');
        var data = $checked.map(function() { return $(this).val(); }).get();
        if (data.length > 0)
          $.post(_options.destroyImagesUrl, { assets: data }, function () {
            $.each($checked, function (i, e) {
              $(e).parent().fadeOut(1500, function () { $(this).remove(); });
            });
          });
      }

      if (_options.isMultiple) {
        //mount the DOM structure
        _options.templates.mountMultiple(
          $element,
          _options.templates.buttons(), 
          _options.templates.displayImageContainer()
        );

        //initialize check actions
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

        //initialize remove checked
        $(document).on('click', '#image-upload-remove-selected', function() {
          deleteCheckedImages();
        });
      
        $.get(_options.getImagesUrl, function(data) {
          $.each(data, function(i, e) {
            $('div#image-upload-images').append(_options.templates.imageThumb(e.id, e.file.url, e.file.thumb.url));
          });
        });
      } else {
        //mount the DOM structure
        _options.templates.mountSingle(
          $element,
          _options.templates.displayImageContainer()
        );
      }
      
      $element.fileupload({
        dataType: 'json',
        replaceFileInput: false,    
        add: function(e, data) {      
          var types = /(\.|\/)(gif|jpe?g|png)$/i;
          var file = data.files[0];
          if (types.test(file.type) || types.test(file.name)) {      
            data.context = _options.templates.imageThumbLoading(file.name);
            
            if (!_options.isMultiple) {
              $('.check').prop('checked', true);              
              deleteCheckedImages();
              $('div#image-upload-images').empty();  
            }

            $('div#image-upload-images').prepend(data.context);

            _options.events.onUploadStart(data, file);
            return data.submit();
          } else {
            alert(file.name + " is not a gif, jpeg, or png image file");
          }
        },

        progress: function(e, data) {
          var progress;
          if (data.context) {
            progress = parseInt(data.loaded / data.total * 100, 10);
            data.context.find('span').html(progress + '%');
          }
          _options.events.onUploadProgress(data, progress);
        },

        done: function (e, data) {
          $(data.context).replaceWith(_options.templates.imageThumb(data.result.id, data.result.url, data.result.thumb));          
          $(this).val("");

          if (!_options.isMultiple)
            $('.check').hide();
          _options.events.onUploadFinish(data, data.result);
        },

        fail: function (e, data) { alert(data.result.error); },
        always: function (e, data) { $(data.context).remove(); }
      });

      return this;
    }    
  });
});