
describe 'Page'
  
  before_each
    $page = $(fixture('page'))
  end
  
  describe 'before initialization'
    it 'should have a title'
      $page.find('p').html().should_equal "initial content"
    end
  end
  
  describe 'initialize'
    before_each
      change_body($page)
    end
    
    describe 'after initialization'
      it 'should have a title'
        $page.find('p').html().should_equal "body changed by change_body.js"
      end
    end
  end
end
