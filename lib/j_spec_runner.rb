require 'holygrail'

module JSpecRunner
  VERSION = '1.0.0'
  
  module Extensions
    
    def jspec
      yield
    end
    
  end
end
