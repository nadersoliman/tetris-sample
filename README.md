## Global NPM Installations

```sh
sudo npm install -g grunt-cli
sudo npm install -g bower
```

## Application NPM Modules

```sh
cd tetris-sample
npm install
bower install
```

## Places of Interest

First you can see the sample in action 
[here](https://s3.amazonaws.com/static.kotobkhana.com/tetris-sample/index.html).

IE is not supported, don't bother. :)

### Codebase

Of interest is the main code of tetris components @ ./app/scripts/models.coffee
along with its tests @ ./test/app/models.spec.coffee

### Grunt & Usemin Workflow

Grunt [usemin](https://github.com/yeoman/grunt-usemin) is great to streamline index.html
file generation, specially when you have lots of script files you need to include.

One catch though, is that you don't have much of a power with regards to 
vendor/3rd party scripts. While it is great to have them all over CDN, it is less
than optimal of develop and run tests against them. In ideal world, while in
development you need to serve the files from your bower_components and when 
building for production you get all that replaced with their CDN counterpart.

Here comes vendor.config.coffee, it is a manifest that maps every 3rd party to 
its cdn and bower_components location.

Couple with a specific Grunt task (take a look at the index task) which does some
string replacement to the index.html file to prepare the file for useminPrepare
task.

See git hub tag boilerplate

### Coverage

I didn't have time to extend the boilerplate application with coverage support.
As the problem with coverage and coffeescript files dictates that one better 
cover the produced javascript files instead of coffeescript files.

## Directory Layout

dist/                     --> Contains generated file for serving the app
                              These files should not be edited directly
app/                      --> all of the files to be used in production

  partials/               --> angular view partials (partial HTML templates)
    *.html                    These files will be compiled using html2js
  index.html              --> app layout file (the main html template file of the app).

  scripts/                --> base directory for app scripts
    controllers.js        --> application controllers
    models.js             --> application models

  styles/                 --> all custom styles

bower_components          --> Bower Components
node_modules              --> NodeJS modules

test/                     --> test source files and libraries
  unit/
    controllers.spec.js   --> specs for controllers
    models.spec.js        --> specs for models

bower.json                --> Bower installed components, always make sure
                              to do bower install xyz --save (or --save-dev)
Gruntfile.coffee          --> grunt configuration file, use grunt --help to 
                              get list of available tasks
package.json              --> npm package configuration file, make sure to
                              do npm install --save or npm install --save-dev
README.md                 --> this file
vendor.config.coffee      --> This file is used to configure app/index.html
                              with external and local scripts and styles. Read
                              its comments for more details
