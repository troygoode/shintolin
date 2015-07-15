config = require './config'
ms_in_a_day = 1000 * 60 * 60 * 24

calculate_year_exact = (now) ->
  origin = new Date(Date.UTC(2009, 2, 28))
  ms = now.getTime() - origin.getTime()
  real_life_days = Math.ceil(ms / ms_in_a_day)
  real_life_days / 12 # 3 days for each of 4 seasons

calculate_year = (now) ->
  year = calculate_year_exact now
  Math.floor year

calculate_month_exact = (now) ->
  year = calculate_year_exact now
  Math.floor((year - Math.floor(year)) * 12)

calculate_month = (now) ->
  temp = calculate_month_exact now
  switch temp
    when 0, 3, 6, 9
      'Early'
    when 1, 4, 7, 10
      'Mid'
    when 2, 5, 8, 11
      'Late'

calculate_season = (now) ->
  temp = calculate_month_exact now
  switch temp
    when 0, 1, 2
      'Spring'
    when 3, 4, 5
      'Summer'
    when 6, 7, 8
      'Autumn'
    when 9, 10, 11
      'Winter'

calculate_date = (now) ->
  "#{calculate_year now}, #{calculate_month now} #{calculate_season now}"

module.exports = (now) ->
  now ?= config.now()
  now: now
  month: calculate_month now
  season: calculate_season now
  year: Math.floor(calculate_year now)
