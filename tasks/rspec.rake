begin
  require 'rake'
  require 'rspec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  require 'rspec'
end
begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run all of the spec tests"
Rspec::Core::RakeTask.new do |t|
  t.rspec_opts  = ['--options', "spec/spec.opts"]
  t.pattern = FileList['spec/**/*_spec.rb']
end 
