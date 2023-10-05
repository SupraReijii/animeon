const webpack = require('webpack');
const { environment } = require('@rails/webpacker')
const path = require('path');

const coffeeLoader = require('./loaders/coffee');
environment.loaders.append('coffee', coffeeLoader);

module.exports = environment
