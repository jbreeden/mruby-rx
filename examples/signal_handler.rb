Rx.run {
  puts "Awaiting SIGINT (timeout in 5 seconds)..."
  Rx::Process.on(:SIGINT) do
    puts "Got SIGINT. Exiting."
    exit 0
  end

  Rx.set_timeout(5000) do
    puts "Timeout expired."
  end
}
