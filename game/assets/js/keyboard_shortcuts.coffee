$(document.body).bind 'keyup', (event) ->
  switch event.keyCode
    when 81 then $('.movebutton[data-direction=nw]').trigger 'click'
    when 87 then $('.movebutton[data-direction=n]').trigger 'click'
    when 69 then $('.movebutton[data-direction=ne]').trigger 'click'
    when 65 then $('.movebutton[data-direction=w]').trigger 'click'
    when 68 then $('.movebutton[data-direction=e]').trigger 'click'
    when 90 then $('.movebutton[data-direction=sw]').trigger 'click'
    when 88 then $('.movebutton[data-direction=s]').trigger 'click'
    when 67 then $('.movebutton[data-direction=se]').trigger 'click'
