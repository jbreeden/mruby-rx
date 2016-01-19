Nurb::Spec.new('Nurb Timers') do
  
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
  end
  
  describe 'clear_timeout(timeout)' do
    it 'Cancels the timeout returned by set_timeout' do
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
  end
  
  describe 'clear_interval(interval)'   do
    it 'Cancels the interval returned by set_interval' do
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
  
  describe 'set_immediate(&block)' do
    it 'Executes the given block' do
      hit = false
      set_immediate do
        hit = true
      end
      assert(!hit)
      Nurb.run
      assert(hit)
    end
    
    it 'Is aliased as next_tick' do
      hit = false
      next_tick do
        hit = true
      end
      assert(!hit)
      Nurb.run
      assert(hit)
    end
    
  end
end
