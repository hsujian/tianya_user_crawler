'use strict'

module.exports = (grunt) ->

  grunt.initConfig
    coffeelint:
      app: ['*.coffee']

  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'test', ['coffeelint']
  grunt.registerTask 'default', ['coffeelint']
