require 'test/unit'
require 'tree_tagger/tagger'
require 'stringio'

class TestTagger < Test::Unit::TestCase

  PUBLIC_METHODS = [:process,
                    :get_output,
                    :flush
                   ]
  def setup
    params = {} # dummy for now
    @tagger = TreeTagger::Tagger.new(params)
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
end
