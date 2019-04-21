require 'regex_generator/version'
require 'byebug'
require 'regex_generator/generator'
require 'regex_generator/characters_recognizer'
require 'regex_generator/target'
require 'regex_generator/exceptions'

module RegexGenerator
  # Generates regex by text and target text
  #
  # @param target [String, Integer, Float, Hash] what you want to find
  # @param text [String] source text
  # @param options [Hash] options to generate regex with
  # @option options [true, false] :exact_target to generate regex
  #   with exact target value
  # @option options [:ahead, :behind] :look to generate regex with text before
  #   or after the target
  # @option options [true, false] :strict_count to generate regex with a strict
  #   chars count
  # @option options [String, Hash] :title to generate regex for provided title
  # @return [Regexp]
  #
  # @example Generate regex
  #   RegexGenerator.generate('45', 'some text 45') #=> /[a-z]+\s[a-z]+(\d+)/
  def self.generate(target, text, options = {})
    RegexGenerator::Generator.new(target, text, options).generate
  end
end
