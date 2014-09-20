angular.module 'tetris', []

.run(['$rootScope', ($rootScope)->

  $rootScope.hello = 'world'
])