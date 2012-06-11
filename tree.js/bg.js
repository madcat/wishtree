function slideSwitch() {
    var $active = $('#bg IMG.active');

    if ( $active.length == 0 ) $active = $('#bg IMG:last');

    var $sibs  = $active.siblings();
    var rndNum = Math.floor(Math.random() * $sibs.length );
    var $next  = $( $sibs[ rndNum ] );

    $active.addClass('last-active');

    $next.css({opacity: 0.0})
        .addClass('active')
        .animate({opacity: 1.0}, 500, function() {
            $active.removeClass('active last-active');
        });
}

$(document).ready(function() {
    setInterval( "slideSwitch()", 700 );
});

