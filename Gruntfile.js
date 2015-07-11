module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      scripts: {
        files: [
          'src/Trixel/**/*.elm',
          'src/*.html',
          'src/**/*.css',
          'src/Native/*.js',
          'tests/Tests/**/*.elm',
          ],
        tasks: ['shell:source', 'shell:tests'],
        options: {
          spawn: true,
          atBegin: true,
        },
      },
    },

    shell: {
        source: {
          command: function() {
            return 'cd src && elm-make Trixel/Main.elm --output Out/Trixel.js';
          }
        },
        tests: {
          command: function() {
            return 'cd tests && elm-make Tests/Main.elm --output Index.html';
          }
        },
    },
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-shell');

  // Custom Tasks
  grunt.registerTask('test', 'A task to compile the unit tests.', function() {
    grunt.task.run(['shell:tests'])
  });
};