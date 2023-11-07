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
  'src/main.vala',
  'src/Tokens.vala',
  'src/assembler.vala',
  'src/logger.vala'
])

executable('brocoly', src, vala_args: vala_args, dependencies: dependencies)
