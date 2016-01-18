desc 'Run the specs'
task :specs do
  Dir['specs/*.rb'].each do |f|
    sh "mruby #{f}"
  end
end

desc 'Generate the docs'
task :docs do
  Dir['specs/*.rb'].each do |f|
    sh "mruby #{f} > #{f.sub('specs/', 'docs/').sub('.spec.rb', '.md')}"
  end
end
