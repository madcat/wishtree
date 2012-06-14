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
        .animate({opacity: 1.0}, 300, function() {
            $active.removeClass('active last-active');
        });
}

// enum
var wish_type = {
    INCOMING: 1,
    LOCAL: 2,
    SHOW: 3
}

// local storage
var store = window.localStorage;
if (!store.getItem('local_wish')) {
    store.setItem('local_wish',"");
}
if (!store.getItem('incoming_wish')) {

    store.setItem('incoming_wish',"");
}

// store object
function add_obj(key,obj) {
    var arr;
    var s = store.getItem(key);
    if (s.length == 0) {
        arr = [];
    } else {
        arr = JSON.parse(s);
    }
    arr.push(obj);
    store.setItem(key,JSON.stringify(arr));
}

// shift object
function shift_obj(key) {
    var s = store.getItem(key);
    var arr = JSON.parse(s);
    var obj = arr.shift();
    if (arr.length== 0) {
        store.setItem(key,"");
    } else {
        store.setItem(key,JSON.stringify(arr));
    }
    return obj;
}

// change object attribute
function change_attr(key,wish,attr,value) {
    var s = store.getItem(key);
    var arr = JSON.parse(s);
    _.each(arr,function(ele){
        if (ele.id == wish.id) {
            ele[attr] = value;
        }
    });
    store.setItem(key,JSON.stringify(arr));

}

// sizes
var card_w = 300,
    card_h = 194,
    photo_w = 90,
    photo_h = 120;

// global
var now_animation_count = 0,
    MAX_ANIMATION = 4,
    now_play_id,
    animated_idx_arr = [],
    MAX_TYPE = 6,
    now_play_type = 0;

// wrap text in canvas
function wrapText(context, text, x, y, maxWidth, lineHeight, isChinese) {
    var words;
    if (isChinese) {
        words = text;
        gap = "";
    } else {
        words = text.split(" ");
        gap = " ";
    }
    var line = "";

    for(var n = 0; n < words.length; n++) {

        var testLine = line + words[n] + gap;
        var metrics = context.measureText(testLine);
        var testWidth = metrics.width;
        if(testWidth > maxWidth) {
            context.fillText(line, x, y);
            line = words[n] + gap;
            y += lineHeight;
        }
        else {
            line = testLine;
        }
    }
    context.fillText(line, x, y);
}

// transfrom text into image
function get_text_img(text1,text2) {
    var c = $("#text_canvas")[0];
    var context = c.getContext('2d');
    context.clearRect(0,0,c.width,c.height);
    context.font = "16pt Microsoft Yahei";
    context.textAlign = "left";
    context.textBaseline = "top";
    context.fillText(text1,0,0);
    var re = /.*[\u4e00-\u9fa5]+.*/;
    if (re.test(text2)) {
        context.font = "16pt Microsoft Yahei";
        wrapText(context,text2,0,30,140,20,true);
    } else {
        context.font = "14pt Arial";
        wrapText(context,text2,0,30,140,20,false);
    }
    return c.toDataURL("image/png");
}

// animation function
function animate_wish(paper,wish,type) {
    now_animation_count++;
    wish.is_animate = true;
    if (type == wish_type.INCOMING) {
        add_obj('local_wish',wish);
    }
    // generate card
    var font_color,line_color,bg,bias;
    var cx,cy;
    var idx = now_play_type % 6 + 1,
        scale = 1;//(7 + Math.random() * 3) / 10;
    now_play_type = idx;
    if(_.indexOf(animated_idx_arr,idx) != -1) {
        return;
    }
    animated_idx_arr.push(idx);
    switch (idx) {
        case 1: // top left, yellow
            ps = paper.path("M465 310V185H400A20 20 0 1 1 420 165V205H330").hide();
            p = paper.path("M465 310V185H400A20 20 0 1 1 420 165V205H325").hide();
            cx = 25;
            cy = 108;
            font_color = "#000";
            line_color = "#ffe807";
            bg = "img/yellow.png";
            bias = "-50,0";
            scale = 1;
            break;
        case 2: // top right, blue
            ps = paper.path("M510 285V165H570A20 20 0 1 1 550 185V145H650").hide();
            p = paper.path("M510 285V165H570A20 20 0 1 1 550 185V145H645").hide();
            cx = 645;
            cy = 48;
            font_color = "#fff";
            line_color = "#0cacdb";
            bg = "img/blue.png";
            bias = "-50,0";
            break;
        case 3: // middle left, red
            ps = paper.path("M440 335V390H385V425A20 20 0 1 0 405 405H300").hide();
            p = paper.path("M440 335V390H385V425A20 20 0 1 0 405 405H295").hide();
            cx = 0;
            cy = 328;
            font_color = "#000";
            line_color = "#e0002a";
            bg = "img/red.png";
            bias = "-50,0";
            scale = 1;
            break;
        case 4: // middle right, green
            ps = paper.path("M535 430V345A20 20 0 1 0 515 365H555V315H640").hide();
            p = paper.path("M535 430V345A20 20 0 1 0 515 365H555V315H635").hide();
            cx = 635;
            cy = 218;
            font_color = "#000";
            line_color = "#43b133";
            bg = "img/green.png";
            bias = "-50,0";
            break;
        case 5: // bottom left, white
            ps = paper.path("M420 480H350A20 20 0 1 0 370 500V450H200V430").hide();
            p = paper.path("M420 480H350A20 20 0 1 0 370 500V450H200V425").hide();
            cx = 50;
            cy = 240;
            font_color = "#000";
            line_color = "#ffffff";
            bg = "img/white.png";
            bias = "0,-50";
            scale = 1;
            break;
        case 6: // bottom right, green
            ps = paper.path("M605 355V455H660V490A20 20 0 1 1 640 470H720").hide();
            p = paper.path("M605 355V455H660V490A20 20 0 1 1 640 470H715").hide();
            cx = 715;
            cy = 373;
            font_color = "#000";
            line_color = "#43b133";
            bg = "img/green.png";
            bias = "-50,0";
            break;
    }
    // generate wish card
    paper.setStart();
    paper.image(bg,cx,cy,card_w,card_h);
    paper.image(wish.pic_path,cx+25,cy+50,photo_w,photo_h);
    var text_img = get_text_img(wish.first_name + "  " + wish.last_name, wish.wish_text);
    paper.image(text_img,cx+135,cy+60,$("#text_canvas")[0].width,$("#text_canvas")[0].height);
    var card = paper.setFinish();
    card.attr({'opacity':0,'transform': 's,' + scale + ',' + scale + ',' + cx + ',' + cy + 't' + bias});

    // draw full path
    var len = p.getTotalLength();
    // animation paths
    var as = paper.path().attr({stroke: "#333", 'stroke-linejoin': "round", 'stroke-width': 9, 'stroke-opacity': 0.3});
    var a = paper.path().attr({stroke: line_color, 'stroke-linejoin': "round", 'stroke-width': 9});
   
    paper.ca.ca = function (per) {
    var subpath = p.getSubpath(0, per * len);
        return {
            path: subpath
        };
    };
    paper.ca.cas = function (per) {
        var subpath = ps.getSubpath(0, per * len);
        return {
            path: Raphael.transformPath(subpath,"t5,5")
        };
    };
    a.attr({ca: 0});
    as.attr({cas: 0});

    // animations
    a.animate({ca: 1},1.5e3, "backIn", function(){
        card.animate({transform: 's1,1,' + cx + ',' + cy + 't0,0', opacity:1},500,"backOut");
    });
    as.animate({cas: 1},1.5e3, "backIn",function(){
        setTimeout(function(){
            card.animate({transform: 's1,1,' + cx + ',' + cy + 't' + bias, opacity:0},500,"backIn",function(){
                a.animate({ca: 0},1e3, "backOut");
                as.animate({cas: 0},1e3, "backOut",function(){
                    now_animation_count--;
                    animated_idx_arr.shift();
                    change_attr("local_wish",wish,"is_animate",false);
                    card.clear();
                });
            });
        },5000);
    });

}


$(document).ready(function(){

    setInterval( slideSwitch, 350 );

    var canvas = $("#canvas_container");
    var paper = Raphael(canvas.attr('id'),canvas.width(),canvas.height());

    // socket io
    var socket = io.connect('http://localhost:3000');
    socket.on('new_wish', function (data) {
        data.is_animate = false;
        add_obj('incoming_wish',data);
    });


    // main
    setInterval(function(){
        if (now_animation_count >= MAX_ANIMATION || animated_idx_arr.length == MAX_TYPE) {
            return;
        }
        var wish;
        if (store.getItem('incoming_wish').length > 0) {
            wish = shift_obj('incoming_wish');
            console.log(wish.first_name);
            animate_wish(paper,wish,wish_type.INCOMING);
        } else if (store.getItem('local_wish').length > 0) {
            var local_arr = JSON.parse(store.getItem('local_wish'));
            var sorted_wish = _.sortBy(local_arr,function(ele){return ele.id;});
            var id_arr = _.pluck(sorted_wish,'id');
            id_arr.sort();
            var min_id = sorted_wish[0].id;
            var max_id = sorted_wish[sorted_wish.length - 1].id;
            if (now_play_id == undefined || now_play_id == max_id) {
                now_play_id = min_id;
            } else {
                now_play_id = _.find(id_arr,function(ele){return ele > now_play_id;})
            }
            wish = _.find(sorted_wish,function(ele){return ele.id == now_play_id;});
            if (wish.is_animate) {
                return;
            }
            console.log(wish.first_name);
            animate_wish(paper,wish,wish_type.LOCAL);
        }
    }, 1000 );

});


