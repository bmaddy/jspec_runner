require 'holygrail'
# require 'jspec'
require 'nokogiri'

module JSpecRunner
  VERSION = '0.1.0'
  
  # This module allows routing ajax requests to rails controllers
  #
  # @private
  module XhrProxy
    extend self

    # Test object context (i.e. within test methods)
    attr_accessor :context

    # Surrogate ajax request
    def request(info, data="")
      context.instance_eval do
        xhr(info["method"].downcase, info["url"], data)
        @response.body.to_s
      end
    end
    
    # Special for spec requests
    def specRequest(path)
      File.open(Rails.root.join('spec', path)).read
    end
    
    def log(s)
      # TODO: can't seem to figure out where the logger is...
      # context.instance_eval do
      #   RAILS_DEFAULT_LOGGER.info s
      #   logger.info s
      # end
      puts s
      ""
    end
  end

  module Extensions
    
    def assert_jspec(options={})
      result = jspec(options)
      assert_block(build_message("One or more specs failed", result[:output])) { result[:passed] }
    end
    
    def jspec(options={})
      opts = {
        :execs => []
      }.merge(options)
      scripts = Nokogiri::HTML.parse(@response.body).css('script').map(&:to_s)
      
      exec_commands = opts[:execs].map {|spec| ".exec('#{spec}')"}
      run_suites = <<-HTML
        <script>
          function runSuites() {
            JSpec
            #{exec_commands.join("\n")}
            .run({ fixturePath: 'fixtures' })
            .report()
          }
        </script>
      HTML
      
      html = jspec_dom.gsub(/<userscripts\/>/, scripts.join("\n")).gsub(/<runSuites\/>/, run_suites)
      
      # TODO: consider making this gem use Harmony and not depend on HolyGrail -- too much duplication here
      XhrProxy.context = self
      @__page = Harmony::Page.new(rewrite_script_paths(html))
      Harmony::Page::Window::BASE_RUNTIME.wait
      
      result = {:passed => true}
      js_dom = HTML::Document.new(@__page.to_html, false, true).root
      HTML::Selector.new(".has-failures").select(js_dom).each do |wrapper|
        output = HTML::Selector.new("tr").select(wrapper).map do |row|
          if row.attributes["class"] == "description"
            "\n" + text_only(row)
          elsif HTML::Selector.new(".pass").select(row).any?
            "\e[32mPassed\e[0m: " + text_only(row)
          elsif HTML::Selector.new(".failed").select(row).any?
            "\e[31mFailed\e[0m: " + text_only(row)
          else
            text_only(row)
          end
        end
        output = output.join("\n") + "\n\nJSpec: \e[32m#{select_text(wrapper, ".heading .passes em")} passes\e[0m, \e[31m#{select_text(wrapper, ".heading .failures em")} failures\e[0m\n"
        # puts js_dom
        
        result = {:passed => false, :output => output}
      end
      return result
    end
    
    private
    
    def text_only(node)
      if node.is_a? HTML::Text
        node.content
      else
        node.children.map {|c| text_only(c)}.map(&:strip).reject{|s| s == ""}.join(", ")
      end
    end
    
    def select_text(node, select)
      HTML::Selector.new(select).select_first(node).children.first.content
    end
    
    def jspec_dom
      <<-HTML
        <html>
          <head>
            <script>
              // JS script to reroute ajax requests through XhrProxy
              if(typeof(Ruby) != "undefined"){
                XMLHttpRequest.prototype.open = function(method, url, async, username, password) {
                  this.info = { method: method, url: url }
                }
                XMLHttpRequest.prototype.send = function(data) {
                  this.responseText = Ruby.JSpecRunner.XhrProxy.request(this.info, data)
                  this.readyState = 4
                  this.onreadystatechange()
                }
                // makes for some easier debugging
                console = {log: function(s){ Ruby.JSpecRunner.XhrProxy.log(s) }}
              }
            </script>
            <link type="text/css" rel="stylesheet" href="#{Gem.find_files('jspec.css').first}" />
            <userscripts/>
            <script src="#{Gem.find_files('jspec.js').first}"></script>
            <script src="#{Gem.find_files('jspec.jquery.js').first}"></script>
            <script src="#{Gem.find_files('jspec.xhr.js').first}"></script>
            <script src="#{Rails.root.join('spec/unit/spec.helper.js')}"></script>
            <script src="#{Gem.find_files('spec/unit/spec.jspec_runner.helper.js').first}"></script>
            <runSuites/>
          </head>
          <body class="jspec" onLoad="runSuites();">
            <div id="jspec-top"><h2 id="jspec-title">JSpec <em><script>document.write(JSpec.version)</script></em></h2></div>
            <div id="jspec"></div>
            <div id="jspec-bottom"></div>
          </body>
        </html>
      HTML
    end
  end
end
