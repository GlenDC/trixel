module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    watch: {
      all: {
        files: [
          'src/Trixel/**/*.elm',
          'src/*.html',
          'src/**/*.sass',
          'src/Native/**/*.ls',
          'tests/Tests/**/*.elm',
          ],
        tasks: ['deploy'],
        options: {
          spawn: true,
          atBegin: true,
          debounceDelay: 1500,
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

    sass: {
      dist: {
        options: {
          compass: true,
          sourcemap: 'none',
        },
        files: {
          'src/Out/Main.css': 'src/Stylesheets/Main.sass'
        }
      }
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
            , 'src/Out/**/*.css'
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

    livescript: {
      src: {
        files: {
         'src/Out/Native.js': 'src/Native/**/*.ls'
        }
      }
    },

    uglify: {
      investigate: {
        options: {
          beautify: true,
        },
        src:
          [ 'src/Libs/*.js'
          , 'src/Out/Trixel.js'
          , 'src/Out/Native.js'
          ],
        dest: 'dist/native.js',
      },
      dev: {
        src:
          [ 'src/Libs/*.js'
          , 'src/Out/Trixel.js'
          , 'src/Out/Native.js'
          ],
        dest: 'dist/native.js',
      },
      release: {
        options: {
          mangle: true,
          compress: true,
        },
        src:
          [ 'src/Libs/*.js'
          , 'src/Out/Trixel.js'
          , 'src/Out/Native.js'
          ],
        dest: 'dist/native.js',
      },
    },

    clean : [
      "src/elm-stuff/build-artifacts",
      "tests/elm-stuff/build-artifacts",
      "tests/index.html",
      "dist",
      "src/Out",
    ],
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-livescript');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-shell');

  // Custom Tasks

  grunt.registerTask('test', 'A task to compile the unit tests.', function() {
    grunt.task.run(['shell:tests'])
  });

  grunt.registerTask('deploy', 'A task to compile the entire editor', function() {
    var release = grunt.option('release');
    var investigate = grunt.option('investigate');
    var target = investigate ? 'investigate' : (release ? 'release' : 'dev');
    grunt.task.run(
      [ 'shell'
      , 'htmlmin'
      , 'sass'
      , 'cssmin'
      , 'copy'
      , 'livescript'
      , 'uglify:' + target
      ])
  });
};