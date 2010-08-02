require 'rubygems' unless Object.const_defined?(:Gem)
require "test/test_helper"
# require "test/unit"
# require "jspec_runner"

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
end

class FunctionalsControllerTest < ActionController::TestCase
  test "be able to find and execute scripts in the head tag" do
    get :page
    assert_select js_dom, "body", :text => "body changed by change_body.js"
  end
  
  test "should have the <script> from @response.body and have the jSpec DOM formatter page" do
    get :page
    
    assert_select js_dom, "html", :count => 1
    jspec :execs => ['unit/spec.page.js']
    
    # <script> from @response.body
    assert_select js_dom, "head script[src$=?][type=?]", "javascripts/change_body.js", "text/javascript"
    # jspec DOM formatter stuff
    assert_select js_dom, "script[src$=?]", "jspec.js"
    assert_select js_dom, "script[src$=?]", "jspec.xhr.js"
    assert_select js_dom, "script[src$=?]", "spec/unit/spec.j_spec_runner.helper.js"
    assert_match Regexp.new(Regexp.escape(".exec('unit/spec.page.js')")), js_dom.to_s
    assert_select js_dom, "body.jspec"
    assert_select js_dom, "div#jspec-top" do
      assert_select "#jspec-title em", :text => /\d/
    end
    assert_select js_dom, "div#jspec"
    assert_select js_dom, "div#jspec-bottom"
  end
  
  test "a failing spec should fail" do
    get :page
    # you should see a failed test here and raise an exception
    result = jspec(:execs => ['unit/spec.failure.js'])
    expected = <<-TEXT

Page before initialization
this test should fail, expected "one" to be "two"
expect("one").should(equal, "two");

JSpec: 0 passes, 1 failures
    TEXT
    assert_equal false, result[:passed]
    assert_equal expected, result[:output]
  end
  
  test "a failing assert_jspec should fail" do
    get :page
    assert_raises Test::Unit::AssertionFailedError do
      assert_jspec :execs => ['unit/spec.failure.js']
    end
  end
  
  # test "a passing spec" do
  #   get :page
  #   jspec :execs => ['unit/spec.page.js']
  # end
  # 
  # test "multiple passing specs" do
  #   
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
