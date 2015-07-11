module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      scripts: {
        files: [
          'src/Trixel/**/*.elm',
          'src/**/*.html',
          'src/**/*.css',
          'src/Native/*.js',
          ],
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
            command: 'elm-make src/Trixel/Main.elm --output src/Out/Trixel.js'
        }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  // Default task(s).
  grunt.registerTask('default', ['shell']);

  grunt.task.run(['shell'])
};