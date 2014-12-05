#global module:false
module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-browserify"

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    browserify:
      addon:
        src: ["src/js/addon.js"]
        dest: "build/addon.js"
        options:
          alias: ["./src/js/addon.js:addon"]

          # wrapp as Taist addon
          postBundleCB: (err, src, next) ->
            src = "function init(){var " + src + ";return require(\"addon\")}"
            next err, src
            return

    concat:
      addon:
        src: [
          "build/addon.js"
          "src/lib/jquery-sortable.js"
        ]
        dest: "dist/addon.js"

  grunt.registerTask "default", [
    "browserify:addon"
    "concat:addon"
  ]
  return
