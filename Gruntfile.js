"use strict";


module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        connect: {
            server: {
                options: {
                    port: 8080,
                    base: './dist'
                }
            }
        },
	bower: {
	    install: {
	       //just run 'grunt bower:install' and you'll see files from your Bower packages in lib directory
	    }
	},
        copy: {
            main: {
                files: [
                    // includes files within path and its sub-directories
                    {
                        expand: true,
                        cwd: 'bower_components/jquery/dist',
                        src: ['**'],
                        dest: 'dist/lib/jquery/'
                    }, {
                        expand: true,
                        cwd: 'bower_components/magic',
                        src: ['*.css'],
                        dest: 'dist/lib/magic/'
                    }, {
                        expand: true,
                        cwd: 'bower_components/bootstrap/dist',
                        src: ['**'],
                        dest: 'dist/lib/bootstrap/'
                    }

                ]
            },
            resources: {
                files: [{
                    expand: true,
                    src: ['resources/**'],
                    dest: 'dist/'
                }]
            },
            wiki: {
                files: [{
                    expand: true,
                    src: ['wiki/**'],
                    dest: 'dist/'
                }]
            },
            htmlfiles: {
                files: [{
                    expand: true,
                    src: ['*.html', "*.css"],
                    dest: 'dist/',
                    filter: 'isFile'
                }],
                options: {
                    process: function(content, srcpath) {
                        var res = content.replace(/bower_components\/(.*)\/dist/g, "lib/\$1");
                        res = res.replace(/bower_components\/magic/g, "lib/magic");
                        return res;
                    }
                }
            }
        },


        watch: {
            files: ['**/*.html', "**/*.md", "**/*.css", "!dist/**"],
            tasks: ["copyfiles"]
        },

        open: {
            dev: {
                path: 'http://localhost:8080/'
            }
        }


    });

    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-open');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-bower-task');

    // Default task(s).
    grunt.registerTask('copyfiles', ['copy:main', 'copy:htmlfiles', "copy:resources", "copy:wiki"]);
    grunt.registerTask('default', ['bower:install','copyfiles', 'connect', 'open', "watch"]);
    grunt.registerTask('build', ['bower:install','copyfiles']);


};
