$(document).ready(function() {

  $("#slogan, .loader").hide();


  setTimeout(function() {
    $("#slogan").fadeIn(1000).animate({top: '50px', opacity: 1}, { duration: 800, easing: 'easeInOutCubic' });


    setTimeout(function() {
      $(".loader").fadeIn(800);
    }, 1000);

  }, 2000);
});
