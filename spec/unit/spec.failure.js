// console.log('from spec failure')
// 
describe 'Page'
  
  before_each
    $page = $(fixture('page'))
  end
  
  describe 'before initialization'
    it "this test should fail"
      "one".should_equal "two"
    end
  end
end
