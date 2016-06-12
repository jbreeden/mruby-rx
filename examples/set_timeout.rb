Rx.run do
  t1 = set_timeout 2000 do
    puts 'Timeout hit!'
  end
  
  t2 = set_timeout 2000 do
    puts "This should never be printed"
  end
  clear_timeout(t2)
end
