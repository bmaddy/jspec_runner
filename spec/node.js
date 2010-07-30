
require.paths.unshift('spec', '/Users/bmaddy/.rvm/gems/ruby-1.8.7-p174/gems/jspec-4.3.2/lib', 'lib')
require('jspec')
require('unit/spec.helper')
require('yourlib')

JSpec
  .exec('spec/unit/spec.js')
  .run({ reporter: JSpec.reporters.Terminal, fixturePath: 'spec/fixtures', failuresOnly: true })
  .report()
