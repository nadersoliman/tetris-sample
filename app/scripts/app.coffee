angular.module 'tetris', [
  'tetris.models'
  'tetris.controllers'
]

.run([
  '$rootScope'

  ($rootScope)->

    $rootScope.hello = 'world'
])
.value('config',
  width: 20
  height: 20
  gutter: 4
  empty: '.'
  full: '*'
)