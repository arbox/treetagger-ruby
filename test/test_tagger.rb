require 'minitest/autorun'
require 'tree_tagger/tagger'
require 'tree_tagger/error'
require 'stringio'

class TestTagger < Minitest::Test
  PUBLIC_METHODS = [:process,
                    :get_output,
                    :flush
                   ]
  def setup
#    ENV['TREETAGGER_BINARY'] = '/opt/TreeTagger/bin/tree-tagger'
#    ENV['TREETAGGER_MODEL'] = '/opt/TreeTagger/lib/german.par'
#    ENV['TREETAGGER_LEXICON'] = '/opt/TreeTagger/lib/german-lexicon.txt'

    ENV['TREETAGGER_BINARY'] = 'test/tree-tagger/tree-tagger'
    ENV['TREETAGGER_MODEL'] = 'test/tree-tagger/model_file.par'
    ENV['TREETAGGER_LEXICON'] = 'test/tree-tagger/lexicon_file.txt'

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

=begin
  # It should accept only arrays and strings.
  def test_input_for_its_class
    assert_nothing_raised do
      @tagger.process 'Ich\ngehe\nin\ndie\nSchule\n.\n'
      @tagger.process %w(Ich gehe in die Schule .)
    end
  end
=end

  # It should reject non-string and non-array elements.
  def test_rejecting_invalid_input
    [{}, :input, 1, 1.0, Time.new].each do |input|
      assert_raises(TreeTagger::UserError) do
        @tagger.process(input)
      end
    end
  end

  # It should reject empty input.
  def test_for_empty_input
    ['', []].each do |input|
      assert_raises(TreeTagger::UserError) do
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
      assert_raises(TreeTagger::UserError) do
        @tagger.process(input)
      end
    end
  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_binary_presence
    ENV.delete('TREETAGGER_BINARY')
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end
  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_model_presence
    ENV.delete('TREETAGGER_MODEL')
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new
    end

  end

  # It should instantiate a tagger instance only with valid options.
  def test_for_lexicon_presence
    ENV.delete('TREETAGGER_LEXICON')
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:lookup => true, :options => '-quiet -sgml'})
    end
  end

  # It should reject a non-boolean value for <:lookup>.
  def test_rejecting_lookup_values
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:lookup => 'true', :options => '-quiet'})
    end
  end

  # It should reject a non-boolean value for <:replace_blanks>.
  def test_rejecting_blank_values
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:replace_blanks => 'true'})
    end
  end

  # It should reject a non-string value for <:options>.
  def test_rejecting_option_values
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:options => :quiet})
    end
  end

  # It should reject invalid options for TreeTagger inside <:options>.
  def test_rejecting_invalid_arguments
    flunk 'Not implemented yet!'
  end

  # It should ensure the presense of the <-sgml> argument.
  def test_presence_of_sgml_argument
    flunk 'Not implemented yet!'
  end

  # It should reject a non-string value for <:blank_tag>.
  def test_rejecting_blanktag_values
    assert_raises(TreeTagger::UserError) do
      TreeTagger::Tagger.new({:blank_tag => :blank})
    end
  end

  # It should ensure that <:blang_tag> is a valid smgl sequence.
  def test_sgml_form
    flunk 'Not implemented yet!'
  end
end
