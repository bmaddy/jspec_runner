# -*- ruby -*-

require 'rake/clean'
# require 'rubygems'
require 'hoe'

Hoe.plugins.delete :rubyforge
Hoe.plugins.delete :test

Hoe.spec 'jspec_runner' do
  developer('Brian Maddy', 'brian@brianmaddy.com')
  extra_deps <<  %w(holygrail) << %w(jspec) << %w(nokogiri)
  extra_dev_deps << %w(action_controller)
end

# vim: syntax=ruby

# --------------------------------------------------
# Tests
# --------------------------------------------------
def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end

task(:default => "test:all")

namespace(:test) do
  desc "Run all tests"
  task(:all) do
    exit system("ruby #{gem_opt} -I.:lib:test -e'%w( #{Dir['test/**/*_test.rb'].join(' ')} ).each {|p| require p }'")
  end
end

task :install => :package do
  $:<< 'lib'
  require 'volleyball'
  puts `gem install pkg/volleyball-#{Volleyball::VERSION}.gem`
end
