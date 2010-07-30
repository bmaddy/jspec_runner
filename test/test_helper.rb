# require 'test/unit'
require 'action_controller'
require 'action_controller/integration'

begin require 'ruby-debug'; rescue LoadError; end
begin require 'redgreen';   rescue LoadError; end

require 'rails/init'

# class Rails
#   def self.root
#     Pathname(__FILE__).dirname.parent.expand_path
#   end
# end

ActionController::Routing::Routes.draw do |map|
  map.connect '/page', :controller => 'functionals', :action => 'page'
  # map.connect '/bar', :controller => 'functionals', :action => 'bar'
  # map.connect '/baz', :controller => 'integration', :action => 'baz'
  # map.connect '/boo', :controller => 'integration', :action => 'boo'
  # map.connect '/moo', :controller => 'integration', :action => 'moo'
  # map.connect '/xhr', :controller => 'integration', :action => 'xhr'
end

# ActionController::Base.session = {
#   :key    => "_myapp_session",
#   :secret => "some secret phrase" * 5
# }
