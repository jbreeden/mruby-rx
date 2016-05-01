Nurb::Process.on(:SIGINT) do
  puts "Got SIGINT. Exiting."
  exit 0
end

Nurb.set_timeout(5000) do
  puts "Timeout expired."
end

Nurb.run
