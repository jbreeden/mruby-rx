Rx.run {
  files = Dir['**/*.{rb,rake,md}'].reject { |file| file.include?('.git')}
  puts "Watching #{files.length} files"

  files.each do |f|
    Rx.watch_file(f).subscribe { |change|
      puts "#{f}: #{change.current.inspect}"
    }
  end
}
