#= require lib/jquery.cookie

$.cookie.json = true

persisted_selections = $.cookie('persisted_selections') ? {}
for key, val of persisted_selections
  $("select[data-persist=#{key}]").val(val)

$('form').submit (event) ->
  $form = $(@)
  select_boxes = $form.children('select')
  select_boxes.each ->
    $select = $(@)
    $selected = $select.children('option:selected')
    persisted_selections[$select.data('persist')] = $selected.val()
  $.cookie 'persisted_selections', persisted_selections
