# -*- encoding: utf-8 -*-
require 'thread'

=begin
TODO:
- Observe the status of the reader thread.
- Control the status of the pipe and recreate it.
- Handle IO errors.
- Handle errors while allocating the TT object.
- Language specific options.
- Update the flush sentence, make it shorter.
- Store the queue on a persistant medium, not in the memory.
- Properly set the $ORS for all platforms.
=end
module TreeTagger
  class Tagger

    BEGIN_MARKER = '<BEGIN_OF_THE_TT_INPUT />'
    END_MARKER   = '<END_OF_THE_TT_INPUT />'
    # TT seems to hold only the last three tokens in the buffer.
    # The flushing sentence can be shortened down to this size.
    FLUSH_SENTENCE = "Das\nist\nein\nTestsatz\n,\num\ndas\nStossen\nder\nDaten\nsicherzustellen\n."
    ENV['TREETAGGERHOME'] = '/opt/TreeTagger'
    
    def initialize(*args)
      @cmdline = "#{ENV['TREETAGGERHOME']}/bin/tree-tagger " +
        "-token -lemma -sgml -quiet #{ENV['TREETAGGERHOME']}/lib/german.par"
      @queue = []
      @pipe = create_pipe
      @pipe.sync = true
      @reader = start_reader
      @inside_output = false
      @inside_input = false
    end

    # Send the string to the TreeTagger.
    def process(str)
      # Sanitize strings.
      str = str.strip
      # Mark the beginning of the text.
      if not @inside_input
        str = "#{BEGIN_MARKER}\n#{str}\n"
        @inside_input = true
      else
        str = str + "\n"
      end
      @pipe.print(str)
    end

    # Get processed tokens back.
    def get_output
      $stderr.puts @queue if $DEBUG
      output = []
      while str = @queue.shift
        case str
        when BEGIN_MARKER
          @inside_output = true
          $stderr.puts 'Found the begin marker.' if $DEBUG
        when END_MARKER
          @inside_output = false
          $stderr.puts 'Found the end marker.' if $DEBUG
        else
          output << str if @inside_output
        end
      end

      # Assertion: we've read at least one whole chunk
      # between the BEGIN and END conditions.
      # Thus <write_condition> cannot be true here.
      if @inside_output
        fail "Not the whole chunk read!"
      end

      # If the reader thread didn't run we force an iteration
      # and wait on the valid output.
      output.empty? ? get_output : output
    end
    
    # Get the rest of the text back.
    # TT holds some meaningful parts in the buffer.
    def flush
      @inside_input = false
      str = "#{END_MARKER}\n#{FLUSH_SENTENCE}\n"
      @pipe.print(str)
    end
    
    private
    # Starts the reader thread.
    def start_reader
      Thread.new do
        while line = @pipe.gets
          # The output strings do not contain "\n".
          @queue.push(line.chomp)
          $stderr.puts 'Added to the queue.' if $DEBUG
        end
      end
    end

    # This method may be obsolete.
    def create_pipe
      IO.popen(@cmdline, 'r+')
    end

  end # class
end # module

__END__
- tokenization
- lexicon lookup
- tagging
- error correction
