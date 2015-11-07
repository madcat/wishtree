var grid = {}
grid.controller = function(){
  var c = this
  c.guests = m.prop([])
  c.getGuests = function(){
    m.request({method:"GET", url:"/wishes"}).then(function(data){
      c.guests(data.body)
      c.guests().push.apply(c.guests(), c.guests())
      c.guests().push.apply(c.guests(), c.guests())
      c.guests().push.apply(c.guests(), c.guests())
      c.guests().push.apply(c.guests(), c.guests())
      c.guests().push.apply(c.guests(), c.guests())
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