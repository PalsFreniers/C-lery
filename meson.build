project('C-lery', ['vala', 'c'])

vala_args = [
  '-X',
  '-w',
  '-X',
  '-fsanitize=address'  
]

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
]

src = files([
  'main.vala',
  'normalise.vala',
  'token.vala'
])

executable('brocoly', [src], vala_args: [vala_args], dependencies: dependencies)
