function slideSwitch() {
    var $active = $('#bg IMG.active');

    if ( $active.length == 0 ) $active = $('#bg IMG:last');

    // use this to pull the images in the order they appear in the markup
    //var $next =  $active.next().length ? $active.next()
    //    : $('#bg IMG:first');

    // uncomment the 3 lines below to pull the images in random order
    
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

$(function() {
    setInterval( "slideSwitch()", 700 );
});



$(document).ready(function(){

    var card1 = $("#card1").hide();
    var card2 = $("#card2").hide();

    var canvas = $("#canvas_container");
    var paper = Raphael(canvas.attr('id'),canvas.width(),canvas.height());

    // full paths
    var ps1 = paper.path("M582 350V250H670V170A30 30 0 1 0 640 200H720").hide();
    var p1 = paper.path("M582 350V250H670V170A30 30 0 1 0 640 200H715").hide();
    var len1 = p1.getTotalLength();

    var ps2 = paper.path("M390 410V300H270A30 30 0 1 0 300 330V200").hide();
    var p2  = paper.path("M390 410V300H270A30 30 0 1 0 300 330V200").hide();
    var len2 = p2.getTotalLength();

    // animation paths
    var as1 = paper.path().attr({stroke: "#333", 'stroke-linejoin': "round", 'stroke-width': 9, 'stroke-opacity': 0.3});
    var a1 = paper.path().attr({stroke: "#d33848", 'stroke-linejoin': "round", 'stroke-width': 9});   
    var img1 = paper.image(card1[0].src,710,116,card1.attr('width'),card1.attr('height')).attr({transform: 's1,1,720,200t-50,0', opacity: 0});
   
    paper.ca.ca1 = function (per) {
	var subpath = p1.getSubpath(0, per * len1);
        return {
            path: subpath
        };
    };
    paper.ca.cas1 = function (per) {
        var subpath = ps1.getSubpath(0, per * len1);
        return {
            path: Raphael.transformPath(subpath,"t5,5")
        };
    };
    a1.attr({ca1: 0});
    as1.attr({cas1: 0});


    var as2 = paper.path().attr({stroke: "#333", 'stroke-linejoin': "round", 'stroke-width': 9, 'stroke-opacity': 0.3});
    var a2 = paper.path().attr({stroke: "#0cacdc", 'stroke-linejoin': "round", 'stroke-width': 9});   
    var img2 = paper.image(card2[0].src,200,100,card2.attr('width'),card2.attr('height')).attr({transform: 't0,50', opacity: 0});
   
    paper.ca.ca2 = function (per) {
	var subpath = p2.getSubpath(0, per * len2);
        return {
            path: subpath
        };
    };
    paper.ca.cas2 = function (per) {
        var subpath = ps2.getSubpath(0, per * len2);
        return {
            path: Raphael.transformPath(subpath,"t5,5")
        };
    };
    a2.attr({ca2: 0});
    as2.attr({cas2: 0});

    // animations
    a1.animate({ca1: 1},1.5e3, "backIn", function(){
        img1.animate({transform: 's1,1,710,200,t0,0', opacity:1},500,"backOut");
    });
    as1.animate({cas1: 1},1.5e3, "backIn");
    setTimeout(function(){
        img1.animate({transform: 's1,1,710,200,t-50,0', opacity:0},500,"backIn",function(){
	    a1.animate({ca1: 0},1e3, "backOut");
            as1.animate({cas1: 0},1e3, "backOut");
	});
    },5000);


    var anim2 = Raphael.animation({ca2: 1},1.5e3, "backIn", function(){
	img2.animate({transform: 't0,0', opacity:1},500,"backOut");
    });
    a2.animate(anim2.delay(1e3));
    var anims2 = Raphael.animation({cas2: 1},1.5e3, "backIn");
    as2.animate(anims2.delay(1e3));
    var animi2 = Raphael.animation({transform: 't0,50', opacity:0},500,"backIn",function(){
	    a2.animate({ca2: 0},1e3, "backOut");
            as2.animate({cas2: 0},1e3, "backOut");
    });
    setTimeout(function(){
	img2.animate(animi2); // delay 6e3 not working here...
    },6000);
});

