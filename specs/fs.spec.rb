Rx::Spec.new('Rx::FS Module') do
  describe 'FS::watchFile(filename, [options], &block)' do
    it "Polls `filename` for changes then calls `block` with the current and previous stat objects" do
      cb_called_correctly = false
      Rx.run do
        dir = Dir.tmpdir
        watch = Rx::FS.watch_file(dir, interval: 500) do |cur, prev|
          cb_called_correctly = cur.kind_of?(UV::Stat) && prev.kind_of?(UV::Stat)
          watch.close
        end
        
        set_timeout(200) do
          File.open("#{dir}/nurb_test.txt", 'w')
          File.delete("#{dir}/nurb_test.txt")
        end
      end
      assert cb_called_correctly
    end
    
    it 'The options argument may be omitted. If provided, it should be a hash' do
      assert_raises(TypeError) do
        Rx::FS.watch_file(".", nil) { }
      end
    end
    
    it '`options[:persistent]` indicates whether the process should continue to run as long as files are being watched' do
      exited_peacefully = true
      Rx.run do
        dir = Dir.tmpdir
        watch = Rx::FS.watch_file(dir, persistent: false) { }
        
        t = set_timeout(2000) do
          exited_peacefully = false
        end
        t.unref
      end
      assert exited_peacefully
    end
  end
end
