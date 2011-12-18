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
      %x("echo '#{str}' | #{ENV['TREETAGGERHOME']}/cmd/tree-tagger-german")
    end
  end # class
end # module

