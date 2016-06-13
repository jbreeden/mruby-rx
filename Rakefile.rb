desc 'Run the specs'
task :specs do
  Dir['specs/*.spec.rb'].each do |f|
    unless system "mruby #{f}"
      raise "Error running test file: #{f}"
    end
  end
end

desc 'Generate the docs'
task :docs do
  sh "rdoc mrblib pages README.md"
end
