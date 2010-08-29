require 'rake'
require 'echoe'
require File.join(File.dirname(__FILE__), 'lib', 'case_form', 'version')

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs    << 'lib'
  test.libs    << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

# Require Hanna for RDoc
require 'hanna/rdoctask'
desc 'Generate RDoc documentation for the CaseForm gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_files.include('README.rdoc', 'MIT-LICENSE.rdoc', 'CHANGELOG.rdoc').
    include('lib/**/*.rb').
    exclude('lib/case_form/version.rb')

  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "CaseForm documentation"

  rdoc.rdoc_dir = 'doc' # rdoc output folder
end

desc 'Default: run unit tests.'
task :default => :test

Echoe.new('case_form', CaseForm::VERSION)