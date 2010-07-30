require 'rubygems' unless Object.const_defined?(:Gem)
require "test/test_helper"
# require "test/unit"
# require "jspec_runner"

class FunctionalsController < ActionController::Base
  def page
    render :text => <<-HTML
      <html>
        <head>
          <script src="public/javascripts/change_body.js"></script>
          <title>page title</title>
        </head>
        <body>
          <div>initial content</div>
        </body>
      </html>
    HTML
  end
end

class FunctionalsControllerTest < ActionController::TestCase
  test "should move javascript from rendered page to the jSpec DOM formatter page" do
    get :page
    assert_select js_dom, "html", :count => 1
    jspec do |js|
      # js.exec 'unit/page/spec.passes.js'
    end
    assert_select js_dom, "html", :count => 1
  end
  
  test "should execute javascript that was included in the head tag" do
    get :page
    assert_select js_dom, "body", :text => "body changed by change_body.js"
  end
  
  # test "a passing spec" do
  #   get :page
  #   jspec do
  #     flunk
  #     # exec 'unit/page/spec.passes.js'
  #   end
  # end
  # 
  # test "multiple passing specs" do
  #   
  # end
  # 
  # test "a failing spec" do
  #   assert_raises AssertionFailedError do
  #     jspec do
  #       exec 'unit/page/spec.fails.js'
  #     end
  #   end
  # end
  # 
  # test "first spec failing" do
  #   
  # end
  # 
  # test "second spec failing" do
  #   
  # end
  
  private
  
  # this method is only here until my patch to add it to holygrail is accepted
  def js_dom
    # force holygrail to set @__page
    js('true') unless @__page
    HTML::Document.new(@__page.to_html, false, true).root
  end
end
