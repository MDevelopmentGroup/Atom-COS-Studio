var util = require('util');

exports.isObject = function(raw) {
  if (!raw) return false;
  if (typeof(raw) !== 'object') return false;
  if (util.isArray(raw)) return false;
  return true;
}

exports.isVaildObject = function(raw) {
  if (!exports.isObject(raw)) return false;
  if (Object.keys(raw).length === 0) return false;
  return true;
}

exports.mergeObject = function(before, data) {
  Object.keys(data).forEach(function(item){
    before[item] = data[item];
  });
  return before;
}