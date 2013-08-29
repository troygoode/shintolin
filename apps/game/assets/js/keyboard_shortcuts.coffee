$(document.body).bind 'keyup', (event) ->
  return unless event.srcElement.localName is 'body'
  return if event.altKey or event.ctrlKey or event.metaKey or event.shiftKey
  switch event.keyCode
    when 81 then $('.movebutton[data-direction=nw]').trigger 'click' #q
    when 87 then $('.movebutton[data-direction=n]').trigger 'click' #w
    when 75 then $('.movebutton[data-direction=n]').trigger 'click' #k (vim-style!)
    when 69 then $('.movebutton[data-direction=ne]').trigger 'click' #e
    when 65 then $('.movebutton[data-direction=w]').trigger 'click' #a
    when 72 then $('.movebutton[data-direction=w]').trigger 'click' #h (vim-style!)
    when 68 then $('.movebutton[data-direction=e]').trigger 'click' #d
    when 76 then $('.movebutton[data-direction=e]').trigger 'click' #l (vim-style!)
    when 90 then $('.movebutton[data-direction=sw]').trigger 'click' #z
    when 83 then $('.movebutton[data-direction=s]').trigger 'click' #s
    when 88 then $('.movebutton[data-direction=s]').trigger 'click' #x
    when 74 then $('.movebutton[data-direction=s]').trigger 'click' #j (vim-style!)
    when 67 then $('.movebutton[data-direction=se]').trigger 'click' #c
    when 70 then $('.movebutton[data-direction=enterexit]').trigger 'click' #f
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
