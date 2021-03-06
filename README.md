# TreeTagger for Ruby

[RubyGems](http://rubygems.org/gems/treetagger-ruby) | [RTT Project Page](http://bu.chsta.be/projects/treetagger-ruby/) |
[Source Code](https://github.com/arbox/treetagger-ruby) | [Bug Tracker](https://github.com/arbox/treetagger-ruby/issues)

[<img src="https://badge.fury.io/rb/treetagger-ruby.png" alt="Gem Version" />](http://badge.fury.io/rb/treetagger-ruby)
[<img src="https://travis-ci.org/arbox/treetagger-ruby.png" alt="Build Status" />](https://travis-ci.org/arbox/treetagger-ruby)
[<img src="https://codeclimate.com/github/arbox/treetagger-ruby.png" alt="Code Climate" />](https://codeclimate.com/github/arbox/treetagger-ruby)

## DESCRIPTION
A Ruby based wrapper for the TreeTagger by Helmut Schmid.

Check it out if you are interested in Natural Language Processing (NLP) and/or Human Language Technology (HLT).

This library provides comprehensive bindings for the
[TreeTagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/),
a statistical language independed POS tagging and chunking software.

TreeTagger is language agnostic, it will never guess what language you're going to use.

The tagger is described in the following two papers:

* Helmut Schmid (1995): [Improvements in Part-of-Speech Tagging with an Application to German.](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data/tree-tagger2.pdf) Proceedings of the ACL SIGDAT-Workshop. Dublin, Ireland.

* Helmut Schmid (1994): [Probabilistic Part-of-Speech Tagging Using Decision Trees.](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data/tree-tagger1.pdf) Proceedings of International Conference on New Methods in Language Processing, Manchester, UK.

### INSTALLATION
Before you install the <tt>treetagger-ruby</tt> package please ensure
you have downloaded and installed the
[TreeTagger](http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/)
itself.

The [TreeTagger](http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/)
is a copyrighted software by Helmut Schmid and
[IMS](http://www.ims.uni-stuttgart.de/), please read the license
agreament before you download the TreeTagger package and language models.

After the installation of the <tt>TreeTagger</tt> set the environment variable
<tt>TREETAGGER_BINARY</tt> to the location where the binary <tt>tree-tagger</tt>
resides. Usually this binary is located under the <tt>bin</tt> directory in the
main installation directory of the <tt>TreeTagger</tt>.

Also you have to set the variable <tt>TREETAGGER_MODEL</tt> to the location of
the appropriate language model you have acquired in the training step.

For instance you may add the following lines to your <tt>.profile</tt> file:

    export TREETAGGER_BINARY='/path/to/your/TreeTagger/bin/tree-tagger'
    export TREETAGGER_MODEL='/path/to/your/TreeTagger/lib/german.par'

It is convinient to work with a default language model, but you can change
it every time during the instantiation of a new tagger instance.

`treetagger-ruby` is provided as a `.gem` package. Simply install it via
[RubyGems](http://rubygems.org/gems/treetagger-ruby).
To install <tt>treetagger-ruby</tt> issue the following command:
  $ gem install treetagger-ruby

If you want to do a system wide installation, do this as root
(possibly using `sudo`).

Alternatively use your Gemfile for dependency management.


## SYNOPSIS
### Basic Usage

Basic usage is very simple:

    $ require 'treetagger'
    $ # Instantiate a tagger instance with default values.
    $ tagger = TreeTagger::Tagger.new
    $ # Process an array of tokens.
    $ tagger.process(%w{Ich gehe in die Schule})
    $ # Flush the pipeline.
    $ tagger.flush
    $ # Get the processed data.
    $ tagger.get_output

### Input Format

Basically you have to provide a tokenized sequence with possibly some additional
information on lexical classes of tokens and on their probabilities. Every token
has to be on a separate line. Due to technical limitations SGML tags
(i.e. sequences with heading < and trailing >) cannot be valid tokens since
they are used internally for delimiting meaningful content from flush tokens.
It implies the use of the <tt>-sgml</tt> option which cannot be changes by user.
It is a limitation of <em>this</em> library. If you do need to process tags,
fall back and use the TreeTagger as a standalone programm possibly employing
temp files to store your input and output. This behaviour will be also
implemented in futher versions of <tt>treetagger-ruby</tt>.

Every token may occure alone on the line or be followed by additional
information:
* token;
* token (\\tab tag)+;
* token (\\tab tag \\space lemma)+;
* token (\\tab tag \\space probability)+;
* token (\\tab tag \\space probability \\space lemma)+.

You input may look like the following sentence:
  Die     ART 0.99
  neuen   ADJA neu
  Hunde  NN NP
  stehen  VVFIN 0.99 stehen
  an
  den
  Mauern  NN Mauer
  .


This wrapper accepts the input as `String` or `Array`.

If you want to use strings, you are responsible for the proper delimiters inside
the string: <tt>"Die\\tART 0.99\\nneuen\\tADJA neu\\nHunde\\tNN NP\\nstehen\\t
VVFIN 0.99 stehen\\nan\\nden\\nMauern\\tNN Mauer\\n.\\n"</tt>
Now <tt>treetagger-ruby</tt> does not check your markup for correctness and will
possibly report a <tt>TreeTagger::ExternalError</tt> if the TreeTagger process
die due to input errors.

Using arrays is more convinient since they can be built programmatically.

Arrays should have the following structure:
* ['token', 'token', 'token'];
* ['token', ['token', ['POS', 'lemma'], ['POS', 'lemma']], 'token'];
* ['token', ['token', ['POS', prob], ['POS', 'prob']], 'token'];
* ['token', ['token', ['POS', prob, 'lemma'], ['POS', 'prob', 'lemma']]].

It is internally converted in the sequence <tt>token\\ntoken\\tPOS lemma\\t
POS lemma\\ntoken\\n</tt>, i.e. in the enriched version alternatives are
tab separated and entries a blank separated.

Note that probabilities may be strings or integers.

The lexicon lookup is *not* implemented for now, that's the latter three forms
of input arrays are not supported yet.

### Output Format
For now you'll get an array with strings elements. However the precise string
structure depends on the command line arguments you've provided during the tagger
instantiation.

For instanse for the input <tt>["Veruntreute", "die", "AWO", "Spendengeld", "?"]
</tt> you'll get the following output with default cmd argumetns:

<tt>["Veruntreute\tNN\tVeruntreute", "die\tART\td", "AWO\tNN\t<unknown>",
"Spendengeld\tNN\tSpendengeld", "?\t$.\t?"]</tt>

See documentation in the TreeTagger::Tagger class for details
on particular methods.

## Exception Hierarchy

While using TreeTagger you can face following errors:
* `TreeTagger::UserError`;
* `TreeTagger::RuntimeError`;
* `TreeTagger::ExternalError`.

This three kinds of errors all subclass <tt>TreeTagger::Error</tt>, which
in turn is a subclass of <tt>StandardError</tt>. For an end user this means that
it is possible to intercept all errors from `treetagger-ruby` with
a simple `rescue` clause.

### Implemented Features

Please have a look at the [CHANGELOG](CHANGELOG.rdoc) file for details on implemented
and planned features.


## SUPPORT
If you have question, bug reports or any suggestions, please drop me an email :)

## HOW TO CONTRIBUTE
Please contact me and suggest your ideas, report bugs, talk to me, if you want
to implement some features in the future releases of this library.

Please don't feel offended if I cannot accept all your pull requests, I have
to review them and find the appropriate time and place in the code base to
incorporate your valuable changes.

Any help is deeply appreciated!

## LICENSE

RTT is a copyrighted software by Andrei Beliankou, 2011-

You may use, redistribute and change it under the terms
provided in the [LICENSE](LICENSE.rdoc) file.


# TODO:

* How to use TreeTagger in the wild;
* Input and output format, tokenization;
* The actual german parameter file has been estimated on one byte encoded data.
