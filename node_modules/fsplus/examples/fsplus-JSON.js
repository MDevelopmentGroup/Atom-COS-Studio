var fs = require('../index');

// read a JSON file
var configs = fs.readJSON('./configs.json');

// update values
configs.name = 'new Name';
configs.cache = false;

// rewrite config file
fs.writeJSON('./configs.json', configs);

// update by default
var newValues = fs.updateJSON('./configs.json', {
  name: 'new Name Again'
});

// let's check again:
console.log(newValues.name) // => 'new Name Again'