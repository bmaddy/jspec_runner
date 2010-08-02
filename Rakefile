# -*- ruby -*-

require 'rake/clean'
require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.spec 'jspec_runner' do
  developer('Brian Maddy', 'brian@brianmaddy.com')
end

# vim: syntax=ruby

# --------------------------------------------------
# Tests
# --------------------------------------------------
def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end

namespace(:test) do
  exit system("ruby #{gem_opt} -I.:lib:test -e'%w( #{Dir['test/**/*_test.rb'].join(' ')} ).each {|p| require p }'")
end
