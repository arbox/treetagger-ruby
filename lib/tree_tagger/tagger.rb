# -*- encoding: utf-8 -*-
require 'thread'
require 'tree_tagger/error'

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
    ENV['TREETAGGER_BINARY'] = '/opt/TreeTagger/bin/tree-tagger'
    ENV['TREETAGGER_MODEL'] = '/opt/TreeTagger/lib/german.par'
    ENV['TREETAGGER_LEXICON'] = '/opt/TreeTagger/lib/german-lexicon.txt'
    
    def initialize(opts = {
                     :binary => nil,
                     :model => nil,
                     :lexicon => nil,
                     :lang => :de,
                     :options => '-token -lemma -sgml -quiet',
                     :blanks => :replace,
                     :lookup => false
                   })

      @opts = validated_options(opts)
      @cmdline = "#{@opts[:binary]} #{@opts[:options]} #{#opts[:model]}"

      @queue = Queue.new
      @pipe = new_pipe
      @pipe.sync = true
      @reader = new_reader
      @inside_output = false
      @inside_input = false
      @enqueued_tokens = 0
      @mutex = Mutex.new
      @queue_mutex = Mutex.new
      # sleep(1) # Don't know if it's useful, no problems before.
    end

    # Send the string to the TreeTagger.
    def process(input)

      str = convert(input)
      # Sanitize strings.
      str = sanitize(str)
      # Mark the beginning of the text.
      if not @inside_input
        str = "#{BEGIN_MARKER}\n#{str}\n"
        @inside_input = true
      else
        str = str + "\n"
      end
      @mutex.synchronize { @enqueued_tokens += 1 }
      @pipe.print(str)
    end

    # Get processed tokens back.
    # This method is not blocking. If some tokens have been sent,
    # but not received from the pipe yet, it returns an empty array.
    # If all sent tokens are in the queue it returns all of them.
    # If no more tokens are awaited it returns <nil>.
    def get_output
      output = []
      tokens = 0
      @queue_mutex.synchronize do
        tokens = @queue.size
        tokens.times { output << @queue.shift }
      end
      @mutex.synchronize do
        @enqueued_tokens -= tokens
      end

      # Nil if nothing to process in the pipe.
      # Possible only after flushing the pipe.
      if @enqueued_tokens > 0
        output
      else
        output.any? ? output : nil
      end
    end
    
    # Get the rest of the text back.
    # TT holds some meaningful parts in the buffer.
    def flush
      @inside_input = false
      str = "#{END_MARKER}\n#{FLUSH_SENTENCE}\n"
      @pipe.print(str)
      # Here invoke the reader thread to ensure
      # all output has been read.
      #@reader.run
    end
    
    private
    # Return the options hash after validation.
    def validated_options(opts)
      [:binary, :model, :lexicon].each do |key|
        if opts[key].nil?
          opts[key] = ENV.fetch("TREETAGGER_#{key.to_s.upcase}") do |missing|
            fail UserError, "Set the environment variable <#{missing}>!"
          end
        end
      end
      opts
    end
    # Starts the reader thread.
    def new_reader
      Thread.new do
        while line = @pipe.gets
          # The output strings must not contain "\n".
          line.chomp!
          case line
          when BEGIN_MARKER
            @inside_output = true
            $stderr.puts 'Found the begin marker.' if $DEBUG
          when END_MARKER
            @inside_output = false
            $stderr.puts 'Found the end marker.' if $DEBUG
          else
            if @inside_output
              @queue_mutex.synchronize { @queue << line }
              $stderr.puts "<#{line}> added to the queue." if $DEBUG
            end
          end
        end
      end # thread
    end # start_reader
    
    # This method may be utilized to keep the TT process alive.
    # Check here if TT returns the exit code 1 in case on invalide options.
    def new_pipe
      IO.popen(@cmdline, 'r+')
    end

    # Convert token arrays to delimited strings.
    def convert(input)
      unless input.is_a?(Array) || input.is_a?(String)
        fail UserError, "Not a valid input format: <#{input.class}>!"
      end

      if input.empty?
        fail UserError, "Empty input is not allowed!"
      end
      
      if input.is_a?(Array)
        input.each do |el|
          unless el.is_a?(String)
            fail UserError, "Input elements should be strings!"
          end
        end
        input = input.join("\n")
      end
      
      input
    end
    
    def sanitize(str)
      line = str.strip
      if line.size == 0
        line = '<BLANK />'
      end

      line
    end
  end # class
end # module

__END__
- tokenization
- lexicon lookup
- tagging
- error correction
