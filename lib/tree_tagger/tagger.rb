# -*- encoding: utf-8 -*-

module TreeTagger
  class Tagger
    def initialize(
                   lang = :de,
                   opts = {
                     :sgml => true,
                     :token => true,
                     :lemma => true
                   }
                   )
      @lang = lang
      @opt = opts
    end
    def process(str)
      line = %x(echo '#{str}' | #{ENV['TREETAGGERHOME']}/cmd/tree-tagger-german)
      arr = line.split("\n").collect { |el| el.split("\t") }
    end
  end # class
end # module

