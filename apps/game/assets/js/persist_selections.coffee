#= require lib/jquery.cookie

$.cookie.json = true

persisted_selections = $.cookie('persisted_selections') ? {}

window.hydrate_persisted_selections = ->
  for key, val of persisted_selections
    if key?.length and key isnt 'undefined'
      $select = $("select[data-persist=#{key}]").val(val)
window.hydrate_persisted_selections()

$('form').submit (event) ->
  $form = $(@)
  select_boxes = $form.find('select')
  select_boxes.each ->
    $select = $(@)
    $selected = $select.children('option:selected')
    persisted_selections[$select.data('persist')] = $selected.val()
  $.cookie 'persisted_selections', persisted_selections
