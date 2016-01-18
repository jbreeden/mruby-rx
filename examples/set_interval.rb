Nurb.run do
  count = 1
  int = set_interval 1000 do
    puts "Interval hit: ##{count}"
    if count == 5
      puts "Clearing interval: #{int}"
      clear_interval(int)
    end
    count += 1
  end
end
