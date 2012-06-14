function slideSwitch() {
    var $active = $('#bg IMG.active');

    if ( $active.length == 0 ) $active = $('#bg IMG:last');
    
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
var WISH_TYPE = {
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
var CARD_W = 300,
    CARD_H = 194,
    PHOTO_W = 90,
    PHOTO_H = 120;

// animation related
var now_play_id,
    animating_idx_arr = [],
    now_play_type = 0;

var MAX_ANIMATION = 4,
    MAX_TYPE = 6;

var path_map = {};

var PARAMS = [
    {
        shadow: "M465 310V185H400A20 20 0 1 1 420 165V205H330",
        path: "M465 310V185H400A20 20 0 1 1 420 165V205H325",
        card_x: 35,
        card_y: 108,
        font_color: "#000",
        line_color: "#ffe807",
        bg_img: "img/yellow.png",
        bias: "-50,0",
        scale: 1
    },
    {
        shadow: "M510 285V165H570A20 20 0 1 1 550 185V145H650",
        path: "M510 285V165H570A20 20 0 1 1 550 185V145H645",
        card_x: 645,
        card_y: 48,
        font_color: "#fff",
        line_color: "#0cacdb",
        bg_img: "img/blue.png",
        bias: "-50,0",
        scale: 1
    },
    {
        shadow: "M440 335V390H385V425A20 20 0 1 0 405 405H300",
        path: "M440 335V390H385V425A20 20 0 1 0 405 405H295",
        card_x: 10,
        card_y: 310,
        font_color: "#000",
        line_color: "#e0002a",
        bg_img: "img/red.png",
        bias: "-50,0",
        scale: 1
    },
    {
        shadow:"M535 430V345A20 20 0 1 0 515 365H555V315H640",
        path: "M535 430V345A20 20 0 1 0 515 365H555V315H635",
        card_x: 635,
        card_y: 218,
        font_color: "#000",
        line_color: "#43b133",
        bg_img: "img/green.png",
        bias: "-50,0",
        scale: 1
    },
    {
        pash_shadow: "M420 480H350A20 20 0 1 0 370 500V450H200V430",
        path: "M420 480H350A20 20 0 1 0 370 500V450H200V425",
        card_x: 50,
        card_y: 240,
        font_color: "#000",
        line_color: "#ffffff",
        bg_img: "img/white.png",
        bias: "0,-50",
        scale: 1
    },
    {
        pash_shadow: "M605 355V455H660V490A20 20 0 1 1 640 470H720",
        path: "M605 355V455H660V490A20 20 0 1 1 640 470H715",
        card_x: 715,
        card_y: 373,
        font_color: "#000",
        line_color: "#43b133",
        bg_img: "img/green.png",
        bias: "-50,0",
        scale: 1
    }           
]

// class for wish animation
function WishAnim(paper,wish,index,wish_type) {
    this.paper = paper;
    this.wish = wish;
    this.param = PARAMS[index];
    this.idx = index;
    this.wish_type = wish_type;
    this.card = this.paper.set();
    this.path = this.paper.getById(path_map['path'+this.idx]);
    this.shadow = this.paper.getById(path_map['shadow'+this.idx]);
    this.shadow_anim = this.paper.path();
    this.path_anim = this.paper.path();
}

WishAnim.prototype.animate_wish = function() {
    this.wish.is_animate = true;
    if (this.wish_type == WISH_TYPE.INCOMING) {
        add_obj('local_wish',this.wish);
    }
    animating_idx_arr.push(this.idx);
    
    // generate wish card
    var text_img = get_text_img(this.wish.first_name + "  " + this.wish.last_name, this.wish.wish_text,this.param.font_color);
    this.card.push(
        this.paper.image(this.param.bg_img,this.param.card_x,this.param.card_y,CARD_W,CARD_H),
        this.paper.image(this.wish.pic_path,this.param.card_x+15,this.param.card_y+50,PHOTO_W,PHOTO_H),
        this.paper.image(text_img,this.param.card_x+125,this.param.card_y+60,$("#text_canvas")[0].width,$("#text_canvas")[0].height)
    );
    this.card.attr({'opacity':0,'transform': 's1,1,' + this.param.card_x + ',' + this.param.card_y + 't' + this.param.bias});

    // draw full path
    var len_path = this.path.getTotalLength();
        len_shadow = this.shadow.getTotalLength();
    // animation paths
    this.shadow_anim.attr({stroke: "#333", 'stroke-linejoin': "round", 'stroke-width': 9, 'stroke-opacity': 0.3});
    this.path_anim.attr({stroke: this.param.line_color, 'stroke-linejoin': "round", 'stroke-width': 9});
   
    var self = this;
    this.paper.ca.ca = function (per) {
        var subpath = self.path.getSubpath(0, per * len_path);
        return {
            path: subpath
        };
    };
    this.paper.ca.cas = function (per) {
        var subpath = self.shadow.getSubpath(0, per * len_shadow);
        return {
            path: Raphael.transformPath(subpath,"t5,5")
        };
    };
    this.path_anim.attr({ca: 0});
    this.shadow_anim.attr({cas: 0});

    // animations

    // var anim1 = Raphael.animation({ca: 1},1500, "backIn");
    // var anim2 = Raphael.animation({cas: 1},1500, "backIn");
    // var anim3 = Raphael.animation({transform: 's1,1,' + self.param.card_x + ',' + self.param.card_y + 't0,0', opacity:1},500,"backOut");
    // var anim4 = Raphael.animation({transform: 's1,1,' + self.param.card_x + ',' + self.param.card_y + 't' + self.param.bias, opacity:0},500,"backIn");
    // var anim5 = Raphael.animation({ca: 0},1500, "backOut");
    // var anim6 = Raphael.animation({cas: 0},1500, "backOut");
    // this.path_anim.animate(anim1);
    // this.shadow_anim.animate(anim2);
    // this.card.animate(anim3.delay(600));
    // setTimeout(function(){
    //     console.log("===timeout===: " + self.idx);
    //     self.card.animate(anim4);
    //     self.path_anim.animate(anim5.delay(600));
    //     self.shadow_anim.animate(anim6.delay(600));
    //     animating_idx_arr.shift();
    //     change_attr("local_wish",self.wish,"is_animate",false);
    //     setTimeout(function(){
    //         self.card.forEach(function(ele){
    //             ele.remove();
    //         });
    //         self.path_anim.remove();
    //         self.shadow_anim.remove();
    //     },2000);
    // },5000);

    this.path_anim.animate({ca: 1},1500, "backIn");
    this.shadow_anim.animate({cas: 1},1500, "backIn",function(){
       self.card.animate({transform: 's1,1,' + self.param.card_x + ',' + self.param.card_y + 't0,0', opacity:1},500,"backOut"); 
    });
    setTimeout(function(){
        self.card.animate({transform: 's1,1,' + self.param.card_x + ',' + self.param.card_y + 't' + self.param.bias, opacity:0},500,"backIn",function(){
            self.path_anim.animate({ca: 0},1500, "backOut");
            self.shadow_anim.animate({cas: 0},1500, "backOut",function(){
                animating_idx_arr.shift();
                change_attr("local_wish",self.wish,"is_animate",false);
                setTimeout(function(){
                    self.card.forEach(function(ele){
                        ele.remove();
                    });
                    self.path_anim.remove();
                    self.shadow_anim.remove();
                },2000);
            });
        });
    },5000);
}

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
function get_text_img(text1,text2,color) {
    var c = $("#text_canvas")[0];
    var context = c.getContext('2d');
    context.clearRect(0,0,c.width,c.height);
    context.font = "16pt Microsoft Yahei";
    context.fillStyle = color;
    context.textAlign = "left";
    context.textBaseline = "top";
    context.fillText(text1,0,0);
    var re = /.*[\u4e00-\u9fa5]+.*/;
    if (re.test(text2)) {
        context.font = "16pt Microsoft Yahei";
        wrapText(context,text2,0,30,150,20,true);
    } else {
        context.font = "14pt Arial";
        wrapText(context,text2,0,30,150,20,false);
    }
    return c.toDataURL("image/png");
}


$(document).ready(function(){

    setInterval( slideSwitch, 350 );

    var canvas = $("#canvas_container");
    var paper = Raphael(canvas.attr('id'),canvas.width(),canvas.height());

    // draw all paths
    var path,shadow;
    for (var i = 0; i < PARAMS.length; i++) {
        path = paper.path(PARAMS[i].path).hide();
        shadow = paper.path(PARAMS[i].shadow).hide();
        path_map['path' + i] = path.id;
        path_map['shadow' + i] = shadow.id;
    }

    // socket io
    var socket = io.connect('http://localhost:3000');
    socket.on('new_wish', function (data) {
        data.is_animate = false;
        add_obj('incoming_wish',data);
    });

    // main
    setInterval( function(){
        if (animating_idx_arr.length >= MAX_ANIMATION) {
            return;
        }
        var wish,type;
        if (store.getItem('incoming_wish').length > 0) {
            wish = shift_obj('incoming_wish');
            type = WISH_TYPE.INCOMING;
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
            type = WISH_TYPE.LOCAL;
        }
        if (wish.is_animate) {
            console.log(wish.id);
            return;
        }
        var idx = now_play_type % MAX_TYPE;
        now_play_type = (now_play_type + 1) % MAX_TYPE;
        var anim = new WishAnim(paper,wish,idx,type);
        anim.animate_wish();
    }, 1000 );
});