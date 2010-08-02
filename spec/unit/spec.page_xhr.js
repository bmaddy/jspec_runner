describe 'Page with XHR'
  
  before_each
    $page = $(fixture('page'))
  end
  
  describe 'before initialization'
    it 'should have the initial content'
      $page.find('p').html().should_equal "initial content"
    end
  end
  
  describe 'initialize'
    before_each
      change_body_xhr($page)
    end
    
    describe 'after initialization'
      it 'should have a title'
        $page.find('p').html().should_equal "body changed by xhr response"
      end
    end
  end
end
