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
  map.connect '/xhr', :controller => 'functionals', :action => 'xhr'
end

ActionController::Base.session = {
  :key    => "_myapp_session",
  :secret => "some secret phrase" * 5
}

class FunctionalsController < ActionController::Base
  def page
    render :text => <<-HTML
      <html>
        <head>
          <script type="text/javascript" src="javascripts/jquery-1.4.2.min.js"></script>
          <script type="text/javascript" src="javascripts/change_body.js"></script>
          <title>page title</title>
        </head>
        <body onload="change_body(document.body)">
          <div><p>initial content</p></div>
        </body>
      </html>
    HTML
  end
  
  def xhr
    render :text => "xhr response"
  end
end

