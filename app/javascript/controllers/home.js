$(document).ready(function() {
  $("#slogan").hide();

  setTimeout(function() {
    $("#slogan").fadeIn(1000).animate({ top: '50px', opacity: 1 }, { duration: 800, easing: 'easeInOutCubic' });

    // setTimeout(function() {
    //   $(".loader").fadeIn(5000, function() {

    //     // $("#bouton").removeClass("d-none").addClass("bouton");


    //     // $("#bouton").css("opacity", 0).animate({ opacity: 1 }, 500);

    //     // $(".loader").fadeOut(0);
    //   });
    // }, 1000);
  }, 2000);
});
