// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')

const customConfig = {
  resolve: {
    extensions: ['.css', '.sass']
  }
}

const webpackConfig = generateWebpackConfig()

module.exports = webpackConfig
