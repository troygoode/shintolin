ms_in_a_day = 1000 * 60 * 60 * 24

calculate_year = (now) ->
  origin = new Date(2009, 2, 28)
  ms = now.getTime() - origin.getTime()
  real_life_days = Math.ceil(ms / ms_in_a_day)
  real_life_days / 12 # 3 days for each of 4 seasons

calculate_month = (now) ->
  year = calculate_year now
  temp = Math.floor((year - Math.floor(year)) * 12)
  switch temp
    when 0, 3, 6, 9
      'Early'
    when 1, 4, 7, 10
      'Mid'
    when 2, 5, 8, 11
      'Late'

calculate_season = (now) ->
  year = calculate_year now
  temp = (year - Math.floor(year)) * 12
  if temp <= 3
    'Winter'
  else if temp <= 6
    'Spring'
  else if temp <= 9
    'Summer'
  else
    'Autumn'

calculate_date = (now) ->
  "#{Math.floor(calculate_year now)}, #{calculate_month now} #{calculate_season now}"

module.exports = (now) ->
  now: now
  month: calculate_month now
  season: calculate_season now
  year: Math.floor(calculate_year now)
