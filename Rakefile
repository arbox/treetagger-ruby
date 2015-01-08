lib_path = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

# Rake provides FileUtils and its own FileUtils extensions
require 'rake'
require 'rake/clean'

CLEAN.include('.*~')
CLOBBER.include('ydoc',
                'rdoc',
                '.yardoc',
                '*.gem')

task :default => [:v]

# Generate documentation.
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_files.include('README.rdoc',
                          'LICENCE.rdoc',
                          'CHANGELOG.rdoc',
                          'lib/**/*',
                          'bin/**/*'
                          )
  rdoc.rdoc_dir = 'rdoc'
end

require 'yard'
YARD::Rake::YardocTask.new do |ydoc|
  ydoc.options += ['-o', 'ydoc']
  ydoc.name = 'ydoc'
end

# Testing.
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning
  t.ruby_opts = ['-rubygems']
  t.test_files = FileList['test/*.rb']
end

desc 'Open an irb session preloaded with this library.'
task :console do
  sh 'irb -rubygems -I lib -r tree_tagger/tagger'
end

desc 'Show the current version.'
task :v do
  load 'tree_tagger/version.rb'
  puts TreeTagger::VERSION
end

desc 'Document the code using Yard and RDoc.'
task :doc => [:clobber, :rdoc, :ydoc]

desc 'Release the library.'
task :release => [:tag, :build, :publish] do

end

desc 'Tag the current source code version.'
task :tag do
  puts 'Tagging the version.'
end

desc 'Builds the .gem package.'
task :build do
  puts 'Building the package.'
end

desc 'Publish the documentation on the homepage.'
task :publish => [:clobber, :doc] do
  destination = 'arbox@bu.chsta.be:/var/www/sites/bu.chsta.be/htdocs/shared/projects/treetagger-ruby'
  system "scp -r ydoc/* #{destination}"
end
