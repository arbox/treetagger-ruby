lib_path = File.expand_path(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'rake'
require 'tree_tagger/version'

# Define a constant here to use this spec in the Rakefile.
Gem::Specification.new do |s|
  s.name = 'treetagger-ruby'
  # it is the description for 'gem list -d'
  s.summary = 'A wrapper for the TreeTagger by Helmut Schmid.'
  s.description = 'This package contains a simple wrapper for the TreeTagger, \
a POS tagger based on decision trees and developed by Helmut Schmid at IMS \
in Stuttgart, Germany. You should have the TreeTagger with all library files \
installed on your machine in order to use this wrapper.'
  s.version = TreeTagger::VERSION
  s.author = 'Andrei Beliankou'
  s.email = 'arbox@yandex.ru'
  s.homepage = 'https://github.com/arbox/treetagger-ruby'
  s.bindir = 'bin'
  s.executables << 'rtt'
  s.add_development_dependency('rdoc', '~>4.2')
  s.add_development_dependency('bundler', '~>1.7')
  s.add_development_dependency('yard', '~>0.8')
  s.add_development_dependency('rake', '~>10.4')
  s.add_development_dependency('minitest', '~>5.5')
  s.extra_rdoc_files = ['README.rdoc', 'LICENCE.rdoc', 'CHANGELOG.rdoc']
  s.rdoc_options = ['-m', 'README.rdoc']
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.8.7'
  s.files = FileList['lib/**/*.rb',
                     'README.rdoc',
                     'LICENCE.rdoc',
                     'CHANGELOG.rdoc',
                     '.yardopts',
                     'test/**/*'].to_a
  s.test_files = FileList['test/**/*'].to_a
end
