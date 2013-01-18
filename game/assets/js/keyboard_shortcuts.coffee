$(document.body).bind 'keyup', (event) ->
  return unless event.srcElement.localName is 'body'
  switch event.keyCode
    when 81 then $('.movebutton[data-direction=nw]').trigger 'click'
    when 87 then $('.movebutton[data-direction=n]').trigger 'click'
    when 69 then $('.movebutton[data-direction=ne]').trigger 'click'
    when 65 then $('.movebutton[data-direction=w]').trigger 'click'
    when 68 then $('.movebutton[data-direction=e]').trigger 'click'
    when 90 then $('.movebutton[data-direction=sw]').trigger 'click'
    when 83 then $('.movebutton[data-direction=s]').trigger 'click'
    when 88 then $('.movebutton[data-direction=s]').trigger 'click'
    when 67 then $('.movebutton[data-direction=se]').trigger 'click'
    when 80 #P
      if event.shiftKey
        $('[data-action-focus=paint]').focus()
      else
        $('input[data-action=paint]').trigger 'click'
    when 85 #U
      if event.shiftKey
        $('[data-action-focus=use]').focus()
      else
        $('input[data-action=use]').trigger 'click'
    when 75 #K
      if event.shiftKey
        $('[data-action-focus=attack]').focus()
      else
        $('input[data-action=attack]').trigger 'click'
    when 76 #L
      $('input[data-action=search]').trigger 'click'
