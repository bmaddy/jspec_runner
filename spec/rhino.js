
load('/Users/bmaddy/.rvm/gems/ruby-1.8.7-p174/gems/jspec-4.3.2/lib/jspec.js')
load('/Users/bmaddy/.rvm/gems/ruby-1.8.7-p174/gems/jspec-4.3.2/lib/jspec.xhr.js')
load('lib/yourlib.js')
load('spec/unit/spec.helper.js')

JSpec
.exec('spec/unit/spec.js')
.run({ reporter: JSpec.reporters.Terminal, fixturePath: 'spec/fixtures' })
.report()