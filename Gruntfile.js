module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      scripts: {
        files: ['Trixel/**/*.elm'],
        tasks: ['shell'],
        options: {
          spawn: true,
        },
      },
    },

    shell: {
        options: {
            stderr: false
        },
        target: {
            command: 'elm-make Trixel/Main.elm'
        }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  // Default task(s).
  grunt.registerTask('default', ['shell']);

};