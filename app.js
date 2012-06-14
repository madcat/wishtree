
var express = require('express'),
  fs = require('fs'),
  settings = require('./settings'),
  mysql = require('mysql'),
  uuid = require('node-uuid'),
  fs = require('fs'),
  path = require('path');

  
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
db.query('USE ' + settings.db_name, function(err,result){});

// TEST API

app.get('/', function(req, res){
  res.json({'status': 'success', 'body': 'The REST API is working!'});
});

// GET => READ
app.get('/wishes/:id?',function(req, res){
  var sql;
  if (req.params.id) {
    sql = "SELECT * FROM " + settings.db_table + " WHERE id = " + req.params.id;
    db.query(sql,function(err,rows){
      if (!err) {
        res.json({'status': 'success', 'body': rows[0]});
      } else {
        console.log(sql);
        res.json({'status': 'error','body': err.code});
      }
    });
  } else {
    sql = "SELECT * FROM " + settings.db_table + " ORDER BY id";
    db.query(sql,function(err,rows){
      if (!err) {
        res.json({'status': 'success', 'body': rows});
      } else {
        res.json({'status': 'error','body': err.code});
      }
    });
  }
});

app.get('/ids',function(req,res){
  var sql = "SELECT id FROM " + settings.db_table + " ORDER BY id";
  db.query(sql,function(err,rows){
      if (!err) {
        var arr = [];
        for (var i = 0; i < rows.length; i++) {
          arr.push(rows[i].id);
        }
        res.json({'status': 'success', 'body': arr});
      } else {
        console.log(sql);
        res.json({'status': 'error','body': err.code});
      }
    });
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
          node_path + "','" + req.body.text + "')",function(err,result){
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
            res.json({'status': 'error','body': err.code});
          }
        });
      } else {
        res.json({'status': 'error','body': err});
      } 
    });
  });
});

// PUT => UPDATE

app.put('/wishes/:id',function(req,res){
  db.query("UPDATE " + settings.db_table + 
      " SET is_show = " + req.body.show + 
      " WHERE id = " + req.params.id,function(err,result){
    if (!err) {
      res.json({'status': 'success', 'body': result});
    } else {
      res.json({'status': 'error','body': err.code});
    }
  });
});

// =================== PORT ===============
app.listen(3000);

