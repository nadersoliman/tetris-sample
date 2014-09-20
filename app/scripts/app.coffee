angular.module 'tetris', []

.run(['$rootScope', ($rootScope)->

  $rootScope.hello = 'world'
])
.value('config',
  width: 20
  height: 20
  gutter: 4
  empty: '.'
  full: '*'
)