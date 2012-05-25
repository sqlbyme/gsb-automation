
desc "run the tests!"
task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rspec_opts = '--format d'
  end
end

task :default => :spec