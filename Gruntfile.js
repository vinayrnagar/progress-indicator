module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concat: {
      options: {
        separator: ';'
      },
      dist: {
        src: ['app/*.js app/**/*.js'],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
      },
      dist: {
        files: {
          'dist/<%= pkg.name %>.min.js': ['<%= concat.dist.dest %>']
        }
      }
    },
    karma: {
      unit: {
        configFile: 'karma.conf.coffee',
        singleRun: true
      }
    },
    coffee: {
      compile: {
        files: {
          'dist/<%= pkg.name %>.js': ['app/*.coffee', 'app/**/!(*spec).coffee']
        }
      },
      compileForTests: {
        expand: true,
        flatten: true,
        cwd: 'app/',
        src: ['**/*.coffee'],
        dest: 'compiled_for_tests/',
        ext: '.js'
      },
    },
    less: {
      compile: {
        files: {
          'dist/<%= pkg.name %>.css': 'app/**/*.less'
        }
      }
    },
    clean: ["node_modules", "compiled_for_tests"]
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-karma');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('test', ['coffee:compileForTests', 'karma']);
  grunt.registerTask('build', ['coffee:compile', 'less:compile', 'uglify:dist']);

};
