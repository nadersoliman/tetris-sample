module.exports =
  # The following files will be served from CDN generally speaking
  # grunt build:production, grunt build:staging will use external entry
  # grunt server will use local entry, grunt server:usecdn will use notmin entry
  cdn: [
    external:
      "https://cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"
    notmin:
      "https://cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.js"
    local:
      "bower_components/lodash/dist/lodash.js"
  ,
    external:
      "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"
    notmin:
      "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js"
    local:
      "bower_components/jquery/dist/jquery.js"
  ,
    external:
      "https://ajax.googleapis.com/ajax/libs/angularjs/1.2.25/angular.min.js"
    notmin:
      "https://ajax.googleapis.com/ajax/libs/angularjs/1.2.25/angular.js"
    local:
      "bower_components/angular/angular.js"
  ]
  # The following files will be minified and uglified into vendor.js
  bundled: []