require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

desc "Run the main application script"
task :run do
  ruby "main.rb"
end

task default: :run
