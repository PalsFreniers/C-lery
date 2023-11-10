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
    meson.get_compiler('c').find_library('m'),
]

src = files([
  'main.vala',
  'token.vala',
  'tokenise.vala',
  'parser.vala',
  'normalise.vala',
  'generator.vala',
  'logger.vala'
])

executable('brocoly', src, vala_args: vala_args, dependencies: dependencies)
