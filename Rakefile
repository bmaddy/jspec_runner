# -*- ruby -*-

require 'rake/clean'
require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.spec 'jspec_runner' do
  developer('Brian Maddy', 'brian@brianmaddy.com')

  # self.rubyforge_name = 'jspec_runnerx' # if different than 'jspec_runner'
end

# vim: syntax=ruby

# --------------------------------------------------
# Tests
# --------------------------------------------------
def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end

# task(:default => "test:all")

namespace(:test) do
  # desc "Run all tests"
  # task(:all) do
    exit system("ruby #{gem_opt} -I.:lib:test -e'%w( #{Dir['test/**/*_test.rb'].join(' ')} ).each {|p| require p }'")
  # end
end
