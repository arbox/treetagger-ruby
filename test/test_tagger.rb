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
  
  # It should accept only arrays and strings.
  def test_input_for_its_class
    assert_nothing_raised do
      @tagger.process 'Ich\ngehe\nin\ndie\nSchule\n.\n'
      @tagger.process %w{Ich gehe in die Schule .}
    end
  end

  # It should reject non-string and non-array elements.
  def test_rejecting_invalid_input
    [{}, :input, 1, 1.0, Time.new].each do |input|
      assert_raise(TreeTagger::UserError) do
        @tagger.process(input)
      end
    end
  end
  
  # It should reject empty input.
  def test_for_empty_input
    ['', []].each do |input|
      assert_raise(TreeTagger::UserError) do
        @tagger.process(input)
      end
    end
  end

  # It should reject arrays with wrong elements.
  def test_for_elements_of_arrays
    
  end
  
  # It should accept valid input.
  def test_accepting_vaild_input
    input = ''
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
  def test_for_binary_presence
    ENV.delete('TREETAGGER_BINARY')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end
  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_model_presence
    ENV.delete('TREETAGGER_MODEL')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end

  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_lexicon_presence
    ENV.delete('TREETAGGER_LEXICON')
    assert_raise(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:lookup => true, :options => '-quiet -sgml'})
    end
  end

end
