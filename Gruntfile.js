module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      all: {
        files: [
          'src/Trixel/**/*.elm',
          'src/*.html',
          'src/**/*.css',
          'src/Native/*.js',
          'tests/Tests/**/*.elm',
          ],
        tasks:
          [ 'shell'
          , 'htmlmin'
          , 'cssmin'
          , 'copy'
          , 'uglify'
          ],
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

    htmlmin: {
      dist: {
        options: {
          removeComments: true,
          collapseWhitespace: true,
          useShortDoctype: true,
        },
        files: {
          'dist/index.html': 'src/index.html',
        },
      },
    },

    cssmin: {
      options: {
        shorthandCompacting: false,
        roundingPrecision: -1
      },
      target: {
        files: {
          'dist/style.css':
            [ 'src/Libs/**/*.css'
            , 'src/Stylesheets/**/*.css'
            ]
        }
      }
    },

    copy: {
      main: {
        files: [
          { expand: true
          , flatten: true
          , src: ['src/Assets/**']
          , dest: 'dist/assets'
          , filter: 'isFile'
          },
        ]
      }
    },

    uglify: {
      options: {
        mangle: false,
      },
      dist: {
        files: {
          'dist/native.js':
            [ 'src/Libs/**/*.js'
            , 'src/Native/**/*.js'
            , 'src/Out/**/*.js'
            ]
        }
      }
    },
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-shell');

  // Custom Tasks
  grunt.registerTask('test', 'A task to compile the unit tests.', function() {
    grunt.task.run(['shell:tests'])
  });
};