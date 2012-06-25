
var express = require('express'),
  fs = require('fs'),
  settings = require('./settings'),
  mysql = require('mysql'),
  uuid = require('node-uuid'),
  fs = require('fs'),
  path = require('path'),
  us = require('underscore');

  
var log_file = fs.createWriteStream('./wishlist.log',{flags: 'a'});
var app = module.exports = express.createServer();
var io = require('socket.io').listen(app);

// ================== Configuration ===========

app.configure(function(){
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.logger({format: '[:date] :method :status :url '}));
  app.use(express.static(__dirname + '/public'));
  app.set('view options', {layout: false});
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// ============ Routes For API ==================

var db = mysql.createConnection({
  host: settings.db_host,
  user: settings.db_login,
  password: settings.db_pass
});
db.connect(function(err){
  if (!err) {
    db.query('USE ' + settings.db_name, function(err,result){
      if (err) {
        console.log(err);
      }
    });
  } else {
    console.log(err);
  }
});

// TEST API

app.get('/', function(req, res){
  res.json({'status': 'success', 'body': 'The REST API is working!'});
});

// GET => READ
app.get('/wishes/:id?',function(req, res){
  var sql;
  if (req.params.id != undefined) {
    sql = "SELECT * FROM " + settings.db_table + " WHERE id = " + req.params.id;
    db.query(sql,function(err,rows){
      if (!err) {
        res.json({'status': 'success', 'body': rows[0]});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  } else {
    sql = "SELECT * FROM " + settings.db_table + " WHERE is_show = 1 ORDER BY id";
    db.query(sql,function(err,rows){
      if (!err) {
        res.json({'status': 'success', 'body': rows});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  }
});

app.get('/wishes_all',function(req, res){
  var sql;
  sql = "SELECT * FROM " + settings.db_table + " ORDER BY id";
  db.query(sql,function(err,rows){
    if (!err) {
      res.json({'status': 'success', 'body': rows});
    } else {
      console.log(err);
      res.json({'status': 'error','body': err.code});
    }
  });
});

app.get('/ids',function(req,res){
  var sql = "SELECT id,is_white FROM " + settings.db_table + " WHERE is_show = 1 ORDER BY id";
  db.query(sql,function(err,rows){
      if (!err) {
        var arr = {};
        arr['normal'] = us.pluck(us.filter(rows,function(row){return row.is_white == -1;}),'id');
        arr['white'] = us.filter(rows,function(row){return row.is_white != -1;});
        res.json({'status': 'success', 'body': arr});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
});

app.get('/show/:id?',function(req,res){
  var sql;
  console.log(req.params);
  if (req.params.id == undefined) {
    sql = "SELECT * FROM " + settings.db_table + " WHERE is_read = 1";
    db.query(sql,function(err,rows){
      if (!err) {
        res.json({'status': 'success', 'body': rows});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  } else {
    sql = "SELECT * FROM " + settings.db_table + " WHERE is_read = 1 AND id = " + req.params.id;
    db.query(sql,function(err,rows){
      if (!err) {
        io.sockets.emit('show_wish',rows[0]);
        res.json({'status': 'success', 'body': rows[0]});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  }
});

// POST => CREATE
app.post('/wishes',function(req,res){
  var new_name = uuid.v1() + ".jpg";
  var new_path = './public/' + settings.pic_path;
  var full_name = new_path + "/" + new_name;
  var node_path = settings.pic_path + "/" + new_name;
  path.exists(new_path, function(exist){
    if (!exist) {
      fs.mkdirSync(new_path);
    }
    fs.rename(req.files.pic_data.path, full_name,function(err){
      if (!err) {
        db.query("INSERT INTO " + settings.db_table + 
          "(first_name,last_name,pic_path,wish_text) " +
          " VALUES('" + req.body.fn  + "','" + req.body.ln + "','" +
          node_path + "','" + req.body.text.replace("'","\\'") + "')",function(err,result){
          if (!err) {
            var new_wish = {
              id: result.insertId,
              first_name: req.body.fn,
              last_name: req.body.ln,
              pic_path: node_path,
              wish_text: req.body.text,
              is_show: 1
            };
            io.sockets.emit('new_wish',new_wish);
            res.json({'status': 'success', 'body': result});
          } else {
            console.log(err);
            res.json({'status': 'error','body': err.code});
          }
        });
      } else {
        res.json({'status': 'error','body': err});
      } 
    });
  });
});

app.post('/luck/:action',function(req,res){
  if (req.params.action == 'start') {
    io.sockets.emit('luck_start');
    res.json({'status': 'success', 'body': ''});
  } else if (req.params.action == "stop111") {
    db.query("SELECT * FROM " + settings.db_table + " WHERE is_show = 1 ORDER BY id",function(err,rows){
      if (!err) {
        var luck = Math.floor(Math.random() * rows.length);
        io.sockets.emit('luck_stop',rows[luck]);
        res.json({'status': 'success', 'body': rows[luck]});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  } else {
    db.query("SELECT * FROM " + settings.db_table +" WHERE id = " + req.body.id,function(err,rows){
      if (!err) {
        if (req.params.action == "stop") {
          io.sockets.emit('luck_stop',rows[0]);
        } 
        // else if (req.params.action == "show") {
        //   io.sockets.emit('show_wish',rows[0]);
        // }
        res.json({'status': 'success', 'body': rows[0]});
      } else {
        console.log(err);
        res.json({'status': 'error','body': err.code});
      }
    });
  }
});


// PUT => UPDATE

app.put('/wishes/:id',function(req,res){
  db.query("UPDATE " + settings.db_table + 
      " SET is_show = " + req.body.show + 
      " WHERE id = " + req.params.id,function(err,result){
    if (!err) {
      io.sockets.emit('show_change',{id:req.params.id,show:req.body.show});
      res.json({'status': 'success', 'body': result});
    } else {
      console.log(err);
      res.json({'status': 'error','body': err.code});
    }
  });
});

// =================== PORT ===============
app.listen(3000);

