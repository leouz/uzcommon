jQuery(function() {
  var summernote = $('.summernote').summernote({
     toolbar: [
      // ['style', ['style']], // no style button
      ['style', ['style', 'bold', 'italic', 'underline', 'clear']],      
      // ['fontsize', ['fontsize']],
      // ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      // ['height', ['height']],
      ['insert', ['link', 'picture', 'video']],
      ['view', ['fullscreen', 'codeview']],
      ['table', ['table']], // no table button
      ['help', ['help']] //no help button      
    ],    
    onImageUpload: function(files, editor, welEditable) {      
      data = new FormData();
      data.append("file", files[0]);
      $.ajax({
        url: "/admin/assets/summernote-upload",
        contentType: false,
        cache: false,
        processData: false,
        type: 'POST',
        dataType: 'json',
        data: data,    
        success: function(data) {
          editor.insertImage(welEditable, data.url);  
          $('body').removeClass('modal-open');        
        }
      });
    }
  });
  
  $('.summernote').each(function() { 
    var summernote = $(this);
    summernote.code(summernote.val());
    $(this).closest('form').submit(function () {
      summernote.val(summernote.code());
    });
  });
});