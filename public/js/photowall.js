var grid = {}
grid.controller = function(){
  var c = this
  c.guests = m.prop([])
  c.getGuests = function(){
    m.request({method:"GET", url:"/wishes"}).then(function(data){
      c.guests(data.body)
      var n = 376 - c.guests().length
      if (n > 0){
        for(i=0;i<n;i++){
          c.guests().push(c.guests()[Math.floor(Math.random()*c.guests().length)])
        }
      }
    })
  }
  c.getGuests()
}
grid.view = function(ctrl){
  return m(".container", [
    m(".grid", [
      ctrl.guests().map(function(g){
        return m(".cell-box", [
          m("img.cell.cell-on", {id:"g"+g.id, src:"/"+g.pic_path})
        ])
      })
    ])
  ])
}

m.mount(document.getElementById("content"), grid);