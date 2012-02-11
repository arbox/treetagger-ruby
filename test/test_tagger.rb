require 'test/unit'
require 'tree_tagger/tagger'
require 'tree_tagger/error'
require 'stringio'

class TestTagger < Test::Unit::TestCase

  PUBLIC_METHODS = [:process,
                    :get_output,
                    :flush
                   ]
  def setup
    ENV['TREETAGGER_BINARY'] = '/opt/TreeTagger/bin/tree-tagger'
    ENV['TREETAGGER_MODEL'] = '/opt/TreeTagger/lib/german.par'
    ENV['TREETAGGER_LEXICON'] = '/opt/TreeTagger/lib/german-lexicon.txt'
    
    params = {} # dummy for now
    @tagger = TreeTagger::Tagger.new
  end
  
  def teardown
  end

  # It should have the following constants set.
  def test_constants
  end

  # It should respond to valid methods
  def test_public_methods
    PUBLIC_METHODS.each do |m|
      assert_respond_to(@tagger, m)
    end
  end

  def test_tagger
  end

  # It should accept only valid input.
  def test_input_validity
    ['', [], {}, :input, [:one, :two]].each do |input|
      assert_raise(TreeTagger::UserError) do
        @tagger.process(input)
      end
    end
  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_binary_presense
    ENV.delete('TREETAGGER_BINARY')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end
  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_model_presense
    ENV.delete('TREETAGGER_MODEL')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end

  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_lexicon_presense
    ENV.delete('TREETAGGER_LEXICON')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end
  end

end
