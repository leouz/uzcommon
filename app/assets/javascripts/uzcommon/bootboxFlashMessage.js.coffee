$(document).ready ->
  $.each window.flashMessages, () -> 
    bootbox.alert this.message

    