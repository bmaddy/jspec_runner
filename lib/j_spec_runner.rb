require 'holygrail'
# require 'jspec'
require 'nokogiri'

module JSpecRunner
  VERSION = '1.0.0'
  
  module Extensions
    
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
      
      # TODO: eventually just make this gem use Harmony and not depend on HolyGrail
      @__page = Harmony::Page.new(HolyGrail::Extensions::XHR_MOCK_SCRIPT + rewrite_script_paths(html))
      Harmony::Page::Window::BASE_RUNTIME.wait
      
    end
    
    private
    
    def jspec_dom
      <<-HTML
        <html>
          <head>
            <link type="text/css" rel="stylesheet" href="#{Gem.find_files('jspec.css').first}" />
            <script src="#{Gem.find_files('jspec.js').first}"></script>
            <script src="#{Gem.find_files('jspec.xhr.js').first}"></script>
            <userscripts/>
            <script src="#{Rails.root.join('spec/unit/spec.helper.js')}"></script>
            <script src="#{Gem.find_files('spec/unit/spec.j_spec_runner.helper.js')}"></script>
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
