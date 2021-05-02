const { environment } = require('@rails/webpacker')

const sigmaConfig = require('./sigma')
environment.config.merge(sigmaConfig)

module.exports = environment
