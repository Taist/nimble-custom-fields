#global module:false
module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks 'grunt-contrib-watch'


  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    coffee:
      addon:
        expand: true
        cwd: 'src/js/'
        src: ['**/*.coffee']
        dest: 'build/js/'
        ext: '.js'
        options:
          bare: true

    browserify:
      addon:
        cwd: "build/js/"
        src: ["addon.js"]
        dest: "build/addon.js"
        options:
          alias: ["./build/js/addon.js:addon"]

          # wrap as Taist addon
          postBundleCB: (err, src, next) ->
            src = "function init(){var " + src + ";return require(\"addon\")}"
            next err, src
            return

    concat:
      addon:
        src: [
          "build/addon.js"
          "src/lib/sample.js"
        ]
        dest: "dist/addon.js"

    watch:
      files: ['src/js/**/*.coffee']
      tasks: ['build']

  grunt.registerTask "default", [
    "build"
    "watch"
  ]

  grunt.registerTask "build", [
    "coffee:addon"
    "browserify:addon"
    "concat:addon"
  ]

  return
