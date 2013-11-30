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

  next()
