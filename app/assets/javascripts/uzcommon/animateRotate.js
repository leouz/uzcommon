$(document).ready(function () {
  $.fn.animateRotate = function(deg, angle, duration, easing, complete) {
      var args = $.speed(duration, easing, complete);
      var step = args.step;
      return this.each(function(i, e) {
          args.step = function(now) {
              $.style(e, 'transform', 'rotate(' + now + 'deg)');
              if (step) return step.apply(this, arguments);
          };
          $({deg: deg}).animate({deg: angle}, args);
      });
  }; 
});