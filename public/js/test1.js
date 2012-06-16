
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
        path: "M465 310V185H400A20 20 0 1 1 420 165V205H330",
        shadow: "M465 310V185H400A20 20 0 1 1 420 165V205H330",
        orientation: 'left',
        path_end_x: 325,
        path_end_y: 205,
        font_color: "#000",
        line_color: "#ffe807",
        bg_img: "img/yellow.png",
        bias: "-50,0"
    },
    {
        path: "M510 285V165H570A20 20 0 1 1 550 185V145H650",
        shadow: "M510 285V165H570A20 20 0 1 1 550 185V145H650",
        orientation: 'right',
        path_end_x: 645,
        path_end_y: 145,
        font_color: "#fff",
        line_color: "#0cacdb",
        bg_img: "img/blue.png",
        bias: "-50,0"
    },
    {
        path: "M440 335V390H385V425A20 20 0 1 0 405 405H300",
        shadow: "M440 335V390H385V425A20 20 0 1 0 405 405H300",
        orientation: 'left',
        path_end_x: 295,
        path_end_y: 405,
        font_color: "#000",
        line_color: "#e0002a",
        bg_img: "img/red.png",
        bias: "-50,0"
    },
    {
        path:"M535 430V345A20 20 0 1 0 515 365H555V315H640",
        shadow: "M535 430V345A20 20 0 1 0 515 365H555V315H640",
        orientation: 'right',
        path_end_x: 635,
        path_end_y: 315,
        font_color: "#000",
        line_color: "#43b133",
        bg_img: "img/green.png",
        bias: "-50,0"
    },
    {
        path: "M420 480H350A20 20 0 1 0 370 500V450H250",
        shadow: "M420 480H350A20 20 0 1 0 370 500V450H250",
        orientation: 'left',
        path_end_x: 245,
        path_end_y: 450,
        font_color: "#000",
        line_color: "#ffffff",
        bg_img: "img/white.png",
        bias: "-50,0"
    },
    {
        shadow: "M605 355V455H660V490A20 20 0 1 1 640 470H720",
        path: "M605 355V455H660V490A20 20 0 1 1 640 470H720",
        orientation: 'right',
        path_end_x: 715,
        path_end_y: 470,
        font_color: "#000",
        line_color: "#43b133",
        bg_img: "img/green.png",
        bias: "-50,0"
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

    // random scale from 0.7 to 1.0
    this.scale = Math.ceil(6 + Math.random() * 4) / 10;
    var real_w = Math.floor(CARD_W * this.scale); 
        real_h = Math.floor(CARD_H * this.scale);
    if (this.param.orientation == 'left') {
        this.card_x = Math.floor(this.param.path_end_x - real_w) + 20;
        this.card_y = Math.floor(this.param.path_end_y - real_h / 2);
    } else if (this.param.orientation == 'right') {
        this.card_x = this.param.path_end_x;
        this.card_y = Math.floor(this.param.path_end_y - real_h / 2);
    }
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
        this.paper.image(this.param.bg_img,this.card_x,this.card_y,CARD_W,CARD_H),
        this.paper.image(this.wish.pic_path,this.card_x+15,this.card_y+50,PHOTO_W,PHOTO_H),
        this.paper.image(text_img,this.card_x+125,this.card_y+60,$("#text_canvas")[0].width,$("#text_canvas")[0].height)
    );
    this.card.attr({'opacity':0,'transform': 's' + this.scale + ',' + this.scale + ',' + this.card_x + ',' + this.card_y + 't' + this.param.bias});

    // draw full path
    var len_path = this.path.getTotalLength();
        len_shadow = this.shadow.getTotalLength();
    // animation paths
    this.shadow_anim.attr({stroke: "#333", 'stroke-linejoin': "round", 'stroke-width': 9, 'stroke-opacity': 0.3});
    this.path_anim.attr({stroke: this.param.line_color, 'stroke-linejoin': "round", 'stroke-width': 9});
   
    var self = this;
    var path_attr = "ca" + this.idx,
        shadow_attr = "cas" + this.idx;
    var attr_obj1 = {},attr_obj2 = {},attr_obj3 = {},attr_obj4 = {};
    attr_obj1[path_attr] = 0;
    attr_obj2[shadow_attr] = 0;
    attr_obj3[path_attr] = 1;
    attr_obj4[shadow_attr] = 1;
    this.paper.ca[path_attr] = function (per) {
        var subpath = self.path.getSubpath(0, per * len_path);
        return {
            path: subpath
        };
    };
    this.paper.ca[shadow_attr] = function (per) {
        var subpath = self.shadow.getSubpath(0, per * len_shadow);
        return {
            path: Raphael.transformPath(subpath,"t5,5")
        };
    };
    this.path_anim.attr(attr_obj1);
    this.shadow_anim.attr(attr_obj2);

    // animations
    this.path_anim.animate(attr_obj3,4e3, "backIn");
    this.shadow_anim.animate(attr_obj4,4e3, "backIn",function(){
       self.card.animate({transform: 's' + self.scale + ',' + self.scale + ','  + self.card_x + ',' + self.card_y + 't0,0', opacity:1},500,"backOut"); 
    });
    setTimeout(function(){
        animating_idx_arr.shift();
        self.card.animate({transform: 's' + self.scale + ',' + self.scale + ','  + self.card_x + ',' + self.card_y + 't' + self.param.bias, opacity:0},500,"backIn",function(){
            self.path_anim.animate(attr_obj1,4e3, "backOut");
            self.shadow_anim.animate(attr_obj2,4e3, "backOut",function(){
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
    },12000);
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
        wrapText(context,text2,0,30,150,25,true);
    } else {
        context.font = "14pt Arial";
        wrapText(context,text2,0,30,150,20,false);
    }
    return c.toDataURL("image/png");
}


$(document).ready(function(){

    // update database to local storage
    $.ajax({
        type: 'GET',
        url: "http://localhost:3000/wishes",
        dataType: 'json',
        success: function(json) {
            if (json.status == "success") {
                store.setItem('local_wish',JSON.stringify(json.body));
            }
        }
    });

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

    // background animation
    var width = canvas.width(), height = canvas.height();

    var grid = [
        0,2,0,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,2,1,3,2,1,4,0,0,2,2,4,4,2,
        2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,1,3,2,1,4,0,0,2,1,1,4,0,2,
        4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,4,0,3,2,2,1,3,4,1,3,3,2,1,
        2,3,1,0,4,3,2,1,2,3,4,4,2,2,1,3,2,1,3,2,1,0,2,2,3,3,4,3,1,0,0,2,
        2,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,4,3,4,4,3,4,3,3,2,2,3,4,4,0,2,3,
        4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,4,1,2,3,2,2,2,3,1,3,2,4,3,2,
        0,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,0,2,3,2,1,3,3,1,4,3,0,2,2,4,4,2,
        2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,3,3,4,1,3,2,1,2,0,0,2,2,1,1,2,2,
        4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,3,2,3,4,0,2,3,3,1,3,1,2,3,3,2,1,
        2,3,1,1,4,3,2,1,2,3,4,4,3,2,1,3,2,1,4,2,1,0,2,3,0,3,4,3,1,0,0,2,
        2,1,3,2,1,4,0,0,1,2,1,0,4,2,2,4,0,3,1,0,3,4,3,4,1,2,3,4,4,0,2,3,
        4,0,0,2,2,1,0,2,2,3,4,4,2,3,1,3,2,1,3,2,2,3,1,3,4,3,2,1,2,4,3,1,
        0,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,3,0,3,3,1,3,2,3,3,1,0,2,2,4,4,2,
        2,2,1,3,4,3,1,0,2,3,3,1,4,3,2,3,2,3,4,1,3,2,1,4,0,2,2,3,1,4,2,2,
        4,3,1,0,2,3,1,1,4,4,2,1,2,3,0,4,3,3,3,4,0,3,2,2,1,3,1,2,3,3,2,1,
        2,0,1,1,4,3,2,1,2,3,4,4,2,3,1,3,2,1,4,2,3,2,3,1,3,2,2,3,0,4,3,1,
        2,1,3,2,1,4,0,0,2,2,1,0,4,2,1,3,4,3,2,3,2,3,3,0,2,3,2,1,2,3,4,4,
        4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,3,4,3,2,0,2,3,4,4,2,2,1,3,2,
        0,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,3,2,3,1,4,3,3,1,2,2,1,4,0,3,2,2,
        2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,0,2,2,1,3,2,1,4,0,3,2,2,1,
        4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,3,2,1,4,0,0,2,2,1,3,1,2,3,
        2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,4,3,1,
        2,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,
        4,0,0,2,2,1,3,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,3,2,
        4,0,3,2,2,1,0,3,2,1,2,3,4,4,2,2,1,3,2,1,2,2,1,3,4,3,1,0,2,3,1,1,
        3,1,4,2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,
        4,0,0,2,2,1,0,2,2,1,3,4,3,4,4,2,2,1,3,2,1,3,1,0,2,3,1,1,4,3,2,1,
        2,2,1,3,4,3,1,0,4,0,0,2,2,1,0,2,3,1,1,4,3,2,1,2,3,4,4,2,2,1,3,2,
        4,2,2,1,3,2,1,4,1,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,1,4,4,2,3,2,3,
        4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,1,4,3,2,1,2,3,4,4,4,4,2,3,2,
        2,1,2,3,3,4,2,2,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,3,1,1,2,
        2,1,2,3,4,3,2,1,1,3,2,1,4,0,0,2,2,1,0,2,2,1,3,4,3,1,0,2,1,3,2,4
    ];
    var lightGrid = new Array();
    var cellWidth = 24;
    var lightWidth = 30;
    var ligthOffSet = Math.floor((cellWidth - lightWidth)/2);
    var ncol = Math.floor(Math.sqrt(grid.length));
    var nrow = Math.floor(Math.sqrt(grid.length));
    var colors = ['#ffffff', '#e0002a', '#43b133', '#0cacdb', '#ffe807'];
    var randomness = [0,1,1,2,2,3,3,3,4]; // chance of each color
    var lightSpeed = 16; // lights per lightFrame interval
    var lightFrame = 24; // 
    var lightFadeTime = 2e3;
    var drawInterval = 16.666666;
    
    var backc = document.createElement('canvas');
    backc.width = width;
    backc.height = height;
    var backctx = backc.getContext('2d');

    drawGrid();

    buildLight();

    var dataURL = backc.toDataURL();
    document.getElementById("gridImg").src = dataURL;

    function drawGrid() {
        for (r=0;r<nrow;r++) {
            for (c=0;c<ncol;c++) {
                backctx.fillStyle = colors[grid[r*ncol + c]];
                backctx.fillRect(cellWidth * c, cellWidth * r, cellWidth, cellWidth);
            }
        }
    }

    function buildLight() {
        for (r=0;r<nrow;r++) {
            for (c=0;c<ncol;c++) {
                var color = grid[r * ncol + c];
                var img = $("<img src='img/"+color+".png'/>").appendTo("#light").css({opacity:0, position:'absolute', x:c*cellWidth + ligthOffSet, y:r*cellWidth + ligthOffSet});
                lightGrid[r * ncol + c] = img;
            }
        }
    }

    function drawLight() {

        for(i=0;i<lightSpeed;i++) {
            var irow = 5 + Math.floor(Math.random() * 20);
            var icol = 11 + Math.floor(Math.random() * 20);
            var img = lightGrid[irow * ncol + icol];
            
            // transit anim
            img.transit({opacity:1}, lightFadeTime/2, "out").transit({opacity:0, delay:1e3}, lightFadeTime/2, "in", function(){});
            
        }

        setTimeout(drawLight, lightFrame * drawInterval);
    }
    drawLight();

    // fps
    var fpsLabel = document.getElementById("fps");
    var frameCount = 0;
    var fps = 0;
    var lastTime = new Date();
    var nowTime = lastTime;
    var diffTime = 0;
    var stop = false;

    function render_fps() {
        nowTime = new Date();
        diffTime = Math.ceil((nowTime.getTime() - lastTime.getTime()));

        if (diffTime >= 1000) {
            fps = frameCount;
            fpsLabel.innerHTML = 'FPS: ' + fps;
            frameCount = 0;
            lastTime = nowTime;
        }

        frameCount++;

        if(!stop) requestAnimationFrame(render_fps) 
    }
    requestAnimationFrame(render_fps);

    // wish animation
    function render_wish() {
        if (animating_idx_arr.length >= MAX_ANIMATION) {
            setTimeout(render_wish,1000);
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
        if (wish) {
            if (wish.is_animate) {
                setTimeout(render_wish,1000);
                return;
            }
            var idx = now_play_type % MAX_TYPE;
            now_play_type = (now_play_type + 1) % MAX_TYPE;
            var anim = new WishAnim(paper,wish,idx,type);
            anim.animate_wish();
        }

        setTimeout(render_wish,2000);
    }
    render_wish();
});