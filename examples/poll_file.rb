Rx.run {
  files = Dir['**/*.{rb,rake,md}'].reject { |file| file.include?('.git')}
  puts "Watching #{files.length} files"

  files.each do |f|
    Rx.poll_file(f).subscribe { |change|
      puts "#{f}: #{change.previous.inspect}" if change.previous
      puts "#{f}: #{change.current.inspect}"
    }
  end
}
