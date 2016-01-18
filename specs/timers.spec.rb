Nurb::Spec.new('Timers') do
  describe 'set_timeout(delay, &block)' do
    it 'Runs `block` after `delay` milliseconds' do
      t1 = Time.now.to_f
      t2 = t1
      set_timeout 500 do
        t2 = Time.now.to_f
      end
      Nurb.run
      
      assert(t2 - t1 >= 0.5)
    end
    
    it 'Returns an integer that can be used to clear the timeout' do
      hit = false
      Nurb.run do
        t = set_timeout 100 do
          hit = true
        end
        clear_timeout(t)
      end
      assert(!hit)
    end
  end
  
  describe 'set_interval(delay, &block)' do
    it 'Runs `block` after every `delay` milliseconds' do
      t1 = Time.now.to_f
      t2 = t1
      count = 0
      i = set_interval 100 do
        count += 1
        t2 = Time.now.to_f
        clear_interval(i) if count == 2
      end
      Nurb.run
      
      assert(t2 - t1 >= 0.2 && count == 2)
    end
    
    it 'Returns an integer that can be used to clear the timeout' do
      hit = false
      Nurb.run do
        t = set_interval 100 do
          hit = true
        end
        clear_interval(t)
      end
      assert(!hit)
    end
  end
end
