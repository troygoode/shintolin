data = require '../../../data'
vowels = 'aeiou'.split('')

module.exports = (req, res, next) ->

  res.locals.object_to_array = (obj, cb) ->
    cb ?= (key, value) ->
      key: key
      value: value
    arr = []
    for key, value of obj
      arr.push cb(key, value)
    arr

  res.locals.describe_list = (arr) ->
    if arr.length is 1
      arr[0]
    else if arr.length is 2
      "#{arr[0]} and #{arr[1]}"
    else
      retval = ''
      for o, i in arr
        if i is arr.length - 1
          retval += "and #{o}"
        else
          retval += "#{o}, "
      retval

  res.locals.describe_item = (item_type, quantity = 1) ->
    item = data.items[item_type]
    if quantity is 1 and vowels.indexOf(item.name[0]) is -1
      "a #{item.name}"
    else if quantity is 1
      "an #{item.name}"
    else
      "#{quantity}x #{item.plural}"

  res.locals.describe_gives = (gives) ->
    arr = []
    arr.push res.locals.describe_item(item_type, quantity) for item_type, quantity of gives?.items ? []
    return res.locals.describe_list(arr)

  next()
