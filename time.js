"use strict";

const config = require('./config')

const msInADay = 1000 * 60 * 60 * 24;

const calculateYearExact = (now) => {
  const origin = new Date(Date.UTC(2009, 2, 16));
  const ms = now.getTime() - origin.getTime();
  const realLifeDays = Math.ceil(ms / msInADay);
  return realLifeDays / 12; // 3 days for each of 4 seasons
};

const calculateYear = (now) => {
  const year = calculateYearExact(now);
  return Math.floor(year);
};

const calculateMonthExact = (now) => {
  const year = calculateYearExact(now);
  return Math.floor((year - Math.floor(year)) * 12);
};

const calculateMonth = (now) => {
  const temp = calculateMonthExact(now);
  switch(temp) {
    case 0:
    case 3:
    case 6:
    case 9:
      return 'Early';
    case 1:
    case 4:
    case 7:
    case 10:
      return 'Mid';
    case 2:
    case 5:
    case 8:
    case 11:
      return 'Late';
  }
};

const calculateSeason = (now) => {
  const temp = calculateMonthExact(now);
  switch(temp) {
    case 0:
    case 1:
    case 2:
      return 'Spring';
    case 3:
    case 4:
    case 5:
      return 'Summer';
    case 6:
    case 7:
    case 8:
      return 'Autumn';
    case 9:
    case 10:
    case 11:
      return 'Winter';
  }
};

const calculateDate = (now) => {
  return `${calculateYear(now)}, ${calculateMonth(now)} ${calculateSeason(now)}`;
};

module.exports = (optionsNow) => {
  var now = optionsNow || config.now();

  return {
    now: now,
    month: calculateMonth(now),
    season: calculateSeason(now),
    year: Math.floor(calculateYear(now))
  };
};
