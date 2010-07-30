require 'pathname'
require  Pathname(__FILE__).dirname.parent + 'lib/j_spec_runner'

class ActionController::TestCase
  include JSpecRunner::Extensions
  # this should be loaded by include 'holygrail', but it doesn't seem to work for testing
  include HolyGrail::Extensions
end
class ActionController::IntegrationTest
  include JSpecRunner::Extensions
  # this should be loaded by include 'holygrail', but it doesn't seem to work for testing
  include HolyGrail::Extensions
end
