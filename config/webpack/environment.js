const { environment } = require('@rails/webpacker')

const coffeeLoader = require('./loaders/coffee');
environment.loaders.append('coffee', coffeeLoader);

module.exports = environment
