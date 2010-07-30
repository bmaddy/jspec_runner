# require 'test/unit'
require 'action_controller'
require 'action_controller/integration'

begin require 'ruby-debug'; rescue LoadError; end
begin require 'redgreen';   rescue LoadError; end

require 'rails/init'

class Rails
  def self.root
    Pathname(__FILE__).dirname.parent.expand_path
  end
end

ActionController::Routing::Routes.draw do |map|
  map.connect '/page', :controller => 'functionals', :action => 'page'
end

# ActionController::Base.session = {
#   :key    => "_myapp_session",
#   :secret => "some secret phrase" * 5
# }
